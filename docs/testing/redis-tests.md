# Tests de Redis

## Propósito
Verificar que Redis se configura, levanta y persiste correctamente en el entorno Docker.

## Requisitos previos
- Docker / Docker Compose instalado y en ejecución
- Bash >= 4.0 (WSL o Git Bash en Windows)
- Variables de entorno configuradas en `.env` (especialmente `REDIS_PASSWORD`)
- WSL integrado con Docker Desktop (Windows)

## Estructura de tests

```
scripts/tests/redis/
├── test_redis_config.sh      # Verifica redis.conf
├── test_healthcheck.sh        # Verifica healthcheck en docker-compose
├── test_service_startup.sh    # Verifica que el servicio levanta
├── test_persistence.sh        # Verifica persistencia AOF
├── test_seed_integrity.sh     # Verifica integridad del seed (200 usuarios, 25 puntos)
├── run_test.sh                # Helper para ejecutar tests individuales con contexto correcto
└── run_all.sh                 # Ejecuta todos los tests

scripts/tests/
└── test_cross_validation.sh   # Valida consistencia entre PostgreSQL y Redis
```

## Ejecutar tests

### Suite completa de Redis
```bash
# Ejecuta todos los tests de Redis (incluye test_seed_integrity)
bash scripts/tests/redis/run_all.sh
```

### Tests individuales
```bash
# Configuración
bash scripts/tests/redis/test_redis_config.sh

# Healthcheck
bash scripts/tests/redis/test_healthcheck.sh

# Startup
bash scripts/tests/redis/test_service_startup.sh

# Persistencia
bash scripts/tests/redis/test_persistence.sh

# Integridad del seed
bash scripts/tests/redis/test_seed_integrity.sh

# Validación cruzada Postgres ↔ Redis
bash scripts/tests/test_cross_validation.sh
```

### Usando el helper run_test.sh
```bash
# El helper carga .env y ejecuta desde el directorio correcto
./scripts/tests/redis/run_test.sh test_seed_integrity
./scripts/tests/redis/run_test.sh test_seed_integrity --verbose
```

### Desde PowerShell (Windows con WSL)
```powershell
bash scripts/tests/redis/run_all.sh
```

## Qué verifica cada test

### test_redis_config.sh
Valida que `docker/redis/redis.conf` existe y contiene:
- `appendonly yes` — AOF habilitado
- `appendfsync everysec` — sincronización cada segundo
- `requirepass` — autenticación configurada
- `maxmemory` — límite de memoria establecido

**Salida esperada:**
```
Starting Redis configuration test...
✅ redis.conf válido
Redis configuration test passed successfully!
```

### test_healthcheck.sh
Valida que `docker/docker.compose.yml` contiene:
- Sección `healthcheck` en el servicio `redis`
- Test command con `redis-cli PING`
- Parámetros: `interval`, `timeout`, `retries`

**Salida esperada:**
```
Starting Redis healthcheck test...
✅ Healthcheck configurado correctamente
Redis healthcheck test passed successfully!
```

### test_service_startup.sh
Verifica que el servicio:
- Se levanta correctamente con `docker compose up -d redis`
- Responde a `PING` en menos de 30 segundos
- El healthcheck eventualmente pasa (puede estar en `starting` durante primeros 30s)

**Salida esperada:**
```
Starting Redis service startup test...
Redis service is up and responding to PING.
⚠️  Healthcheck status: starting (puede estar en progreso)
✅ Service started successfully and is healthy.
```

### test_persistence.sh
Verifica que:
- Se puede escribir una clave (`SET test:persist "test-data"`)
- Se ejecuta `BGSAVE` correctamente
- Tras reiniciar el contenedor, la clave persiste
- `GET test:persist` devuelve el valor original

**Salida esperada:**
```
Starting Redis persistence test...
SET key 'test:persist' with value 'test-data'
BGSAVE completed
Container restarted
Persistence verified: value retrieved successfully (test-data)
```

