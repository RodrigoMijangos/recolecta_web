#!/bin/bash
echo "Executing all Redis tests..."
echo "=================================="

bash scripts/tests/redis/test_redis_config.sh || exit 1
bash scripts/tests/redis/test_healthcheck.sh || exit 1
bash scripts/tests/redis/test_service_startup.sh || exit 1
bash scripts/tests/redis/test_persistence.sh || exit 1

echo "=================================="
echo "All tests passed successfully!"