#!/bin/sh

set -e

# =====================
# VARIABLES DE ENTORNO
# =====================
DB_NAME="${POSTGRES_DB:-proyecto_recolecta}"
DB_USER="${POSTGRES_USER:-recolecta}"
DB_PORT="${POSTGRES_PORT:-5432}"
# Usamos socket local para evitar problemas de auth en TCP durante init
DB_HOST="/var/run/postgresql"
# BD base para chequeos (siempre existe)
DEFAULT_DB="postgres"
# Password para conexiones no interactuantes
export PGPASSWORD="${POSTGRES_PASSWORD:-${DB_PASSWORD:-}}"
# Montamos el SQL con sufijo .skip para evitar que el entrypoint lo ejecute por defecto
SCRIPT_PATH="/docker-entrypoint-initdb.d/db_script.sql.skip"

# =====================
# COLORES PARA OUTPUT
# =====================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# =====================
# FUNCIONES
# =====================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

database_exists() {
    local query="SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';"
    local result
    
    result=$(psql -U "$DB_USER" -p "$DB_PORT" -h "$DB_HOST" -d "$DEFAULT_DB" -t -c "$query" 2>/dev/null || echo "")
    
    if [ -z "$result" ]; then
        return 1  # BD no existe
    else
        return 0  # BD existe
    fi
}

# =====================
# MAIN SCRIPT
# =====================

log_info "Iniciando script de inicialización de base de datos..."
log_info "Base de datos: $DB_NAME"
log_info "Usuario: $DB_USER"
log_info "Puerto: $DB_PORT"

# Esperar a que PostgreSQL esté listo
log_info "Esperando a que PostgreSQL esté disponible..."
for i in $(seq 1 30); do
    if pg_isready -U "$DB_USER" -p "$DB_PORT" -h "$DB_HOST" -d "$DEFAULT_DB" >/dev/null 2>&1; then
        log_success "PostgreSQL está disponible"
        break
    fi

    if [ "$i" -eq 30 ]; then
        log_error "PostgreSQL no está disponible después de 30 intentos"
        exit 1
    fi

    sleep 1
done

# =====================
# VERIFICAR SI BD EXISTE
# =====================

if database_exists; then
    log_warning "La base de datos '$DB_NAME' ya existe"
    log_info "Ejecutando script desde línea 6 en adelante (omitiendo CREATE DATABASE)..."
    
    # Ejecutar solo desde línea 6 (omite CREATE DATABASE y \c)
    tail -n +6 "$SCRIPT_PATH" | psql -U "$DB_USER" -p "$DB_PORT" -h "$DB_HOST" -d "$DB_NAME" 2>&1
    
    if [ $? -eq 0 ]; then
        log_success "Script ejecutado exitosamente (modo de actualización)"
        log_info "Estrategia: PARCIAL (líneas 6+)"
    else
        log_error "Error al ejecutar el script"
        exit 1
    fi
else
    log_info "La base de datos '$DB_NAME' no existe"
    log_info "Ejecutando script completo (creando BD)..."
    
    # Ejecutar script completo
    psql -U "$DB_USER" -p "$DB_PORT" -h "$DB_HOST" -d "$DEFAULT_DB" -f "$SCRIPT_PATH" 2>&1
    
    if [ $? -eq 0 ]; then
        log_success "Script ejecutado exitosamente (primera creación)"
        log_info "Estrategia: COMPLETA (líneas 1+)"
    else
        log_error "Error al ejecutar el script"
        exit 1
    fi
fi

# =====================
# REPORTE FINAL
# =====================

log_info "Obteniendo estadísticas finales..."

TABLE_COUNT=$(psql -U "$DB_USER" -p "$DB_PORT" -h "$DB_HOST" -d "$DB_NAME" -t -c \
    "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE';")

INDEX_COUNT=$(psql -U "$DB_USER" -p "$DB_PORT" -h "$DB_HOST" -d "$DB_NAME" -t -c \
    "SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'public';")

echo ""
echo -e "${GREEN}==========================================${NC}"
echo -e "${GREEN}✓ INICIALIZACIÓN COMPLETADA${NC}"
echo -e "${GREEN}==========================================${NC}"
echo "Base de datos: $DB_NAME"
echo "Tablas: $TABLE_COUNT"
echo "Índices: $INDEX_COUNT"
echo -e "${GREEN}==========================================${NC}"
echo ""

log_success "Script de inicialización finalizado"
