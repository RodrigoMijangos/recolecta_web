#!/bin/sh
# ============================================================================
# init-if-empty.sh - Inicializador condicional para Docker
# ============================================================================
# Script que se ejecuta en el entrypoint de Docker para cargar datos solo
# si Redis está vacío. Evita duplicación de datos.
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Parse args
FORCE_SEED=0
while [ "$#" -gt 0 ]; do
    case "$1" in
        --force) FORCE_SEED=1; shift ;;
        *) shift ;;
    esac
done

# If REDIS_PASSWORD present, export REDISCLI_AUTH so redis-cli doesn't need -a
if [ -n "$REDIS_PASSWORD" ]; then
    export REDISCLI_AUTH="$REDIS_PASSWORD"
fi

# Esperar a que Redis esté disponible
echo "[ESPERANDO] Esperando a Redis..."
echo "[DETALLE] Esperando a Redis..." >&2
for i in $(seq 1 30); do
    if redis-cli -h redis ping > /dev/null 2>&1; then
        echo "[OK] Redis disponible"
        echo "[DETALLE] Redis respondió al PING" >&2
        break
    fi
    echo "[DETALLE] Intento $i/30..." >&2
    sleep 1
done

# Verificar si ya hay datos
DBSIZE=$(redis-cli DBSIZE 2>/dev/null || echo "")
if ! echo "$DBSIZE" | grep -q '^[0-9]*$'; then
    INFO_KEYSPACE=$(redis-cli INFO keyspace 2>/dev/null || echo "")
    DBSIZE=$(echo "$INFO_KEYSPACE" | sed -n 's/.*keys=\([0-9]*\).*/\1/p' | head -1)
    DBSIZE=${DBSIZE:-0}
fi

if [ "$DBSIZE" -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Redis vacío - inicializando..."
    
    SEED_DIR="$SCRIPT_DIR/../seeds"
    LATEST_LINK="$SEED_DIR/redis-seed-latest.txt"

    need_generate=0
    if [ "$FORCE_SEED" -eq 1 ]; then
        need_generate=1
    else
        # Check if a latest seed exists and validate metadata + checksum
        if [ -L "$LATEST_LINK" ] || [ -f "$LATEST_LINK" ]; then
            # Resolve target
            link_target=$(readlink "$LATEST_LINK" 2>/dev/null || true)
            if [ -z "$link_target" ]; then
                SEED_FILE="$LATEST_LINK"
            else
                # If link_target is absolute use it, otherwise it's relative to seeds dir
                case "$link_target" in
                    /*) SEED_FILE="$link_target" ;;
                    *) SEED_FILE="$SEED_DIR/$link_target" ;;
                esac
            fi

            if [ -f "$SEED_FILE" ]; then
                meta_line=$(head -n1 "$SEED_FILE" 2>/dev/null || true)
                if echo "$meta_line" | grep -q '^# SEED-METADATA:'; then
                    # extract checksum and fields
                    checksum_meta=$(echo "$meta_line" | awk -F"checksum=" '{print $2}' | awk '{print $1}' 2>/dev/null || true)
                    users_meta=$(echo "$meta_line" | awk -F"users=" '{print $2}' | awk '{print $1}' 2>/dev/null || true)
                    points_meta=$(echo "$meta_line" | awk -F"points=" '{print $2}' | awk '{print $1}' 2>/dev/null || true)
                    routes_meta=$(echo "$meta_line" | awk -F"routes=" '{print $2}' | awk '{print $1}' 2>/dev/null || true)

                    # compute actual checksum of file excluding first line
                    tail -n +2 "$SEED_FILE" > "$SEED_FILE.check.tmp"
                    if command -v sha256sum >/dev/null 2>&1; then
                        actual_checksum=$(sha256sum "$SEED_FILE.check.tmp" | awk '{print $1}')
                    elif command -v openssl >/dev/null 2>&1; then
                        actual_checksum=$(openssl sha256 "$SEED_FILE.check.tmp" | awk '{print $2}')
                    else
                        actual_checksum=$(md5sum "$SEED_FILE.check.tmp" | awk '{print $1}')
                    fi
                    rm -f "$SEED_FILE.check.tmp"

                    if [ "$actual_checksum" = "$checksum_meta" ] && [ "$users_meta" = "200" ] && [ "$points_meta" = "25" ] && [ "$routes_meta" = "5" ]; then
                        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Seed existente válido: $SEED_FILE (checksum match)"
                        need_generate=0
                    else
                        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Seed existente inválido o desactualizado: regenerando"
                        need_generate=1
                    fi
                else
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Metadata no encontrada en $SEED_FILE: regenerando"
                    need_generate=1
                fi
            else
                need_generate=1
            fi
        else
            need_generate=1
        fi
    fi

    if [ "$need_generate" -eq 1 ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Generando seed..."
        sh "$SCRIPT_DIR/generate-seed-data.sh"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Usando seed existente, no se genera uno nuevo"
    fi
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cargando datos..."
    sh "$SCRIPT_DIR/load-redis.sh" redis 6379 "$REDIS_PASSWORD"
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Verificando integridad..."
    sh "$SCRIPT_DIR/verify-redis.sh" redis 6379 "$REDIS_PASSWORD"
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Inicialización completada"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Redis ya contiene datos ($DBSIZE claves) - saltando inicialización"
fi
