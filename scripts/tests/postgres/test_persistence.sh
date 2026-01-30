#!/bin/sh
# Comprueba persistencia de datos tras reinicio intencionado del servicio PostgreSQL
# Uso:
#   ./test_persistence.sh [table1 table2 ...]
# Si no se pasan tablas, usa la lista mínima: schema_version, rol, usuario, camion,
# ruta, punto_recoleccion, colonia, domicilio

set -eu

# Cargar .env (tres niveles arriba)
ENV_PATH="$(dirname "$0")/../../../.env"
if [ -f "$ENV_PATH" ]; then
  export $(grep -v '^#' "$ENV_PATH" | xargs) || true
fi

DOCKER_COMPOSE_FILE="docker/docker.compose.yml"
PG_SERVICE=${PG_SERVICE:-database}

# Mapear variables DB_ a PG_ si las PG_ no existen
PGUSER="${PGUSER:-${DB_USER:-postgres}}"
PGDATABASE="${PGDATABASE:-${DB_NAME:-postgres}}"
PGHOST="${PGHOST:-${DB_HOST:-db}}"
PGPORT="${PGPORT:-${DB_PORT:-5432}}"

MIN_TABLES="schema_version rol usuario camion ruta punto_recoleccion colonia domicilio"

sha256_cmd() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum | awk '{print $1}'
  elif command -v openssl >/dev/null 2>&1; then
    openssl dgst -sha256 | awk '{print $2}'
  else
    # no hay checksum disponible
    cat >/dev/null
    echo ""
  fi
}

compute_table_data_hash() {
  tbl="$1"
  # Para evitar falsos positivos, serializamos de forma determinista.
  # Para schema_version excluimos columnas volátiles (applied_at, applied_by)
  # y ordenamos por script_name,checksum.
  if [ "x$tbl" = "xschema_version" ]; then
    docker compose -f "$DOCKER_COMPOSE_FILE" exec -T "$PG_SERVICE" \
      sh -lc "psql -U \"$PGUSER\" -d \"$PGDATABASE\" -h \"$PGHOST\" -p \"$PGPORT\" -c \"COPY (SELECT script_name,type,checksum,description FROM schema_version ORDER BY script_name,checksum) TO STDOUT WITH CSV\"" 2>/dev/null |
      (sha256_cmd)
    return
  fi

  # Intentar obtener la(s) columna(s) PK para el orden
  pk_cols=$(docker compose -f "$DOCKER_COMPOSE_FILE" exec -T "$PG_SERVICE" \
    sh -lc "psql -U \"$PGUSER\" -d \"$PGDATABASE\" -h \"$PGHOST\" -p \"$PGPORT\" -t -A -c \"SELECT string_agg(quote_ident(a.attname),',') FROM pg_index i JOIN pg_attribute a ON a.attrelid=i.indrelid AND a.attnum=ANY(i.indkey) WHERE i.indrelid = '$tbl'::regclass AND i.indisprimary;\"" 2>/dev/null || true)

  pk_cols=$(echo "$pk_cols" | tr -d '[:space:]')
  if [ -n "$pk_cols" ]; then
    order_by="$pk_cols"
  else
    # No hay PK conocido; usar ORDER BY 1 como heurístico determinista
    order_by="1"
  fi

  # Columnas a excluir por tabla (volátiles). Extiende este case si necesitas más exclusiones.
  excluded_cols_for_table() {
    case "$1" in
      schema_version) echo "applied_at,applied_by" ;;
      usuario) echo "password_hash,last_login,updated_at" ;;
      rol) echo "updated_at" ;;
      camion) echo "updated_at" ;;
      ruta) echo "updated_at" ;;
      punto_recoleccion) echo "updated_at" ;;
      domicilio) echo "updated_at" ;;
      *) echo "" ;;
    esac
  }

  # Construir lista de columnas reales excluyendo las columnas volátiles
  excl=$(excluded_cols_for_table "$tbl" | tr -d '[:space:]')
  if [ -n "$excl" ]; then
    # obtener columnas de la tabla
    cols=$(docker compose -f "$DOCKER_COMPOSE_FILE" exec -T "$PG_SERVICE" \
      sh -lc "psql -U \"$PGUSER\" -d \"$PGDATABASE\" -h \"$PGHOST\" -p \"$PGPORT\" -t -A -c \"SELECT string_agg(quote_ident(column_name),',') FROM information_schema.columns WHERE table_name = '$tbl' ORDER BY ordinal_position;\"" 2>/dev/null || true)
    # Si por alguna razón no obtenemos columnas, fallback a usar *
    if [ -z "$cols" ]; then
      selcols="*"
    else
      # remover columnas excluidas
      IFS=','; set -f
      selcols=""
      for c in $(echo "$cols" | tr ',' '\n'); do
        skip=0
        for e in $(echo "$excl" | tr ',' '\n'); do
          if [ "$c" = "$e" ]; then skip=1; break; fi
        done
        if [ "$skip" -eq 0 ]; then
          if [ -z "$selcols" ]; then selcols="$c"; else selcols="$selcols,$c"; fi
        fi
      done
      set +f; IFS=' '
      if [ -z "$selcols" ]; then selcols="*"; fi
    fi
  else
    selcols="*"
  fi

  # Serializar columnas seleccionadas y ordenar por PK (o heurístico)
  docker compose -f "$DOCKER_COMPOSE_FILE" exec -T "$PG_SERVICE" \
    sh -lc "psql -U \"$PGUSER\" -d \"$PGDATABASE\" -h \"$PGHOST\" -p \"$PGPORT\" -c \"COPY (SELECT $selcols FROM \"$tbl\" ORDER BY $order_by) TO STDOUT WITH CSV\"" 2>/dev/null |
    (sha256_cmd)
}

