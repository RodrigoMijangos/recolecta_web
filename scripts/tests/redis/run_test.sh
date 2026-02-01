#!/bin/bash
################################################################################
# Script: run_test.sh
# Purpose: Helper script to run Redis tests with proper context
# Description:
#   Wrapper that ensures you're in the correct directory and sets up
#   the environment for running Redis integrity tests via docker exec
#
# Usage:
#   ./scripts/tests/redis/run_test.sh test_seed_integrity
#   ./scripts/tests/redis/run_test.sh test_seed_integrity --verbose
################################################################################

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$PROJECT_ROOT" || exit 1

# Source .env if it exists
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

# Get the test script name
TEST_SCRIPT="${1}"
shift || true

# Find and run the test script
TEST_FILE="scripts/tests/redis/${TEST_SCRIPT}.sh"

if [ ! -f "$TEST_FILE" ]; then
    echo "❌ Test script not found: $TEST_FILE"
    echo ""
    echo "Available tests:"
    ls -1 scripts/tests/redis/test_*.sh 2>/dev/null | sed 's|scripts/tests/redis/test_||g; s|.sh||g' | sed 's|^|  - |'
    exit 1
fi

# Make the test script executable
chmod +x "$TEST_FILE" 2>/dev/null || true

# Run the test with any additional arguments
exec "$TEST_FILE" "$@"
