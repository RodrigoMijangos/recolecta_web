#!/bin/sh
# ============================================================================
# generate-seed-data.sh - Generador de datos realistas para Redis
# ============================================================================
# Genera 200 usuarios distribuidos en 8 colonias alrededor de Suchiapa, Chiapas
# Usuarios: 100-299 (200 ciudadanos)
# Colonias: 1-8 basadas en zonas (Norte, Centro, Sur)
# Rutas: 5 rutas operativas con 5 puntos cada una (25 total)
# 
# Coordenadas base: Suchiapa, Chiapas (16.5896° N, -93.0547° W)
# ============================================================================

set -e

# Configuración
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SEEDS_DIR="$SCRIPT_DIR/../seeds"
OUTPUT_FILE="$SEEDS_DIR/redis-seed_v1_$(date '+%Y%m%d_%H%M%S').txt"

# Crear symlink al archivo más reciente
LATEST_LINK="$SEEDS_DIR/redis-seed-latest.txt"

# Coordenadas base de Suchiapa, Chiapas
BASE_LAT="16.5896"
BASE_LON="-93.0547"

# Crear archivo de seed
mkdir -p "$SEEDS_DIR"
> "$OUTPUT_FILE"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Generando datos de seed para Redis..." >&2

# ============================================================================
# 1. DEFINICIÓN DE COLONIAS (usando variables indexadas)
# ============================================================================
# Colonias como variables (en sh puro, simular arrays)
COLONIA_1="Centro Histórico|0.0|0.0"
COLONIA_2="Colonia Industrial|0.015|-0.012"
COLONIA_3="Las Palmas|0.018|0.008"
COLONIA_4="Vista Hermosa|-0.020|0.010"
COLONIA_5="Jardines del Valle|-0.025|-0.015"
COLONIA_6="El Mirador|-0.008|0.015"
COLONIA_7="Residencial San Miguel|0.022|-0.005"
COLONIA_8="Fraccionamiento Los Pinos|-0.012|-0.020"

# ============================================================================
# 2. DEFINICIÓN DE RUTAS
# ============================================================================
RUTA_1="Ruta Centro A|1,6|matutino|Centro"
RUTA_2="Ruta Centro B|1,6|vespertino|Centro"
RUTA_3="Ruta Norte|2,3,7|matutino|Norte"
RUTA_4="Ruta Sur|4,5,8|matutino|Sur"
RUTA_5="Ruta Sur Tarde|4,5,8|vespertino|Sur"

# Función auxiliar para obtener colonia
get_colonia() {
    eval "echo \"\$COLONIA_$1\""
}

# Función auxiliar para obtener ruta
get_ruta() {
    eval "echo \"\$RUTA_$1\""
}

# ============================================================================
# 3. GENERACIÓN DE PUNTOS DE RECOLECCIÓN (25 total, 5 por ruta)
# ============================================================================
echo "# ================================================================" >> "$OUTPUT_FILE"
echo "# PUNTOS DE RECOLECCIÓN (GEO Index)" >> "$OUTPUT_FILE"
echo "# ================================================================" >> "$OUTPUT_FILE"

PUNTO_ID=1
for RUTA_ID in $(seq 1 5); do
    RUTA_DATA=$(get_ruta "$RUTA_ID")
    RUTA_NAME=$(echo "$RUTA_DATA" | cut -d'|' -f1)
    COLONIAS_STR=$(echo "$RUTA_DATA" | cut -d'|' -f2)
    TURNO=$(echo "$RUTA_DATA" | cut -d'|' -f3)
    ZONA=$(echo "$RUTA_DATA" | cut -d'|' -f4)
    
    for i in $(seq 0 4); do
        COLONIA_IDX=$((i % $(echo "$COLONIAS_STR" | tr ',' '\n' | wc -l) + 1))
        COLONIA_ID=$(echo "$COLONIAS_STR" | cut -d',' -f$COLONIA_IDX)
        
        COLONIA_DATA=$(get_colonia "$COLONIA_ID")
        COLONIA_NAME=$(echo "$COLONIA_DATA" | cut -d'|' -f1)
        LAT_OFFSET=$(echo "$COLONIA_DATA" | cut -d'|' -f2)
        LON_OFFSET=$(echo "$COLONIA_DATA" | cut -d'|' -f3)
        
        RANDOM_LAT_OFFSET=$((RANDOM % 200 - 100))
        RANDOM_LON_OFFSET=$((RANDOM % 200 - 100))
        
        PUNTO_LAT=$(awk "BEGIN {printf \"%.5f\", $BASE_LAT + $LAT_OFFSET + $RANDOM_LAT_OFFSET * 0.00001}")
        PUNTO_LON=$(awk "BEGIN {printf \"%.5f\", $BASE_LON + $LON_OFFSET + $RANDOM_LON_OFFSET * 0.00001}")
        
        CP_CODE="PR-$(printf "%03d" $RUTA_ID)-$(printf "%03d" $((i+1)))"
        
        echo "GEOADD points:ruta:$RUTA_ID $PUNTO_LON $PUNTO_LAT punto:$PUNTO_ID" >> "$OUTPUT_FILE"
        
        SAFE_COLONIA_NAME=$(echo "$COLONIA_NAME" | tr ' ' '_')
        echo "HSET point:$PUNTO_ID ruta_id $RUTA_ID colonia_id $COLONIA_ID cp_code $CP_CODE label Punto_${PUNTO_ID}_${SAFE_COLONIA_NAME} lat $PUNTO_LAT lon $PUNTO_LON" >> "$OUTPUT_FILE"
        
        PUNTO_ID=$((PUNTO_ID + 1))
    done