### test_seed_integrity.sh
Verifica la integridad completa del seed de datos cargado en Redis:

**Validaciones:**
- ✓ Exactamente 200 usuarios en el índice geoespacial `users:geo`
- ✓ Al menos 25 puntos de recolección distribuidos en 5 rutas
- ✓ Estructura correcta de usuarios (nombre, colonia_id, fcm_token, lat, lon)
- ✓ Estructura correcta de puntos (ruta_id, lat, lon, label)
- ✓ Metadatos del seed (timestamp, totales)

**Ejecución:**
```bash
# Usar configuración de .env
./scripts/tests/redis/test_seed_integrity.sh

# Con contenedor personalizado
./scripts/tests/redis/test_seed_integrity.sh --container redis_cache

# Con ayuda
./scripts/tests/redis/test_seed_integrity.sh --help
```

**Salida esperada:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Redis Seed Integrity Test
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ℹ Configuration: Container='redis_cache' DB=0

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Docker & Redis Connection Test
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ℹ Docker found: Docker version 29.1.2, build 890dcca
✓ Container 'redis_cache' is running
✓ Connected to Redis via docker exec

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Users Validation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ℹ Users in users:geo index: 200 / 200
✓ User count validation passed
✓ User 100 structure valid: Usuario_100 (lat=16.58918, lon=-93.05416)
✓ User 199 structure valid: Usuario_199 (lat=16.60048, lon=-93.05282)
✓ User 299 structure valid: Usuario_299 (lat=16.56940, lon=-93.04532)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Collection Points Validation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ℹ Route 1: 5 points
ℹ Route 2: 5 points
ℹ Route 3: 5 points
ℹ Route 4: 5 points
ℹ Route 5: 5 points
ℹ Total collection points: 25 / ~25
✓ Points count validation passed
✓ Point point:1 structure valid: Route 1 - Punto_1_Centro_Histórico
✓ Point point:12 structure valid: Route 3 - Punto_12_Las_Palmas
✓ Point point:25 structure valid: Route 5 - Punto_25_Jardines_del_Valle

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Seed Metadata Validation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Seed generated at: Sat Jan 31 14:42:38 CST 2026
✓ Metadata: 200 users, 25 points

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Test Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ All seed integrity validations passed!

✓ Exactly 200 users in users:geo
✓ At least 25 collection points
✓ All required fields present and valid
✓ Data structures consistent
```

**Exit Codes:**
- `0` - ✅ Todos los tests pasaron
- `1` - ❌ Validación falló (datos incorrectos/incompletos)
- `2` - ⚙️ Error de configuración (Docker no disponible, contenedores no corriendo)

### test_cross_validation.sh
Valida la consistencia de datos entre PostgreSQL y Redis:

**Validaciones:**
- ✓ Usuarios en Redis (IDs 100-299) existen en PostgreSQL
- ✓ Colonias referenciadas en Redis existen en PostgreSQL
- ✓ Rutas referenciadas en Redis existen en PostgreSQL
- ✓ Coordenadas geográficas son válidas (lat: -90 a 90, lon: -180 a 180)

**Ejecución:**
```bash
# Usar configuración de .env
bash scripts/tests/test_cross_validation.sh

# Con contenedores personalizados
bash scripts/tests/test_cross_validation.sh --db-container postgres_db --redis-container redis_cache
```

**Salida esperada:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PostgreSQL ↔ Redis Cross-Validation Test
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ℹ PostgreSQL: postgres_db (proyecto_recolecta)
ℹ Redis: redis_cache

✓ Container 'postgres_db' is running
✓ Connected to PostgreSQL
✓ Container 'redis_cache' is running
✓ Connected to Redis

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Users Consistency Validation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ℹ PostgreSQL users (IDs 100-299): 200
ℹ Redis users in users:geo: 200
✓ User 100 exists in both databases
✓ User 150 exists in both databases
✓ User 199 exists in both databases

✓ All cross-validations passed!
✓ Users in Redis match PostgreSQL
✓ Colonies referenced exist in PostgreSQL
✓ Routes referenced exist in PostgreSQL
✓ Geolocation coordinates valid
✓ No data inconsistencies detected
```
```
Starting Redis persistence test...
SET key 'test:persist' with value 'test-data'
BGSAVE completed
Container restarted
Persistence verified: value retrieved successfully (test-data)
```

