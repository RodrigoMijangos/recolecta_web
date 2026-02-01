#!/bin/bash
################################################################################
# Script: run_all.sh
# Purpose: Execute all Redis tests in sequence
# Description:
#   Runs comprehensive test suite for Redis including:
#   - Configuration validation
#   - Healthcheck verification
#   - Service startup test
#   - Data persistence test
#   - Seed integrity validation
################################################################################

echo "Executing all Redis tests..."
echo "=================================="

# Basic Redis tests
bash scripts/tests/redis/test_redis_config.sh || exit 1
bash scripts/tests/redis/test_healthcheck.sh || exit 1
bash scripts/tests/redis/test_service_startup.sh || exit 1
bash scripts/tests/redis/test_persistence.sh || exit 1

# Seed integrity test
bash scripts/tests/redis/test_seed_integrity.sh || exit 1

echo "=================================="
echo "All Redis tests passed successfully!"