done

# ============================================================================
# 4. GENERACIÓN DE USUARIOS CIUDADANOS (100-299)
# ============================================================================
echo "# ================================================================" >> "$OUTPUT_FILE"
echo "# USUARIOS CIUDADANOS (100-299)" >> "$OUTPUT_FILE"
echo "# ================================================================" >> "$OUTPUT_FILE"

for USER_NUM in $(seq 0 199); do
    USER_ID=$((100 + USER_NUM))
    
    COLONIA_ID=$(((USER_NUM % 8) + 1))
    COLONIA_DATA=$(get_colonia "$COLONIA_ID")
    COLONIA_NAME=$(echo "$COLONIA_DATA" | cut -d'|' -f1)
    LAT_OFFSET=$(echo "$COLONIA_DATA" | cut -d'|' -f2)
    LON_OFFSET=$(echo "$COLONIA_DATA" | cut -d'|' -f3)
    
    RANDOM_LAT_OFFSET=$((RANDOM % 300 - 150))
    RANDOM_LON_OFFSET=$((RANDOM % 300 - 150))
    
    USER_LAT=$(awk "BEGIN {printf \"%.5f\", $BASE_LAT + $LAT_OFFSET + $RANDOM_LAT_OFFSET * 0.00008}")
    USER_LON=$(awk "BEGIN {printf \"%.5f\", $BASE_LON + $LON_OFFSET + $RANDOM_LON_OFFSET * 0.00008}")
    
    FCM_TOKEN="cI$(printf '%016x' $((RANDOM * RANDOM)))et$(printf '%010d' $RANDOM)=="
    
    CREATION_TS=$((1704067200 + USER_NUM * 3600))
    EXPIRY_TS=$((CREATION_TS + 2592000))
    
    echo "GEOADD users:geo $USER_LON $USER_LAT user:$USER_ID" >> "$OUTPUT_FILE"
    
    echo "HSET user:$USER_ID nombre Usuario_${USER_ID} colonia_id $COLONIA_ID fcm_token $FCM_TOKEN fcm_status valid fcm_created_at $CREATION_TS fcm_expires_at $EXPIRY_TS lat $USER_LAT lon $USER_LON" >> "$OUTPUT_FILE"
done

# ============================================================================
# 5. GENERACIÓN DE RUTAS Y PUNTOS ORDENADOS
# ============================================================================
echo "# ================================================================" >> "$OUTPUT_FILE"
echo "# RUTAS: PUNTOS EN ORDEN (Linear Vector)" >> "$OUTPUT_FILE"
echo "# ================================================================" >> "$OUTPUT_FILE"

PUNTO_ID=1
for RUTA_ID in $(seq 1 5); do
    for i in $(seq 1 5); do
        echo "RPUSH route:points:$RUTA_ID punto:$PUNTO_ID" >> "$OUTPUT_FILE"
        PUNTO_ID=$((PUNTO_ID + 1))
    done
    echo "HSET route:$RUTA_ID nombre Ruta_$(printf '%02d' $RUTA_ID) total_points 5 status active" >> "$OUTPUT_FILE"
done

# ============================================================================
# 6. CONFIGURACIÓN INICIAL DE ESTADO DE CAMIONES
# ============================================================================
echo "# ================================================================" >> "$OUTPUT_FILE"
echo "# ESTADO DE CAMIONES (Truck State)" >> "$OUTPUT_FILE"
echo "# ================================================================" >> "$OUTPUT_FILE"

for CAMION_ID in $(seq 1 6); do
    RUTA_ID=$(((CAMION_ID - 1) % 5 + 1))
    PUNTO_ACTUAL=$((CAMION_ID % 5 + 1))
    
    echo "HSET truck:$CAMION_ID:state ruta_id $RUTA_ID punto_id_actual $PUNTO_ACTUAL status en_ruta lat $BASE_LAT lon $BASE_LON last_update $(date +%s)" >> "$OUTPUT_FILE"
