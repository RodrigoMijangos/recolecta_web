#!/bin/bash
# ============================================================================
# verify-redis.sh - Verificador de integridad de datos en Redis
# ============================================================================
# Valida que todos los datos fueron cargados correctamente
# Uso: ./verify-redis.sh [redis-host] [redis-port] [redis-password]
# ============================================================================

set -e

# Configuración
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SEEDS_DIR="$SCRIPT_DIR/../seeds"

# Parámetros
REDIS_HOST="${1:-localhost}"
REDIS_PORT="${2:-6379}"
REDIS_PASSWORD="${3:-}"
REDIS_DB="${4:-0}"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Construir comando redis-cli
REDIS_CMD="redis-cli -h $REDIS_HOST -p $REDIS_PORT -n $REDIS_DB"

if [[ -n "$REDIS_PASSWORD" ]]; then
    REDIS_CMD="$REDIS_CMD -a $REDIS_PASSWORD"
fi

echo "========================================================================"
echo "Verificación de Integridad - Redis Seed"
echo "========================================================================"
echo "Host: $REDIS_HOST:$REDIS_PORT | DB: $REDIS_DB"
echo ""

# Test 1: Conectividad
echo -n "[1] Conectividad a Redis... "
if $REDIS_CMD ping > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    exit 1
fi

# Test 2: Base de datos no está vacía
echo -n "[2] Base de datos no vacía... "
DBSIZE=$($REDIS_CMD DBSIZE | grep -oP '(?<=:)\d+')
if [[ $DBSIZE -gt 0 ]]; then
    echo -e "${GREEN}✓${NC} ($DBSIZE claves)"
else
    echo -e "${RED}✗${NC} (base de datos vacía)"
    exit 1
fi

# Test 3: Usuarios GEO Index
echo -n "[3] Usuarios en GEO Index... "
USER_COUNT=$($REDIS_CMD ZCARD users:geo 2>/dev/null || echo "0")
if [[ $USER_COUNT -eq 200 ]]; then
    echo -e "${GREEN}✓${NC} (200 usuarios)"
elif [[ $USER_COUNT -gt 0 ]]; then
    echo -e "${YELLOW}⚠${NC} ($USER_COUNT usuarios, esperados 200)"
else
    echo -e "${RED}✗${NC} (0 usuarios)"
fi

# Test 4: Rutas
echo -n "[4] Rutas creadas... "
ROUTE_COUNT=$($REDIS_CMD DBSIZE | grep -oP '(?<=:)\d+')  # Aproximado
ROUTE_SAMPLE=$($REDIS_CMD EXISTS route:1 route:2 route:3 route:4 route:5 | grep -oP '\d+')
if [[ $ROUTE_SAMPLE -eq 5 ]]; then
    echo -e "${GREEN}✓${NC} (5 rutas)"
else
    echo -e "${YELLOW}⚠${NC} (verificar manualmente)"
fi

# Test 5: Puntos por ruta
echo -n "[5] Puntos de recolección por ruta... "
for RUTA_ID in {1..5}; do
    PUNTO_COUNT=$($REDIS_CMD ZCARD points:ruta:$RUTA_ID 2>/dev/null || echo "0")
    if [[ $PUNTO_COUNT -eq 5 ]]; then
        echo -n -e "${GREEN}$RUTA_ID✓${NC} "
    else
        echo -n -e "${YELLOW}$RUTA_ID($PUNTO_COUNT)${NC} "
    fi
done
echo ""

# Test 6: Hash de usuarios
echo -n "[6] Datos de usuarios (HASH)... "
SAMPLE_USER=$($REDIS_CMD HGETALL user:100 | wc -l)
if [[ $SAMPLE_USER -gt 0 ]]; then
    echo -e "${GREEN}✓${NC} (usuario:100 tiene datos)"
    $REDIS_CMD HGETALL user:100 | sed 's/^/      /'
else
    echo -e "${RED}✗${NC} (usuario:100 no tiene datos)"
fi

# Test 7: FCM Tokens
echo -n "[7] FCM Tokens... "
FCM_SAMPLE=$($REDIS_CMD HGET user:100 fcm_token 2>/dev/null || echo "")
if [[ ! -z "$FCM_SAMPLE" ]]; then
    echo -e "${GREEN}✓${NC}"
    echo "      Muestra: ${FCM_SAMPLE:0:30}..."
else
    echo -e "${RED}✗${NC}"
fi

# Test 8: Coordenadas
echo -n "[8] Coordenadas de usuarios... "
LAT=$($REDIS_CMD HGET user:100 lat 2>/dev/null || echo "")
LON=$($REDIS_CMD HGET user:100 lon 2>/dev/null || echo "")
if [[ ! -z "$LAT" && ! -z "$LON" ]]; then
    echo -e "${GREEN}✓${NC}"
    echo "      Usuario 100: Lat=$LAT, Lon=$LON"
else
    echo -e "${RED}✗${NC}"
fi

# Test 9: Historial
echo -n "[9] Historial de vaciados... "
HISTORY_COUNT=$($REDIS_CMD LLEN historial:vaciado:1:1 2>/dev/null || echo "0")
if [[ $HISTORY_COUNT -gt 0 ]]; then
    echo -e "${GREEN}✓${NC} ($HISTORY_COUNT registros)"
else
    echo -e "${YELLOW}⚠${NC} (no hay registros)"
fi

# Test 10: Notificaciones
echo -n "[10] Configuración de notificaciones... "
NOTIF_METRICS=$($REDIS_CMD HEXISTS notification:metrics total_sent 2>/dev/null || echo "0")
if [[ $NOTIF_METRICS -eq 1 ]]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}⚠${NC}"
fi

# Test 11: Camiones
echo -n "[11] Estado de camiones... "
TRUCK_STATE=$($REDIS_CMD HEXISTS truck:1:state ruta_id 2>/dev/null || echo "0")
if [[ $TRUCK_STATE -eq 1 ]]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}⚠${NC}"
fi

# Test 12: Metadata
echo -n "[12] Metadata del seed... "
METADATA=$($REDIS_CMD HEXISTS seed:metadata generated_at 2>/dev/null || echo "0")
if [[ $METADATA -eq 1 ]]; then
    echo -e "${GREEN}✓${NC}"
    $REDIS_CMD HGETALL seed:metadata | sed 's/^/      /'
else
    echo -e "${YELLOW}⚠${NC}"
fi

echo ""
echo "========================================================================"
echo "Resumen de Validación"
echo "========================================================================"

echo ""
echo "Estadísticas de Datos:"
echo "  - Total de claves en Redis: $DBSIZE"
echo "  - Usuarios georreferenciados: $USER_COUNT / 200"
echo ""

# Comando para exploración manual
echo "Comandos útiles para exploración:"
echo "  redis-cli -h $REDIS_HOST -p $REDIS_PORT -n $REDIS_DB"
echo ""
echo "  # Ver un usuario"
echo "  HGETALL user:100"
echo ""
echo "  # Ver puntos en una ruta"
echo "  LRANGE route:points:1 0 -1"
echo ""
echo "  # Búsqueda geoespacial (usuarios a 1km de referencia)"
echo "  GEORADIUS users:geo 16.5896 -93.0547 1 km"
echo ""
echo "========================================================================"
echo "Verificación completada"
echo "========================================================================"