## Salida completa exitosa

```bash
Executing all Redis tests...
==================================
Starting Redis configuration test...
Redis configuration test passed successfully!
Starting Redis healthcheck test...
Redis healthcheck test passed successfully!
Starting Redis service startup test...
[+] Running 1/1
 ✔ Container redis_cache  Running                                                                                        
Redis service is up and responding to PING.
⚠️  Healthcheck status: starting (puede estar en progreso)
✅ Service started successfully and is healthy.
Starting Redis persistence test...
SET key 'test:persist' with value 'test-data'
BGSAVE completed
Container restarted
Persistence verified: value retrieved successfully (test-data)
==================================
All tests passed successfully!
```

## 🛠 Helper Scripts

### run_test.sh
Script auxiliar para ejecutar tests individuales de forma conveniente sin especificar rutas completas.

**Uso:**
```bash
# Ejecutar test individual desde cualquier ubicación
bash scripts/tests/redis/run_test.sh connection

# Ver tests disponibles
bash scripts/tests/redis/run_test.sh --help
```

**Tests disponibles:**
- `connection` - Verificar conectividad con Redis
- `persistence` - Verificar persistencia AOF
- `seed-integrity` - Validar integridad del seed (200 usuarios, 25 puntos)

**Ejemplo de salida:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Running Test: connection
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[... output del test ...]
✓ All tests passed!
```

## Troubleshooting

### Error: "AUTH failed: WRONGPASS"
**Causa:** La variable `REDIS_PASSWORD` no está cargada o es incorrecta.

**Solución:**
```bash
# Verificar el valor en .env
grep REDIS_PASSWORD .env

# En PowerShell, cargar manualmente
$Env:REDIS_PASSWORD='r3d1s_s3cur3_p4ss'

# En bash
export REDIS_PASSWORD='r3d1s_s3cur3_p4ss'
```

### Error: "docker-compose: command not found"
**Causa:** Docker no está integrado con WSL.

**Solución:**
1. Abre Docker Desktop
2. Settings → Resources → WSL Integration
3. Habilita integración con Ubuntu
4. Aplica y reinicia Docker Desktop

### Error: "Healthcheck not found"
**Causa:** El script no encuentra la configuración (problema de path o formato YAML).

**Solución:**
- Verifica que ejecutas desde la raíz del proyecto
- Verifica que `docker/docker.compose.yml` existe y tiene formato correcto

### Warning: "Healthcheck status: starting"
**Causa:** El healthcheck aún no ha completado su primer check (normal en primeros 30s).

**Solución:** No es un error. Si el servicio responde a PING, está funcionando. El healthcheck eventualmente pasará a `healthy`.

## Integración continua (CI)

Estos tests pueden ejecutarse en GitHub Actions para validar automáticamente cada PR/push.

Ver: [GitHub Actions para Redis](#github-actions) (próxima sección)

## Mantenimiento

### Actualizar tests cuando cambies:
- `docker/redis/redis.conf` → revisar `test_redis_config.sh`
- `docker/docker.compose.yml` (redis service) → revisar `test_healthcheck.sh`
- Contraseña de Redis → actualizar `.env` y `test_persistence.sh`

### Añadir nuevos tests
1. Crear script en `scripts/tests/redis/test_nuevo.sh`
2. Añadirlo a `run_all.sh`
3. Documentar en esta guía

## Referencias
- [Redis Persistence](https://redis.io/docs/management/persistence/)
- [Docker Compose Healthchecks](https://docs.docker.com/compose/compose-file/compose-file-v3/#healthcheck)
- [Redis Configuration](https://redis.io/docs/management/config/)
