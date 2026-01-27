#!/bin/bash
# Test script for healthcheck of Redis container
set -e

echo "Starting Redis healthcheck test..."

# Cambiar al directorio raíz del proyecto
cd "$(dirname "$0")/../../.." || exit 1

COMPOSE_FILE="docker/docker.compose.yml"

# Verificar que el archivo existe
if [ ! -f "$COMPOSE_FILE" ]; then
  echo "Error: $COMPOSE_FILE not found"
  exit 1
fi

# Verificar healthcheck (aumentar líneas a 15)
grep -A 15 "redis:" "$COMPOSE_FILE" | grep -q "healthcheck:" || { echo "Error: Healthcheck not found in Redis service."; exit 1; }

# Verificar test command (simplificado - solo buscar redis-cli PING)
grep -A 15 "redis:" "$COMPOSE_FILE" | grep -q "redis-cli.*PING" || { echo "Error: Healthcheck PING test not found."; exit 1; }

# Verificar parámetros
grep -A 15 "redis:" "$COMPOSE_FILE" | grep -q "interval:" || { echo "Error: Healthcheck interval not found."; exit 1; }
grep -A 15 "redis:" "$COMPOSE_FILE" | grep -q "timeout:" || { echo "Error: Healthcheck timeout not found."; exit 1; }
grep -A 15 "redis:" "$COMPOSE_FILE" | grep -q "retries:" || { echo "Error: Healthcheck retries not found."; exit 1; }

echo "Redis healthcheck test passed successfully!"
exit 0