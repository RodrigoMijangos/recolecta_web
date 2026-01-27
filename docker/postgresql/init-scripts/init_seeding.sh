#!/bin/sh
set -e

DB_NAME="${POSTGRES_DB:-proyecto_recolecta}"
DB_USER="${POSTGRES_USER:-recolecta}"
DB_PORT="${POSTGRES_PORT:-5432}"
DB_HOST="/var/run/postgresql"
SEED_FILE="${SEED_FILE:-/docker-entrypoint-initdb.d/seed.sql.skip}"
export PGPASSWORD="${POSTGRES_PASSWORD:-${DB_PASSWORD:-}}"

log() { echo "[seed] $1"; }

if [ ! -f "$SEED_FILE" ]; then
  log "Seed no encontrado: $SEED_FILE"
  exit 0
fi

log "Usando seed: $SEED_FILE"
psql -U "$DB_USER" -p "$DB_PORT" -h "$DB_HOST" -d "$DB_NAME" -f "$SEED_FILE"
log "Seed ejecutado"
