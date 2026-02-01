#!/usr/bin/env bash
set -euo pipefail

# Lightweight reset using docker compose exec to run repo init scripts inside containers.
# Usage: reset-environment-compose.sh --confirm

usage(){
  cat <<EOF
Usage: $0 --confirm

This will execute the repository init scripts inside the running compose services:
  - database: /docker-entrypoint-initdb.d/00-init-database.sh and /docker-entrypoint-initdb.d/01-seed-if-empty.sh
  - redis: /docker-entrypoint-initdb.d/init-if-empty.sh

The script locates the nearest .env by walking up from the current directory and sources it.
EOF
  exit 2
}

CONFIRMED=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --confirm) CONFIRMED=1; shift ;;
    -h|--help) usage ;;
    *) echo "Unknown arg: $1" >&2; usage ;;
  esac
done

if [[ $CONFIRMED -ne 1 ]]; then
  echo "ERROR: --confirm is required to run this script." >&2
  usage
fi

# Find .env by walking up from current directory
HERE="$(pwd)"
ENV_PATH=""
CUR="$HERE"
while [[ "$CUR" != "/" && -z "$ENV_PATH" ]]; do
  if [[ -f "$CUR/.env" ]]; then
    ENV_PATH="$CUR/.env"
    break
  fi
  CUR=$(dirname "$CUR")
done

if [[ -z "$ENV_PATH" ]]; then
  echo "ERROR: .env not found in current or parent directories." >&2
  exit 2
fi

PROJECT_ROOT="$(dirname "$ENV_PATH")"
echo "Found .env at: $ENV_PATH"
echo "Project root: $PROJECT_ROOT"

# Source .env (export vars)
set -a; # export
source "$ENV_PATH"
set +a

# Use docker compose file in docker/docker.compose.yml (run from project root)
COMPOSE_FILE="$PROJECT_ROOT/docker/docker.compose.yml"
if [[ ! -f "$COMPOSE_FILE" ]]; then
  echo "ERROR: compose file not found at $COMPOSE_FILE" >&2; exit 2
fi

cd "$PROJECT_ROOT"

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: docker CLI not found" >&2; exit 2
fi

# Resolve container IDs (prefer docker compose lookup, fallback to known container names)
DB_CID=$(docker compose -f "$COMPOSE_FILE" ps -q database 2>/dev/null || true)
if [ -z "$DB_CID" ]; then
  DB_CID=$(docker ps -q -f name=postgres_db 2>/dev/null || true)
fi
if [ -z "$DB_CID" ]; then
  echo "ERROR: database container not found" >&2; exit 2
fi

echo "Executing DB init script inside container '$DB_CID'..."
docker exec -i "$DB_CID" sh -c 'if [ -f /docker-entrypoint-initdb.d/00-init-database.sh ]; then sh /docker-entrypoint-initdb.d/00-init-database.sh; else echo "DB init script not present inside container"; fi' 

echo "Executing DB seed-if-empty inside container '$DB_CID'..."
docker exec -i "$DB_CID" sh -c 'if [ -f /docker-entrypoint-initdb.d/01-seed-if-empty.sh ]; then sh /docker-entrypoint-initdb.d/01-seed-if-empty.sh; else echo "seed-if-empty not present inside container"; fi' 

# Resolve redis container ID (prefer compose lookup)
REDIS_CID=$(docker compose -f "$COMPOSE_FILE" ps -q redis 2>/dev/null || true)
if [ -z "$REDIS_CID" ]; then
  REDIS_CID=$(docker ps -q -f name=redis_cache 2>/dev/null || true)
fi
if [ -z "$REDIS_CID" ]; then
  echo "ERROR: redis container not found" >&2; exit 2
fi

echo "Executing Redis init-if-empty inside container '$REDIS_CID'..."
docker exec -i "$REDIS_CID" sh -c 'if [ -f /docker-entrypoint-initdb.d/init-if-empty.sh ]; then sh /docker-entrypoint-initdb.d/init-if-empty.sh; else echo "redis init-if-empty not present inside container"; fi' 

echo "Docker init scripts executed. Running tests automatically..."
if bash scripts/tests/redis/test_seed_integrity.sh && bash scripts/tests/test_cross_validation.sh; then
  echo "All tests passed"
  exit 0
else
  echo "One or more tests failed" >&2
  exit 1
fi