done

# ============================================================================
# 7. CONFIGURACIÓN DE HISTORIAL Y LOGS
# ============================================================================
echo "# ================================================================" >> "$OUTPUT_FILE"
echo "# HISTORIAL DE VACIADOS (24h)" >> "$OUTPUT_FILE"
echo "# ================================================================" >> "$OUTPUT_FILE"

# Generar 15 registros de vaciado con timestamps variados
for i in $(seq 1 15); do
    CAMION_ID=$(((i % 6) + 1))
    RELLENO_ID=$(((i % 2) + 1))
    RUTA_ID=$(((i % 5) + 1))
    TS=$(($(date +%s) - (86400 * (i % 3))))  # Últimos 3 días
    
    echo "RPUSH historial:vaciado:$RUTA_ID:$RELLENO_ID \"camion:$CAMION_ID|ts:$TS|status:completado\"" >> "$OUTPUT_FILE"
done

# ============================================================================
# 8. CONFIGURACIÓN DE NOTIFICACIONES
# ============================================================================
echo "# ================================================================" >> "$OUTPUT_FILE"
echo "# NOTIFICACIONES: Deduplicación por estado" >> "$OUTPUT_FILE"
echo "# ================================================================" >> "$OUTPUT_FILE"

# Crear conjuntos de notificaciones enviadas (SET - sin duplicados por día)
TODAY=$(date +%Y-%m-%d)
for USER_ID in $(seq 100 110); do  # Primeros 11 usuarios
    for CAMION_ID in $(seq 1 3); do
        for STATE in "WARN" "ARRIVAL" "DEPARTURE"; do
            # Clave: notification:sent:{user_id}:{camion_id}:{date}:{state}
            echo "SADD notification:sent:$USER_ID:$CAMION_ID:$TODAY:$STATE \"1\"" >> "$OUTPUT_FILE"
        done
    done
done

# ============================================================================
# 9. MÉTRICA DE NOTIFICACIONES
# ============================================================================
echo "# ================================================================" >> "$OUTPUT_FILE"
echo "# MÉTRICAS DE NOTIFICACIONES" >> "$OUTPUT_FILE"
echo "# ================================================================" >> "$OUTPUT_FILE"

echo "HSET notification:metrics total_sent 0 warn_count 0 arrival_count 0 departure_count 0 comeback_count 0 fcm_success 0 fcm_failed 0" >> "$OUTPUT_FILE"

# ============================================================================
# 10. CONFIGURACIÓN DE VALIDACIÓN
# ============================================================================
echo "# ================================================================" >> "$OUTPUT_FILE"
echo "# VALIDACIÓN DEL SEED" >> "$OUTPUT_FILE"
echo "# ================================================================" >> "$OUTPUT_FILE"

echo "HSET seed:metadata generated_at $(date +%s) generator_version 1.0 total_users 200 total_points 25 total_routes 5" >> "$OUTPUT_FILE"

# Calcular checksum del seed (sin metadata header) y anteponer metadata estricta
compute_checksum() {
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | awk '{print $1}'
    elif command -v openssl >/dev/null 2>&1; then
        openssl sha256 "$1" | awk '{print $2}'
    else
        md5sum "$1" | awk '{print $1}'
    fi
}

CHECKSUM=$(compute_checksum "$OUTPUT_FILE")
GENERATED_AT=$(date +%s)

# Prepend metadata header (first line) and replace file
TMP_FINAL="${OUTPUT_FILE}.withmeta"
echo "# SEED-METADATA: version=1.0 checksum=$CHECKSUM users=200 points=25 routes=5 generated_at=$GENERATED_AT" > "$TMP_FINAL"
cat "$OUTPUT_FILE" >> "$TMP_FINAL"
mv "$TMP_FINAL" "$OUTPUT_FILE"

# Crear symlink al archivo más reciente
ln -sf "$(basename "$OUTPUT_FILE")" "$LATEST_LINK"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Seed generado exitosamente en: $OUTPUT_FILE" >&2
echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Symlink creado: redis-seed-latest.txt" >&2
echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Estadísticas:" >&2
echo "   - 200 usuarios (IDs 100-299)" >&2
echo "   - 8 colonias distribuidas" >&2
echo "   - 5 rutas x 5 puntos = 25 puntos de recolección" >&2
echo "   - Base de coordenadas: Suchiapa, Chiapas (16.5896°N, -93.0547°W)" >&2
echo "   - FCM tokens generados automáticamente" >&2
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Próximo paso: cargar con load-redis.sh" >&2
