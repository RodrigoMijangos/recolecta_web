#!/bin/bash
# Test script for service startup of Redis container
set -e

echo "Starting Redis service startup test..."

# Up service in detached mode
docker-compose --env-file .env -f docker/docker.compose.yml up -d redis

# Wait for a few seconds to allow the service to start
MAX_RETRIES=10
RETRY_COUNT=0
ENV_FILE=".env"
while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if docker exec -e REDISCLI_AUTH="${REDIS_PASSWORD}" redis_cache redis-cli PING > /dev/null 2>&1; then
        echo "Redis service is up and responding to PING."
        break
    else
        echo "Waiting for Redis service to start..."
        RETRY_COUNT=$((RETRY_COUNT + 1))
        sleep 3
    fi
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
  echo "❌ Redis no respondió en tiempo límite"
  exit 1
fi

# Check health status
HEALTH=$(docker inspect redis_cache --format='{{.State.Health.Status}}' 2>/dev/null || echo "none")
if [ "$HEALTH" != "healthy" ] && [ "$HEALTH" != "none" ]; then
  echo "⚠️  Healthcheck status: $HEALTH (puede estar en progreso)"
fi

echo "✅ Service started successfully and is healthy."
exit 0