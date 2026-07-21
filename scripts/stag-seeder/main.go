package main

import (
	"context"
	"encoding/json"
	"fmt"
	"math/rand"
	"os"
	"path/filepath"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/redis/go-redis/v9"
	"golang.org/x/crypto/bcrypt"
)

type Citizen struct {
	ID       int
	Email    string
	Alias    string
	Password string
}

type Domicilio struct {
	Alias       string
	Calle       string
	Numero      string
	Referencia  string
	CiudadanoID int
	ColoniaID   int
}

var passwordHash string

func init() {
	// Hashear una sola vez para ahorrar CPU
	hash, err := bcrypt.GenerateFromPassword([]byte("password123"), 10)
	if err != nil {
		panic(err)
	}
	passwordHash = string(hash)
}

func main() {
	fmt.Println("[stag-seeder] Starting Staging Seeder...")

	tokensFile := "/shared/tokens.json"
	seedingDoneFile := "/shared/seeding_done"

	// 1. Esperar a que el archivo de tokens exista y tenga datos
	fmt.Printf("[stag-seeder] Waiting for FCM tokens from clients at '%s'...\n", tokensFile)
	for {
		if _, err := os.Stat(tokensFile); err == nil {
			bytes, err := os.ReadFile(tokensFile)
			if err == nil && len(bytes) > 2 {
				// El archivo ya tiene tokens
				break
			}
		}
		time.Sleep(2 * time.Second)
	}

	fmt.Println("[stag-seeder] FCM tokens file detected! Reading tokens...")
	bytes, err := os.ReadFile(tokensFile)
	if err != nil {
		panic(fmt.Sprintf("failed to read tokens file: %v", err))
	}

	var tokensMap map[string]string
	if err := json.Unmarshal(bytes, &tokensMap); err != nil {
		panic(fmt.Sprintf("failed to parse tokens JSON: %v", err))
	}

	fmt.Printf("[stag-seeder] Loaded %d real FCM tokens. Initializing database connections...\n", len(tokensMap))

	// 2. Conectar a PostgreSQL
	dbUser := os.Getenv("DB_USER")
	dbPassword := os.Getenv("DB_PASSWORD")
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	dbName := os.Getenv("DB_NAME")

	dsn := fmt.Sprintf("postgres://%s:%s@%s:%s/%s?sslmode=disable", dbUser, dbPassword, dbHost, dbPort, dbName)
	ctx := context.Background()

	var pgPool *pgxpool.Pool
	for i := 1; i <= 10; i++ {
		pgPool, err = pgxpool.New(ctx, dsn)
		if err == nil {
			err = pgPool.Ping(ctx)
			if err == nil {
				break
			}
		}
		fmt.Printf("[stag-seeder] PostgreSQL not ready (attempt %d/10). Retrying...\n", i)
		time.Sleep(3 * time.Second)
	}
	if err != nil {
		panic(fmt.Sprintf("failed to connect to PostgreSQL: %v", err))
	}
	defer pgPool.Close()
	fmt.Println("[stag-seeder] Connected to PostgreSQL successfully.")

	// 3. Conectar a Redis
	redisHost := os.Getenv("REDIS_HOST")
	redisPort := os.Getenv("REDIS_PORT")
	rdb := redis.NewClient(&redis.Options{
		Addr: fmt.Sprintf("%s:%s", redisHost, redisPort),
	})
	if err := rdb.Ping(ctx).Err(); err != nil {
		panic(fmt.Sprintf("failed to connect to Redis: %v", err))
	}
	defer rdb.Close()
	fmt.Println("[stag-seeder] Connected to Redis successfully.")

	// 4. Limpiar datos previos para Staging (Staging de cero)
	fmt.Println("[stag-seeder] Cleaning previous citizens, domiciles, routes, and points...")
	cleanupQueries := []string{
		"TRUNCATE TABLE domicilio, ciudadano RESTART IDENTITY CASCADE;",
		"TRUNCATE TABLE punto_recoleccion, ruta RESTART IDENTITY CASCADE;",
		"TRUNCATE TABLE colonia RESTART IDENTITY CASCADE;",
	}
	for _, query := range cleanupQueries {
		if _, err := pgPool.Exec(ctx, query); err != nil {
			panic(fmt.Sprintf("failed to run cleanup query '%s': %v", query, err))
		}
	}
	rdb.FlushAll(ctx) // Limpiar Redis por completo

	// 5. Sembrar 10 Colonias y 10 Rutas
	fmt.Println("[stag-seeder] Seeding 10 colonias and 10 routes...")
	coloniaIDs := make([]int, 10)
	rutaIDs := make([]int, 10)

	for i := 1; i <= 10; i++ {
		colName := fmt.Sprintf("Colonia Staging %d", i)
		rutaName := fmt.Sprintf("Ruta Staging %d", i)

		// Insertar Colonia
		err = pgPool.QueryRow(ctx, "INSERT INTO colonia (nombre, zona) VALUES ($1, $2) RETURNING colonia_id", colName, "Zona Staging").Scan(&coloniaIDs[i-1])
		if err != nil {
			panic(err)
		}

		// Insertar Ruta
		jsonRuta := fmt.Sprintf(`{"zona":"Staging","ruta_id":%d}`, i)
		err = pgPool.QueryRow(ctx, "INSERT INTO ruta (nombre, descripcion, colonia_id, json_ruta) VALUES ($1, $2, $3, $4) RETURNING id", rutaName, "Ruta de prueba de Staging", colName, jsonRuta).Scan(&rutaIDs[i-1])
		if err != nil {
			panic(err)
		}
	}

	// 6. Sembrar Puntos de Recolección (40 paradas en promedio por ruta = 400 paradas totales)
	fmt.Println("[stag-seeder] Seeding 40 points per route and preparing 50,000 citizens...")
	ciudadanos := make([]Citizen, 0, 50000)
	domicilios := make([]Domicilio, 0, 50000)

	latBase := 20.659698
	lonBase := -103.349609
	citizenIDCounter := 1

	redisPipe := rdb.Pipeline()

	for rIdx, rutaID := range rutaIDs {
		routeNum := rIdx + 1
		token := tokensMap[fmt.Sprintf("%d", routeNum)]
		if token == "" {
			token = "token_mock_fallback_route_" + fmt.Sprintf("%d", routeNum)
		}

		pointIDsInRoute := make([]string, 40)

		for p := 1; p <= 40; p++ {
			// Generar trayectoria lineal ordenada para los puntos
			lat := latBase + float64(routeNum)*0.015 + float64(p)*0.001
			lon := lonBase + float64(routeNum)*0.015 + float64(p)*0.001

			direccion := fmt.Sprintf("Parada %d - Ruta Staging %d", p, routeNum)

			// Insertar en Postgres
			var puntoID int
			err = pgPool.QueryRow(ctx, "INSERT INTO punto_recoleccion (ruta_id, direccion, orden) VALUES ($1, $2, $3) RETURNING id", rutaID, direccion, float64(p)).Scan(&puntoID)
			if err != nil {
				panic(err)
			}

			puntoIDStr := fmt.Sprintf("%d", puntoID)
			pointIDsInRoute[p-1] = puntoIDStr

			// Guardar punto en Redis
			redisPipe.HSet(ctx, fmt.Sprintf("point:%d", puntoID), map[string]interface{}{
				"route_id": rutaID,
				"lat":      lat,
				"lon":      lon,
				"label":    direccion,
			})

			// Generar 125 ciudadanos alrededor de este punto (125 * 40 * 10 = 50,000 ciudadanos totales)
			for c := 1; c <= 125; c++ {
				cID := citizenIDCounter
				citizenIDCounter++

				alias := fmt.Sprintf("ciudadano_%d", cID)
				email := fmt.Sprintf("user%d@stag.com", cID)

				ciudadanos = append(ciudadanos, Citizen{
					ID:       cID,
					Email:    email,
					Alias:    alias,
					Password: passwordHash,
				})

				// Ubicación con offset aleatorio de ~30m para el domicilio
				offsetLat := (rand.Float64() - 0.5) * 0.0006
				offsetLon := (rand.Float64() - 0.5) * 0.0006
				latDom := lat + offsetLat
				lonDom := lon + offsetLon

				domicilios = append(domicilios, Domicilio{
					Alias:       "Casa Staging",
					Calle:       fmt.Sprintf("Calle Staging %d", cID),
					Numero:      fmt.Sprintf("%d", 10+c),
					Referencia:  "Cerca de parada de recolección",
					CiudadanoID: cID,
					ColoniaID:   coloniaIDs[rIdx],
				})

				// Guardar en Redis
				userKey := fmt.Sprintf("user:%d", cID)
				redisPipe.HSet(ctx, userKey, map[string]interface{}{
					"fcm_token":      token,
					"fcm_status":     "valid",
					"fcm_created_at": time.Now().Format(time.RFC3339),
					"fcm_expires_at": time.Now().Add(365 * 24 * time.Hour).Format(time.RFC3339),
					"updated_at":     time.Now().Format(time.RFC3339),
				})
				redisPipe.GeoAdd(ctx, "users:geo", &redis.GeoLocation{
					Name:      fmt.Sprintf("%d", cID),
					Latitude:  latDom,
					Longitude: lonDom,
				})
			}
		}

		// Guardar orden de puntos de la ruta en Redis
		routePointsKey := fmt.Sprintf("route:points:%d", rutaID)
		for _, pid := range pointIDsInRoute {
			redisPipe.RPush(ctx, routePointsKey, pid)
		}
	}

	// 7. Ejecutar Pipeline en Redis
	fmt.Println("[stag-seeder] Executing Redis pipeline...")
	if _, err := redisPipe.Exec(ctx); err != nil {
		panic(fmt.Sprintf("failed to execute Redis pipeline: %v", err))
	}
	fmt.Println("[stag-seeder] Redis data seeded successfully.")

	// 8. Bulk Copy en PostgreSQL
	fmt.Println("[stag-seeder] Copying 50,000 citizens to PostgreSQL...")
	_, err = pgPool.CopyFrom(
		ctx,
		pgx.Identifier{"ciudadano"},
		[]string{"id", "email", "alias", "password"},
		pgx.CopyFromSlice(len(ciudadanos), func(i int) ([]interface{}, error) {
			return []interface{}{
				ciudadanos[i].ID,
				ciudadanos[i].Email,
				ciudadanos[i].Alias,
				ciudadanos[i].Password,
			}, nil
		}),
	)
	if err != nil {
		panic(fmt.Sprintf("failed to bulk copy citizens: %v", err))
	}

	fmt.Println("[stag-seeder] Copying 50,000 domiciles to PostgreSQL...")
	_, err = pgPool.CopyFrom(
		ctx,
		pgx.Identifier{"domicilio"},
		[]string{"alias", "calle", "numero", "referencia", "ciudadano_id", "colonia_id"},
		pgx.CopyFromSlice(len(domicilios), func(i int) ([]interface{}, error) {
			return []interface{}{
				domicilios[i].Alias,
				domicilios[i].Calle,
				domicilios[i].Numero,
				domicilios[i].Referencia,
				domicilios[i].CiudadanoID,
				domicilios[i].ColoniaID,
			}, nil
		}),
	)
	if err != nil {
		panic(fmt.Sprintf("failed to bulk copy domiciles: %v", err))
	}

	fmt.Println("[stag-seeder] PostgreSQL data seeded successfully.")

	// 9. Crear archivo señalizador de finalización
	fsDone, err := os.Create(seedingDoneFile)
	if err != nil {
		panic(err)
	}
	fsDone.Close()

	fmt.Println("[stag-seeder] Seeding Completed Successfully! Staging environment is ready.")
}
