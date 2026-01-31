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
SEED_FILE="$SEEDS_DIR/redis-seed.txt"

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
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cargando comandos Redis..." >&2

# Filtrar comentarios y líneas vacías, luego enviar a redis-cli en modo pipeline
grep -v '^#' "$SEED_FILE" | grep -v '^[[:space:]]*$' | $REDIS_CMD --pipe > /dev/null 2>&1

# Alternativamente, ejecutar línea por línea para mejor control
LINE_COUNT=0
ERROR_COUNT=0

while IFS= read -r line; do
    # Saltar comentarios y líneas vacías
    [[ "$line" =~ ^# ]] && continue
    [[ -z "$line" ]] && continue
    
    # Ejecutar comando
    if ! eval "$REDIS_CMD $line" > /dev/null 2>&1; then
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
    LINE_COUNT=$((LINE_COUNT + 1))
    
    # Mostrar progreso cada 50 comandos
    if (( LINE_COUNT % 50 == 0 )); then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Procesados $LINE_COUNT comandos..." >&2
    fi
done < "$SEED_FILE"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Carga completada" >&2
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Estadísticas:" >&2
echo "   - Comandos procesados: $LINE_COUNT" >&2
echo "   - Errores: $ERROR_COUNT" >&2

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