compute_table_count() {
  tbl="$1"
  docker compose -f "$DOCKER_COMPOSE_FILE" exec -T "$PG_SERVICE" \
    psql -U "$PGUSER" -d "$PGDATABASE" -h "$PGHOST" -p "$PGPORT" -t -c "SELECT COUNT(*) FROM \"$tbl\";" 2>/dev/null | tr -d ' '
}

wait_for_pg() {
  # Espera hasta que psql responda o falle después de ~60s
  tries=0
  while :; do
    if docker compose -f "$DOCKER_COMPOSE_FILE" exec -T "$PG_SERVICE" \
         psql -U "$PGUSER" -d "$PGDATABASE" -h "$PGHOST" -p "$PGPORT" -t -c "SELECT 1;" >/dev/null 2>&1; then
      return 0
    fi
    tries=$((tries+1))
    if [ "$tries" -ge 30 ]; then
      echo "[ERROR] Timeout esperando a PostgreSQL después del reinicio." >&2
      return 1
    fi
    sleep 2
  done
}

usage() {
  echo "Uso: $0 [table1 table2 ...]"
  exit 2
}

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  usage
fi

TABLES="$*"
if [ -z "$TABLES" ]; then
  TABLES="$MIN_TABLES"
fi

TMPSNAP="$(mktemp -t pg_persist_snapshot.XXXX)"
trap 'rm -f "$TMPSNAP"' EXIT

echo "[PERSISTENCE] Tomando snapshot previo al reinicio..."
for t in $TABLES; do
  echo "[PERSISTENCE] tabla: $t"
  h=$(compute_table_data_hash "$t" || true)
  c=$(compute_table_count "$t" || echo "-")
  echo "$t|$c|$h" >> "$TMPSNAP"
  echo "  rows=$c  hash=${h:-(empty)}"
done

echo "[PERSISTENCE] Reiniciando servicio PostgreSQL ($PG_SERVICE)..."
docker compose -f "$DOCKER_COMPOSE_FILE" restart "$PG_SERVICE" || {
  echo "[ERROR] Falló el reinicio del servicio." >&2
  exit 3
}

echo "[PERSISTENCE] Esperando que PostgreSQL responda..."
if ! wait_for_pg; then
  exit 4
fi

echo "[PERSISTENCE] Re-evaluando tabla(s) después del reinicio..."
errors=0
while IFS='|' read -r tbl pre_count pre_hash; do
  new_count=$(compute_table_count "$tbl" || echo "-")
  new_hash=$(compute_table_data_hash "$tbl" || true)
  echo "[PERSISTENCE] $tbl: pre rows=$pre_count new rows=$new_count"
  if [ "x$pre_count" != "x$new_count" ]; then
    echo "[ERROR] Conteo diferente para $tbl: antes=$pre_count ahora=$new_count"
    errors=1
  else
    echo "[OK] Conteo coincide para $tbl"
  fi
  if [ -n "$pre_hash" ] && [ -n "$new_hash" ]; then
    if [ "x$pre_hash" != "x$new_hash" ]; then
      echo "[ERROR] Hash de datos diferente para $tbl"
      errors=1
    else
      echo "[OK] Hash de datos coincide para $tbl"
    fi
  else
    echo "[WARN] No fue posible calcular hash para $tbl (antes='${pre_hash:-}' ahora='${new_hash:-}')"
  fi
done < "$TMPSNAP"

if [ "$errors" -ne 0 ]; then
  echo "[PERSISTENCE] Persistencia verificada: FALLÓ (al menos una discrepancia)"
  exit 5
fi

echo "[PERSISTENCE] Persistencia verificada: OK"
exit 0
