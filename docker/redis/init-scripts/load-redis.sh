#!/bin/bash
# ============================================================================
# load-redis.sh - Cargador de datos en Redis
# ============================================================================
# Carga el seed generado en la instancia de Redis
# Uso: ./load-redis.sh [redis-host] [redis-port] [redis-password]
# ============================================================================

set -e

# Configuración
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SEEDS_DIR="$SCRIPT_DIR/../seeds"

# Buscar el archivo seed más reciente
if [[ -L "$SEEDS_DIR/redis-seed-latest.txt" ]]; then
    # Usar symlink si existe
    SEED_FILE="$SEEDS_DIR/redis-seed-latest.txt"
else
    # Buscar el más reciente por timestamp
    SEED_FILE=$(ls -t "$SEEDS_DIR"/redis-seed_v1_*.txt 2>/dev/null | head -1)
    
    # Fallback a nombre genérico
    if [[ -z "$SEED_FILE" ]]; then
        SEED_FILE="$SEEDS_DIR/redis-seed.txt"
    fi
fi

# Parámetros
REDIS_HOST="${1:-localhost}"
REDIS_PORT="${2:-6379}"
REDIS_PASSWORD="${3:-}"
REDIS_DB="${4:-0}"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando carga de datos en Redis..." >&2
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Host: $REDIS_HOST:$REDIS_PORT | DB: $REDIS_DB" >&2

# Validar que el archivo existe
if [[ ! -f "$SEED_FILE" ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✗ ERROR: archivo de seed no encontrado: $SEED_FILE" >&2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Ejecute primero: generate-seed-data.sh" >&2
    exit 1
fi

# Construir comando redis-cli
REDIS_CMD="redis-cli -h $REDIS_HOST -p $REDIS_PORT -n $REDIS_DB"

# Agregar password si se proporciona
if [[ -n "$REDIS_PASSWORD" ]]; then
    REDIS_CMD="$REDIS_CMD -a $REDIS_PASSWORD"
fi

# Verificar conectividad
if ! $REDIS_CMD ping > /dev/null 2>&1; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✗ ERROR: No se puede conectar a Redis en $REDIS_HOST:$REDIS_PORT" >&2
    exit 1
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Conexión a Redis establecida" >&2

# Limpiar base de datos previa (OPCIONAL - comentado por seguridad)
# echo "[$(date '+%Y-%m-%d %H:%M:%S')] Limpiando base de datos..."
# $REDIS_CMD FLUSHDB

# Procesar y ejecutar comandos del seed
# Mostrar mensajes por colección y resumen al final
COLLECTION=""
COLLECTION_COUNTS=()
COLLECTION_ORDER=()
LINE_COUNT=0
ERROR_COUNT=0

while IFS= read -r line; do
    # Detectar inicio de colección
    if [[ "$line" =~ ^#\ =+ ]]; then
        # Extraer nombre de colección si está en la línea siguiente
        read -r nextline
        if [[ "$nextline" =~ ^#\ (.+) ]]; then
            NEW_COLLECTION="${nextline#\# }"
            if [[ "$COLLECTION" != "$NEW_COLLECTION" ]]; then
                COLLECTION="$NEW_COLLECTION"
                COLLECTION_ORDER+=("$COLLECTION")
                COLLECTION_COUNTS["$COLLECTION"]=0
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Cargando colección: $COLLECTION ---" >&2
            fi
        fi
        continue
    fi
    # Saltar comentarios y líneas vacías
    [[ "$line" =~ ^# ]] && continue
    [[ -z "$line" ]] && continue
    
    # Ejecutar comando y suprimir salida
    if ! eval "$REDIS_CMD $line" > /dev/null 2>&1; then
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
    LINE_COUNT=$((LINE_COUNT + 1))
    if [[ -n "$COLLECTION" ]]; then
        COLLECTION_COUNTS["$COLLECTION"]=$(( ${COLLECTION_COUNTS["$COLLECTION"]:-0} + 1 ))
    fi
    # Mostrar progreso cada 500 comandos
    if (( LINE_COUNT % 500 == 0 )); then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Procesados $LINE_COUNT comandos..." >&2
    fi
    # Mensaje al finalizar cada 1000 comandos
    if (( LINE_COUNT % 1000 == 0 )); then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Tanda de $LINE_COUNT comandos cargada" >&2
    fi

done < "$SEED_FILE"

# Resumen por colección
for col in "${COLLECTION_ORDER[@]}"; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ $col: ${COLLECTION_COUNTS[$col]:-0} comandos cargados" >&2
fi

# Mensaje final
if (( ERROR_COUNT == 0 )); then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Carga línea a línea completada sin errores" >&2
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ⚠ Carga completada con $ERROR_COUNT errores" >&2
fi

# Obtener estadísticas finales
DBSIZE=$($REDIS_CMD DBSIZE | grep -oP '(?<=:)\d+')
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Claves en Redis: $DBSIZE" >&2

# Validación rápida
USER_COUNT=$($REDIS_CMD ZCARD users:geo 2>/dev/null || echo "0")
POINT_COUNT=$($REDIS_CMD ZCARD points:ruta:1 2>/dev/null || echo "0")

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Validación:" >&2
echo "   - Usuarios en GEO: $USER_COUNT (esperados: 200)" >&2
echo "   - Puntos en ruta 1: $POINT_COUNT (esperados: 5)" >&2

if [[ $USER_COUNT -eq 200 ]] && [[ $POINT_COUNT -eq 5 ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Validación exitosa - Datos cargados correctamente" >&2
    exit 0
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ⚠ Validación parcial - Revisar los datos" >&2
    exit 0
fi
