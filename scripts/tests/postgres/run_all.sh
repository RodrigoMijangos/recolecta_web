#!/bin/sh
# Ejecuta la suite de pruebas PostgreSQL local (healthcheck, seed validation, persistence)
# Uso:
#   ./run_all_postgres.sh [--fail-fast] [-- <args-for-seed-validation>]
# Ejemplo:
#   ./run_all_postgres.sh --fail-fast -- --mode hybrid

set -eu

DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL_FAST=0
TRACE=0

usage() {
  echo "Uso: $0 [--fail-fast] [-- <args-for-test_seed_validation> ]"
  echo "  --fail-fast    Salir en la primera prueba que falle"
  exit 2
}

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  usage
fi

if [ "${1:-}" = "--fail-fast" ]; then
  FAIL_FAST=1
  shift
fi

# Opción para traza detallada (igual a pasar TRACE=1 en el entorno)
if [ "${1:-}" = "--trace" ]; then
  TRACE=1
  shift
fi

# Si existe el separador --, todo lo que venga después se pasa a test_seed_validation
SEED_ARGS=""
if [ "${1:-}" = "--" ]; then
  shift
  SEED_ARGS="$*"
fi

TESTS="
$DIR/test_healthcheck.sh
$DIR/test_seed_validation.sh
$DIR/test_persistence.sh
"

echo "[SUITE] Ejecutando suite PostgreSQL:"
passed=0
failed=0
failed_list=""

for t in $TESTS; do
  if [ ! -x "$t" ]; then
    # intentar ejecutar con bash si no es ejecutable
    cmd="bash"
  else
    cmd="$t"
  fi
  name="$(basename "$t")"
  echo "\n[SUITE] Ejecutando: $name"
  # Ejecutar con trazado solo si TRACE=1. Por defecto ejecutamos sin -x para evitar
  # imprimir cada línea/command del script.
  if [ "$TRACE" -eq 1 ]; then
    if [ "$name" = "test_seed_validation.sh" ]; then
      bash -x "$t" $SEED_ARGS || rc=$? || true
    else
      bash -x "$t" || rc=$? || true
    fi
  else
    if [ "$name" = "test_seed_validation.sh" ]; then
      bash "$t" $SEED_ARGS || rc=$? || true
    else
      bash "$t" || rc=$? || true
    fi
  fi
  rc=${rc:-$?}

  if [ "$rc" -eq 0 ]; then
    echo "[SUITE] $name: OK"
    passed=$((passed+1))
  else
    echo "[SUITE] $name: FAIL (exit $rc)"
    failed=$((failed+1))
    failed_list="$failed_list $name"
    if [ "$FAIL_FAST" -eq 1 ]; then
      break
    fi
  fi
done

echo "\n[SUITE] Resultado: passed=$passed failed=$failed"
if [ "$failed" -ne 0 ]; then
  echo "[SUITE] Tests fallidos:$failed_list"
  exit 10
fi

echo "[SUITE] Todas las pruebas pasaron."
exit 0
