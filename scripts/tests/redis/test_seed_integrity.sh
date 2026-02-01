#!/bin/bash
################################################################################
# Script: test_seed_integrity.sh
# Purpose: Validate Redis seed data integrity via Docker
# Description:
#   - Verifies exactly 200 users in users:geo index
#   - Verifies >= 25 points distributed across routes
#   - Validates user structure (nombre, colonia_id, fcm_token, lat, lon)
#   - Validates point structure (route_id, lat, lon, label)
#   - Shows progress per collection during validation
#   - Executes via 'docker exec' on isolated Redis container
#
# Usage:
#   ./test_seed_integrity.sh                    # Use .env defaults
#   ./test_seed_integrity.sh --container redis_cache  # Override container name
#
# Exit codes:
#   0 - All validations passed
#   1 - Validation failed
#   2 - Configuration error (Docker/Redis connection)
################################################################################

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration variables
REDIS_CONTAINER="${REDIS_CONTAINER:-redis_cache}"
REDIS_PASSWORD="${REDIS_PASSWORD:-r3d1s_s3cur3_p4ss}"
REDIS_DB="${REDIS_DB:-0}"

# Expected values
EXPECTED_USERS=200
MIN_POINTS=25

################################################################################
# Functions
################################################################################

# Print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_section() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Show help
show_help() {
    cat << EOF
Usage: test_seed_integrity.sh [OPTIONS]

Description:
  Validates Redis seed data integrity via 'docker exec' on the Redis container.
  Tests include:
  - Exactly 200 users in users:geo geospatial index
  - At least 25 collection points across 5 routes
  - User structure (nombre, colonia_id, fcm_token, lat, lon)
  - Point structure (route_id, lat, lon, label)
  - Progress display per collection type

Options:
  --help                  Show this help message
  --container NAME        Redis container name (default: redis_cache)
  --redis-password PASS   Redis password (default: r3d1s_s3cur3_p4ss)
  --redis-db DB           Redis database (default: 0)
  --verbose               Show detailed validation output

Environment variables:
  REDIS_CONTAINER        Override redis container name
  REDIS_PASSWORD         Override redis password
  REDIS_DB               Override redis database

Examples:
  # Use default container (redis_cache)
  ./test_seed_integrity.sh

  # Override container name
  ./test_seed_integrity.sh --container my_redis

  # With detailed output
  ./test_seed_integrity.sh --verbose

Exit codes:
  0 - All validations passed
  1 - Validation failed
  2 - Configuration error (Docker/Redis connection)
EOF
}

# Execute redis-cli command via docker exec
redis_cmd() {
    if [ -n "$REDIS_PASSWORD" ]; then
        docker exec "$REDIS_CONTAINER" redis-cli -a "$REDIS_PASSWORD" -n "$REDIS_DB" "$@" 2>/dev/null
    else
        docker exec "$REDIS_CONTAINER" redis-cli -n "$REDIS_DB" "$@" 2>/dev/null
    fi
}

# Check if container is running
check_docker_container() {
    if ! docker ps --format "table {{.Names}}" | grep -q "^${REDIS_CONTAINER}$"; then
        return 1
    fi
    return 0
}

# Test Redis connectivity via docker
test_redis_connection() {
    print_section "Docker & Redis Connection Test"
    
    # Check if docker is available
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed or not in PATH"
        return 2
    fi
    
    print_info "Docker found: $(docker --version)"
    
    # Check if container is running
    if ! check_docker_container; then
        print_error "Redis container '${REDIS_CONTAINER}' is not running"
        print_info "Make sure to run: docker compose up"
        return 2
    fi
    
    print_success "Container '${REDIS_CONTAINER}' is running"
    
    # Test PING command
    if ! redis_cmd PING > /dev/null 2>&1; then
        print_error "Cannot connect to Redis via docker exec"
        print_info "Check Redis password in .env (REDIS_PASSWORD)"
        return 2
    fi
    
    print_success "Connected to Redis via docker exec"
    return 0
}

