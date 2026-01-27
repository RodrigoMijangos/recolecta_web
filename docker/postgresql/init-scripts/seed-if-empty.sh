#!/bin/sh

set -e

# =====================
# SEED CON VERSIONING
# =====================
# Script ejecutado DESPUÉS de 00-init-database.sh
# Verifica si hay datos antes de ejecutar seed

# =====================
# VARIABLES DE ENTORNO
# =====================
DB_NAME="${POSTGRES_DB:-proyecto_recolecta}"
DB_USER="${POSTGRES_USER:-recolecta}"
DB_PORT="${POSTGRES_PORT:-5432}"
DB_HOST="/var/run/postgresql"
export PGPASSWORD="${POSTGRES_PASSWORD:-${DB_PASSWORD:-}}"
SEED_PATH="/docker-entrypoint-initdb.d/seed.sql.skip"
SEED_VERSION="1.0.1"

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
    echo -e "${BLUE}[SEED]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[SKIP]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

check_seed_version() {
    local result
    result=$(psql -U "$DB_USER" -p "$DB_PORT" -h "$DB_HOST" -d "$DB_NAME" -t -c \
        "SELECT EXISTS(SELECT 1 FROM schema_version WHERE version = '$SEED_VERSION');" 2>/dev/null || echo "f")
    echo "$result" | tr -d '[:space:]'
}

check_table_has_data() {
    local table_name=$1
    local count
    count=$(psql -U "$DB_USER" -p "$DB_PORT" -h "$DB_HOST" -d "$DB_NAME" -t -c \
        "SELECT COUNT(*) FROM $table_name LIMIT 1;" 2>/dev/null || echo "0")
    echo "$count" | tr -d '[:space:]'
}

# =====================
# MAIN SCRIPT
# =====================

log_info "Verificando si se necesita ejecutar seed..."

# Verificar si el archivo de seed existe
if [ ! -f "$SEED_PATH" ]; then
    log_warning "No se encontró archivo de seed: $SEED_PATH"
    exit 0
fi

# Verificar si ya se ejecutó este seed (usando versioning)
if [ "$(check_seed_version)" = "t" ]; then
    log_warning "Seed versión $SEED_VERSION ya fue aplicado anteriormente"
    exit 0
fi

# Verificar si la tabla centinela tiene datos
ROL_COUNT=$(check_table_has_data "rol")

if [ "$ROL_COUNT" != "0" ] && [ -n "$ROL_COUNT" ]; then
    log_warning "Tabla 'rol' ya contiene datos ($ROL_COUNT registros). Omitiendo seed."
    # Registrar el seed como aplicado aunque no se ejecute (datos ya existen)
    psql -U "$DB_USER" -p "$DB_PORT" -h "$DB_HOST" -d "$DB_NAME" -c \
        "INSERT INTO schema_version (version, description, script_name) 
         VALUES ('$SEED_VERSION', 'Seed data (omitido, datos preexistentes)', 'seed.sql')
         ON CONFLICT (version) DO NOTHING;" >/dev/null 2>&1
    exit 0
fi

# =====================
# EJECUTAR SEED
# =====================

log_info "Tabla 'rol' está vacía. Ejecutando seed..."

psql -U "$DB_USER" -p "$DB_PORT" -h "$DB_HOST" -d "$DB_NAME" -f "$SEED_PATH" 2>&1

if [ $? -eq 0 ]; then
    log_success "Seed ejecutado correctamente"
    
    # Registrar versión del seed
    psql -U "$DB_USER" -p "$DB_PORT" -h "$DB_HOST" -d "$DB_NAME" -c \
        "INSERT INTO schema_version (version, description, script_name) 
         VALUES ('$SEED_VERSION', 'Seed data inicial', 'seed.sql')
         ON CONFLICT (version) DO NOTHING;" >/dev/null 2>&1
    
    log_success "Seed versión $SEED_VERSION registrado"
    
    # Reporte de datos insertados
    ROL_COUNT=$(check_table_has_data "rol")
    COLONIA_COUNT=$(check_table_has_data "colonia")
    USUARIO_COUNT=$(check_table_has_data "usuario")
    
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}✓ SEED COMPLETADO${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo "Roles: $ROL_COUNT"
    echo "Colonias: $COLONIA_COUNT"
    echo "Usuarios: $USUARIO_COUNT"
    echo -e "${GREEN}========================================${NC}"
    echo ""
else
    log_error "Error al ejecutar seed"
    exit 1
fi

log_success "Script de seed finalizado"
