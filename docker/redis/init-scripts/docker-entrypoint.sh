#!/bin/sh
# ============================================================================
# docker-entrypoint.sh - Entrypoint personalizado para Redis con auto-seeding
# ============================================================================
# Este script inicia Redis en background, ejecuta el seeding condicional,
# y luego mantiene Redis en foreground
# ============================================================================

set -e

# Iniciar Redis en background
redis-server /usr/local/etc/redis/redis.conf --requirepass "${REDIS_PASSWORD}" &
REDIS_PID=$!

# Esperar a que Redis esté disponible
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Esperando a Redis..."
for i in $(seq 1 30); do
    if redis-cli -a "${REDIS_PASSWORD}" ping > /dev/null 2>&1; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Redis disponible"
        break
    fi
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Intento $i/30..."
    sleep 1
done

# Verificar si Redis está vacío
DBSIZE=$(redis-cli -a "${REDIS_PASSWORD}" DBSIZE 2>/dev/null | grep -o '[0-9]*' || echo "0")

if [ "$DBSIZE" -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Redis vacío - inicializando datos..."
    
    # Instalar sh si no existe (Alpine usa sh por defecto)
    if ! command -v sh >/dev/null 2>&1; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Instalando shell..."
        apk add --no-cache busybox
    fi
    
    # Buscar seed más reciente
    SEED_FILE=""
    if [ -L "/seeds/redis-seed-latest.txt" ]; then
        SEED_FILE="/seeds/redis-seed-latest.txt"
    else
        SEED_FILE=$(ls -t /seeds/redis-seed_v1_*.txt 2>/dev/null | head -1)
    fi
    
    # Generar seed si no existe ninguno
    if [ -z "$SEED_FILE" ] || [ ! -f "$SEED_FILE" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] No se encontró seed - generando..."
        sh /docker-entrypoint-initdb.d/generate-seed-data.sh
        
        # Re-buscar después de generar
        if [ -L "/seeds/redis-seed-latest.txt" ]; then
            SEED_FILE="/seeds/redis-seed-latest.txt"
        else
            SEED_FILE=$(ls -t /seeds/redis-seed_v1_*.txt 2>/dev/null | head -1)
        fi
    fi
    
    # Cargar datos
    if [ -n "$SEED_FILE" ] && [ -f "$SEED_FILE" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cargando datos desde: $(basename "$SEED_FILE")..."
        
        grep -v '^#' "$SEED_FILE" | grep -v '^$' | while IFS= read -r line; do
            echo "$line" | xargs redis-cli -a "${REDIS_PASSWORD}" 2>&1 | grep -i "error" || true
        done
        
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Carga completada"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ⚠ Seed file no encontrado después de generación"
    fi
    
    # Verificar carga
    NEW_DBSIZE=$(redis-cli -a "${REDIS_PASSWORD}" DBSIZE 2>/dev/null | grep -o '[0-9]*')
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Redis ahora tiene $NEW_DBSIZE claves"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Redis ya contiene datos ($DBSIZE claves) - saltando inicialización"
fi

# Detener Redis background
kill $REDIS_PID
wait $REDIS_PID

# Iniciar Redis en foreground
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando Redis en modo foreground..."
exec redis-server /usr/local/etc/redis/redis.conf --requirepass "${REDIS_PASSWORD}"