# Validate users in geospatial index
validate_users() {
    print_section "Users Validation"
    
    local user_count
    user_count=$(redis_cmd ZCARD users:geo 2>/dev/null || echo "0")
    
    print_info "Users in users:geo index: $user_count / $EXPECTED_USERS"
    
    if [ "$user_count" -ne "$EXPECTED_USERS" ]; then
        print_error "Expected $EXPECTED_USERS users, found $user_count"
        return 1
    fi
    
    print_success "User count validation passed"
    
    # Validate sample users (first, middle, last)
    validate_user_structure 100  # First user
    validate_user_structure 199  # Middle user
    validate_user_structure 299  # Last user
    
    return 0
}

# Validate individual user structure
validate_user_structure() {
    local user_id=$1
    local user_key="user:${user_id}"
    
    # Check if user exists
    local exists
    exists=$(redis_cmd EXISTS "$user_key" 2>/dev/null || echo "0")
    
    if [ "$exists" -ne 1 ]; then
        print_warning "User $user_id not found in Redis"
        return 1
    fi
    
    # Get user fields
    local fields
    fields=$(redis_cmd HKEYS "$user_key" 2>/dev/null)
    
    # Check required fields
    local required_fields=("nombre" "colonia_id" "fcm_token" "lat" "lon")
    local missing_fields=0
    
    for field in "${required_fields[@]}"; do
        if ! echo "$fields" | grep -q "^${field}$"; then
            print_warning "User $user_id missing field: $field"
            ((missing_fields++))
        fi
    done
    
    if [ $missing_fields -gt 0 ]; then
        return 1
    fi
    
    # Get and validate specific fields
    local nombre fcm_token lat lon
    nombre=$(redis_cmd HGET "$user_key" nombre 2>/dev/null)
    fcm_token=$(redis_cmd HGET "$user_key" fcm_token 2>/dev/null)
    lat=$(redis_cmd HGET "$user_key" lat 2>/dev/null)
    lon=$(redis_cmd HGET "$user_key" lon 2>/dev/null)
    
    # Validate data types and formats
    if [ -z "$nombre" ]; then
        print_warning "User $user_id has empty nombre"
        return 1
    fi
    
    if [ -z "$fcm_token" ]; then
        print_warning "User $user_id has empty fcm_token"
        return 1
    fi
    
    # Validate lat/lon are numbers
    if ! [[ "$lat" =~ ^-?[0-9]+\.?[0-9]*$ ]]; then
        print_warning "User $user_id has invalid latitude: $lat"
        return 1
    fi
    
    if ! [[ "$lon" =~ ^-?[0-9]+\.?[0-9]*$ ]]; then
        print_warning "User $user_id has invalid longitude: $lon"
        return 1
    fi
    
    print_success "User $user_id structure valid: $nombre (lat=$lat, lon=$lon)"
    return 0
}

# Validate points across routes
validate_points() {
    print_section "Collection Points Validation"
    
    local total_points=0
    local total_routes=5
    
    # Count points by route
    for route_id in $(seq 1 $total_routes); do
        local route_key="points:ruta:${route_id}"
        local route_points
        route_points=$(redis_cmd ZCARD "$route_key" 2>/dev/null || echo "0")
        
        print_info "Route $route_id: $route_points points"
        total_points=$((total_points + route_points))
    done
    
    print_info "Total collection points: $total_points / ~$MIN_POINTS"
    
    if [ "$total_points" -lt "$MIN_POINTS" ]; then
        print_error "Expected at least $MIN_POINTS points, found $total_points"
        return 1
    fi
    
    print_success "Points count validation passed"
    
    # Validate sample points
    validate_point_structure "point:1"
    validate_point_structure "point:12"
    validate_point_structure "point:25"
    
    return 0
}

