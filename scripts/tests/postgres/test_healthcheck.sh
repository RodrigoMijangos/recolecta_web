#!/bin/sh

# Healthcheck suite for PostgreSQL (docker compose)
# Valida disponibilidad, operatividad mínima y CRUD básico

set -eu

# Cargar variables de entorno desde .env tres carpetas arriba, si existe
ENV_PATH="$(dirname "$0")/../../../.env"
if [ -f "$ENV_PATH" ]; then
  export $(grep -v '^#' "$ENV_PATH" | xargs)
fi


DOCKER_COMPOSE_FILE="docker/docker.compose.yml"
PG_SERVICE=database

# Mapear variables DB_ a PG_ si las PG_ no existen
PGUSER="${PGUSER:-${DB_USER:-postgres}}"
PGDATABASE="${PGDATABASE:-${DB_NAME:-postgres}}"
PGHOST="${PGHOST:-${DB_HOST:-db}}"
PGPORT="${PGPORT:-${DB_PORT:-5432}}"

echo "[DEBUG] Variables de conexión:"
echo "  PGUSER=$PGUSER"
echo "  PGDATABASE=$PGDATABASE"
echo "  PGHOST=$PGHOST"
echo "  PGPORT=$PGPORT"

# Ejecuta un comando dentro del contenedor postgres
pg_exec() {
  docker compose -f "$DOCKER_COMPOSE_FILE" exec -T "$PG_SERVICE" \
    psql -U "$PGUSER" -d "$PGDATABASE" -h "$PGHOST" -p "$PGPORT" -c "$1"
}

check_pg_isready() {
  echo "[HEALTHCHECK] Verificando disponibilidad con pg_isready..."
  docker compose -f "$DOCKER_COMPOSE_FILE" exec -T "$PG_SERVICE" bash -c \
    "pg_isready -h ${PGHOST:-localhost} -p ${PGPORT:-5432} -U ${PGUSER:-postgres} -d ${PGDATABASE:-postgres}"
}

check_select() {
  echo "[HEALTHCHECK] Ejecutando SELECT 1..."
  pg_exec "SELECT 1;"
}

check_crud() {
  echo "[HEALTHCHECK] Ejecutando ciclo CRUD mínimo..."
  pg_exec "\
    CREATE TEMP TABLE IF NOT EXISTS healthcheck_test (id serial PRIMARY KEY, val text);
    INSERT INTO healthcheck_test (val) VALUES ('foo') RETURNING id;
    SELECT val FROM healthcheck_test WHERE val = 'foo';
    UPDATE healthcheck_test SET val = 'bar' WHERE val = 'foo';
    DELETE FROM healthcheck_test WHERE val = 'bar';
    DROP TABLE IF EXISTS healthcheck_test;\
  "
}

main() {
  check_pg_isready
  check_select
  check_crud
  echo "[HEALTHCHECK] Todas las pruebas pasaron."
}

if [ "$#" -eq 0 ]; then
  main
else
  "$@"
fi
