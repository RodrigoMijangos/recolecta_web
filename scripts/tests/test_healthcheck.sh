#!/bin/bash
# Test script for healthcheck of Redis container
set -e

echo "Starting Redis healthcheck test..."

COMPOSE_FILE="docker/docker.compose.yml"

grep -A 5 "redis:" "$COMPOSE_FILE" | grep -q "healthcheck:" || { echo "Error: Healthcheck not found in Redis service."; exit 1; }
grep -q "test: \[\"CMD\", \"redis-cli\", \"-a\", \"\${REDIS_PASSWORD}\", \"PING\"\]" "$COMPOSE_FILE" || { echo "Error: Healthcheck test command incorrect."; exit 1; }
grep -q "interval:" "$COMPOSE_FILE" || { echo "Error: Healthcheck interval not found."; exit 1; }

echo "Redis healthcheck test passed successfully!"
exit 0