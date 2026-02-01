#!/bin/sh
# ============================================================================
# load-redis.sh - Cargador de datos en Redis
# ============================================================================
# Carga el seed generado en la instancia de Redis
# Uso: ./load-redis.sh [redis-host] [redis-port] [redis-password]
# ============================================================================
# Cargador de datos en Redis
# Uso: ./load-redis.sh [redis-host] [redis-port] [redis-password]
# ============================================================================

set -e

# Configuración
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SEEDS_DIR="$SCRIPT_DIR/../seeds"

# Buscar el archivo seed más reciente
if [ -L "$SEEDS_DIR/redis-seed-latest.txt" ]; then
    SEED_FILE="$SEEDS_DIR/redis-seed-latest.txt"
else
    SEED_FILE=$(ls -t "$SEEDS_DIR"/redis-seed_v1_*.txt 2>/dev/null | head -1)
    
    if [ -z "$SEED_FILE" ]; then
        SEED_FILE="$SEEDS_DIR/redis-seed.txt"
    fi
fi

# Parámetros
REDIS_HOST="${1:-localhost}"
REDIS_PORT="${2:-6379}"
REDIS_PASSWORD="${3:-}"
REDIS_DB="${4:-0}"

# Export auth to avoid passing password on command line (safer)
if [ -n "$REDIS_PASSWORD" ]; then
    export REDISCLI_AUTH="$REDIS_PASSWORD"
fi

# Concise status on stdout, detailed info on stderr
echo "[CARGANDO] Iniciando carga de datos en Redis..."
echo "[DETALLE] Host: $REDIS_HOST:$REDIS_PORT | DB: $REDIS_DB" >&2

# Validar que el archivo existe
if [ ! -f "$SEED_FILE" ]; then
    echo "[ERROR] archivo de seed no encontrado: $SEED_FILE"
    echo "[DETALLE] Ejecute primero: generate-seed-data.sh" >&2
    exit 1
fi

# Construir comando redis-cli (no pasar contraseña en args)
REDIS_CMD="redis-cli -h $REDIS_HOST -p $REDIS_PORT -n $REDIS_DB"

# Verificar conectividad
if ! $REDIS_CMD ping > /dev/null 2>&1; then
    echo "[ERROR] No se puede conectar a Redis en $REDIS_HOST:$REDIS_PORT"
    echo "[DETALLE] Revise que Redis esté en ejecución y la contraseña (REDIS_PASSWORD)" >&2
    exit 1
fi

echo "[OK] Conexión a Redis establecida"

# Procesar y ejecutar comandos del seed
COLLECTION=""
LINE_COUNT=0
ERROR_COUNT=0

while IFS= read -r line; do
    # Detectar inicio de colección
    if echo "$line" | grep -q '^#\ ='; then
        read -r nextline
        if echo "$nextline" | grep -q '^#'; then
            NEW_COLLECTION=$(echo "$nextline" | sed 's/^# //')
            if [ "$COLLECTION" != "$NEW_COLLECTION" ]; then
                COLLECTION="$NEW_COLLECTION"
                echo "[CARGANDO] --- Cargando colección: $COLLECTION ---"
                echo "[DETALLE] --- Cargando colección: $COLLECTION ---" >&2
            fi
        fi
        continue
    fi
    
    echo "$line" | grep -q '^#' && continue
    [ -z "$line" ] && continue
    
    if ! eval "$REDIS_CMD $line" > /dev/null 2>&1; then
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
    LINE_COUNT=$((LINE_COUNT + 1))
    
    if [ $((LINE_COUNT % 500)) -eq 0 ]; then
        echo "[DETALLE] Procesados $LINE_COUNT comandos..." >&2
    fi
    if [ $((LINE_COUNT % 1000)) -eq 0 ]; then
        echo "[DETALLE] Tanda de $LINE_COUNT comandos cargada" >&2
    fi

done < "$SEED_FILE"

# Mensaje final
if [ "$ERROR_COUNT" -eq 0 ]; then
    echo "[OK] Carga línea a línea completada sin errores"
else
    echo "[ERROR] Carga completada con $ERROR_COUNT errores"
fi

# Obtener estadísticas finales
DBSIZE_RAW=$($REDIS_CMD DBSIZE 2>/dev/null || true)
if [ -n "$DBSIZE_RAW" ] && echo "$DBSIZE_RAW" | grep -q '^[0-9]*$'; then
    DBSIZE="$DBSIZE_RAW"
else
    DBSIZE=$($REDIS_CMD INFO keyspace 2>/dev/null | sed -n 's/.*keys=\([0-9]*\).*/\1/p' | head -1)
    DBSIZE=${DBSIZE:-0}
fi

echo "[DETALLE] Claves en Redis: $DBSIZE" >&2

# Validación rápida
USER_COUNT=$($REDIS_CMD ZCARD users:geo 2>/dev/null || echo "0")
POINT_COUNT=$($REDIS_CMD ZCARD points:ruta:1 2>/dev/null || echo "0")

echo "[DETALLE] Validación:" >&2
echo "[DETALLE]    - Usuarios en GEO: $USER_COUNT (esperados: 200)" >&2
echo "[DETALLE]    - Puntos en ruta 1: $POINT_COUNT (esperados: 5)" >&2

if [ "$USER_COUNT" -eq 200 ] && [ "$POINT_COUNT" -eq 5 ]; then
    echo "[OK] Validación exitosa - Datos cargados correctamente"
    exit 0
else
    echo "[ERROR] Validación parcial - Revisar los datos"
    exit 0
fi