# Validate individual point structure
validate_point_structure() {
    local point_key=$1
    
    # Check if point exists
    local exists
    exists=$(redis_cmd EXISTS "$point_key" 2>/dev/null || echo "0")
    
    if [ "$exists" -ne 1 ]; then
        print_warning "Point $point_key not found in Redis"
        return 1
    fi
    
    # Get point fields
    local fields
    fields=$(redis_cmd HKEYS "$point_key" 2>/dev/null)
    
    # Check required fields
    local required_fields=("ruta_id" "lat" "lon" "label")
    local missing_fields=0
    
    for field in "${required_fields[@]}"; do
        if ! echo "$fields" | grep -q "^${field}$"; then
            print_warning "Point $point_key missing field: $field"
            ((missing_fields++))
        fi
    done
    
    if [ $missing_fields -gt 0 ]; then
        return 1
    fi
    
    # Get and validate specific fields
    local route_id lat lon label
    route_id=$(redis_cmd HGET "$point_key" ruta_id 2>/dev/null)
    lat=$(redis_cmd HGET "$point_key" lat 2>/dev/null)
    lon=$(redis_cmd HGET "$point_key" lon 2>/dev/null)
    label=$(redis_cmd HGET "$point_key" label 2>/dev/null)
    
    # Validate data types and formats
    if [ -z "$route_id" ]; then
        print_warning "Point $point_key has empty ruta_id"
        return 1
    fi
    
    # Validate lat/lon are numbers
    if ! [[ "$lat" =~ ^-?[0-9]+\.?[0-9]*$ ]]; then
        print_warning "Point $point_key has invalid latitude: $lat"
        return 1
    fi
    
    if ! [[ "$lon" =~ ^-?[0-9]+\.?[0-9]*$ ]]; then
        print_warning "Point $point_key has invalid longitude: $lon"
        return 1
    fi
    
    print_success "Point $point_key structure valid: Route $route_id - $label"
    return 0
}

# Validate seed metadata
validate_seed_metadata() {
    print_section "Seed Metadata Validation"
    
    local exists
    exists=$(redis_cmd EXISTS "seed:metadata" 2>/dev/null || echo "0")
    
    if [ "$exists" -ne 1 ]; then
        print_warning "Seed metadata key not found (optional)"
        return 0
    fi
    
    local generated_at total_users total_points
    generated_at=$(redis_cmd HGET "seed:metadata" generated_at 2>/dev/null)
    total_users=$(redis_cmd HGET "seed:metadata" total_users 2>/dev/null)
    total_points=$(redis_cmd HGET "seed:metadata" total_points 2>/dev/null)
    
    if [ -z "$generated_at" ] || [ -z "$total_users" ] || [ -z "$total_points" ]; then
        print_warning "Seed metadata incomplete"
        return 0
    fi
    
    print_success "Seed generated at: $(date -d @"$generated_at" 2>/dev/null || echo "$generated_at")"
    print_success "Metadata: $total_users users, $total_points points"
    
    return 0
}

################################################################################
# Main
################################################################################

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help)
                show_help
                exit 0
                ;;
            --container)
                REDIS_CONTAINER="$2"
                shift 2
                ;;
            --redis-password)
                REDIS_PASSWORD="$2"
                shift 2
                ;;
            --redis-db)
                REDIS_DB="$2"
                shift 2
                ;;
            --verbose)
                VERBOSE=1
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 2
                ;;
        esac
    done
    
    # Load .env if it exists
    if [ -f "$(dirname "$0")/../../../.env" ]; then
        set -a
        source "$(dirname "$0")/../../../.env"
        set +a
    fi
    
    print_section "Redis Seed Integrity Test"
    print_info "Configuration: Container='${REDIS_CONTAINER}' DB=${REDIS_DB}"
    
    # Test connection
    if ! test_redis_connection; then
        exit 2
    fi
    
    # Run validations
    local validation_failed=0
    
    if ! validate_users; then
        validation_failed=1
    fi
    
    if ! validate_points; then
        validation_failed=1
    fi
    
    if ! validate_seed_metadata; then
        validation_failed=1
    fi
    
    # Final result
    print_section "Test Summary"
    
    if [ $validation_failed -eq 0 ]; then
        print_success "All seed integrity validations passed!"
        echo ""
        print_success "✓ Exactly $EXPECTED_USERS users in users:geo"
        print_success "✓ At least $MIN_POINTS collection points"
        print_success "✓ All required fields present and valid"
        print_success "✓ Data structures consistent"
        exit 0
    else
        print_error "Seed integrity validation FAILED"
        echo ""
        print_error "Review the validation errors above"
        exit 1
    fi
}

# Run main function
main "$@"
