#!/bin/bash
# ============================================================================
# init-if-empty.sh - Inicializador condicional para Docker
# ============================================================================
# Script que se ejecuta en el entrypoint de Docker para cargar datos solo
# si Redis está vacío. Evita duplicación de datos.
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Esperar a que Redis esté disponible
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Esperando a Redis..."
for i in {1..30}; do
    if redis-cli -h redis ping > /dev/null 2>&1; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Redis disponible"
        break
    fi
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Intento $i/30..."
    sleep 1
done

# Verificar si ya hay datos
DBSIZE=$(redis-cli DBSIZE | grep -oP '(?<=:)\d+')

if [[ $DBSIZE -eq 0 ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Redis vacío - inicializando..."
    
    # Generar datos si no existen
    if [[ ! -f "$SCRIPT_DIR/../seeds/redis-seed.txt" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Generando seed..."
        bash "$SCRIPT_DIR/generate-seed-data.sh"
    fi
    
    # Cargar datos
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cargando datos..."
    bash "$SCRIPT_DIR/load-redis.sh" redis 6379 "$REDIS_PASSWORD"
    
    # Verificar carga
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Verificando integridad..."
    bash "$SCRIPT_DIR/verify-redis.sh" redis 6379 "$REDIS_PASSWORD"
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Inicialización completada"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Redis ya contiene datos ($DBSIZE claves) - saltando inicialización"
fi
