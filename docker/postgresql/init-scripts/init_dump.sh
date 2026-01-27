#!/bin/sh
set -e

DB_NAME="${POSTGRES_DB:-proyecto_recolecta}"
DB_USER="${POSTGRES_USER:-recolecta}"
DB_PORT="${POSTGRES_PORT:-5432}"
DB_HOST="/var/run/postgresql"
export PGPASSWORD="${POSTGRES_PASSWORD:-${DB_PASSWORD:-}}"

TS="$(date +%Y%m%d%H%M%S)"
OUT_DIR="/dumps"
OUT_FILE="$OUT_DIR/${DB_NAME}-${TS}.sql"

log() { echo "[dump] $1"; }

mkdir -p "$OUT_DIR"
log "Generando dump en $OUT_FILE"
pg_dump -U "$DB_USER" -p "$DB_PORT" -h "$DB_HOST" -d "$DB_NAME" -F p -f "$OUT_FILE"
log "Dump listo: $OUT_FILE"
