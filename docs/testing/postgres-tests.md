# 🧪 PostgreSQL Test Suite

> Suite de pruebas para validación local de PostgreSQL (healthcheck, seed, persistencia)

**Ubicación:** `scripts/tests/postgres/`  
**Stack:** PostgreSQL 16 + Docker Compose + Bash  
**Patrón:** Similar a [redis-tests.md](redis-tests.md), pero con enfoque en persistencia y versioning de schema/seed

---

## 📋 Descripción General

La suite consta de 3 scripts independientes:

| Script | Propósito | Duración | Reinicia DB |
|--------|----------|----------|-------------|
| `test_healthcheck.sh` | Verifica disponibilidad básica (pg_isready, SELECT 1, CRUD) | ~1s | ❌ No |
| `test_seed_validation.sh` | Valida schema/seed aplicados; checksums; umbrales mínimos | ~5s | ❌ No |
| `test_persistence.sh` | Valida persistencia tras reinicio; hashing determinista | ~10s | ✅ **Sí** |

**Suite ejecutora:** `run_all.sh` — Ejecuta los 3 en secuencia con opciones de control.

---

## 🚀 Quick Start

### 📌 Antes de Commit

```bash
# Ejecuta suite completa de PostgreSQL (recomendado)
bash scripts/tests/postgres/run_all.sh

# Si algo falla, ejecuta con debug
bash scripts/tests/postgres/run_all.sh --trace
```

### Ejecutar suite completa

```bash
# Limpio, sin traza
bash scripts/tests/postgres/run_all.sh

# Con traza detallada (debug)
bash scripts/tests/postgres/run_all.sh --trace

# Salir al primer fallo
bash scripts/tests/postgres/run_all.sh --fail-fast

# Salir al primer fallo + traza
bash scripts/tests/postgres/run_all.sh --fail-fast --trace
```

### Ejecutar tests individuales

```bash
# Solo healthcheck (rápido)
bash scripts/tests/postgres/test_healthcheck.sh

# Seed validation (modo por defecto: hybrid)
bash scripts/tests/postgres/test_seed_validation.sh

# Seed validation (modo checksum solamente)
bash scripts/tests/postgres/test_seed_validation.sh --mode checksum

# Persistencia (reiniciará el servicio database)
bash scripts/tests/postgres/test_persistence.sh
```

---

## 🎯 Modos de Validación (test_seed_validation.sh)

**test_seed_validation.sh** soporta 3 modos:

| Modo | Verifica | Uso |
|------|----------|-----|
| `checksum` | Solo checksums en `schema_version` | Rápido (⚡) |
| `structure` | Existencia + umbrales de tablas | Liviano (📦) |
| `hybrid` | Ambos: checksums + estructura | **Recomendado** (🎯) — Defecto |

**Ejemplos:**
```bash
# Modo checksum (rápido)
bash scripts/tests/postgres/test_seed_validation.sh --mode checksum

# Modo structure (sin checksums)
bash scripts/tests/postgres/test_seed_validation.sh --mode structure

# Modo hybrid (recomendado, defecto)
bash scripts/tests/postgres/test_seed_validation.sh --mode hybrid
```

---

## ⚙️ Umbrales y Configuración

### Tablas Mínimas y Umbrales de Filas

| Tabla | Mínimo | Razón | Volátiles Excluidas |
|-------|--------|-------|-------------------|
| `schema_version` | 1 | Registro de aplicación | `applied_at,applied_by` |
| `usuario` | 2 | Admin + Usuario típico | `password_hash,last_login,updated_at` |
| `rol` | 1 | Rol base requerido | `updated_at` |
| `camion` | 1 | Al menos 1 vehículo | `updated_at` |
| `ruta` | 1 | Al menos 1 ruta | `updated_at` |
| `punto_recoleccion` | 1 | Al menos 1 punto | `updated_at` |
| `colonia` | 1 | Al menos 1 zona | (ninguna) |
| `domicilio` | 1 | Al menos 1 domicilio | `updated_at` |

**Para ajustar:** Edita `scripts/tests/postgres/test_seed_validation.sh`:
- Función `min_count_for_table()` — Umbrales mínimos
- Función `excluded_cols_for_table()` — Columnas volátiles a excluir del hash

---

## 📖 Detalle de Cada Script

### `test_healthcheck.sh`

Verifica que PostgreSQL está accesible y responde a operaciones básicas.

**¿Qué hace?**
1. Ejecuta `pg_isready` dentro del contenedor (vía `docker compose exec`).
2. Ejecuta `SELECT 1` para confirmar disponibilidad.
3. Ejecuta CRUD completo (INSERT, SELECT, UPDATE, DELETE) en una tabla temporal.

**¿Cuándo ejecutar?**
- Al levantar servicios (parte de CI/CD).
- Antes de ejecutar otros tests.

**¿Qué puede fallar?**
- Contenedor no levantado.
- Credenciales incorrectas (DB_USER, DB_PASSWORD, etc.).
- Puerto PostgreSQL no accesible.

**Ejemplo:**
```bash
bash scripts/tests/postgres/test_healthcheck.sh
```

---

### `test_seed_validation.sh`

Valida que el schema (db_script.sql) y seed (seed.sql) fueron aplicados correctamente, usando checksums y umbrales mínimos.

**¿Qué hace?**
1. Calcula SHA256 de `gin-backend/db_script.sql` y `docker/postgresql/seeds/seed.sql` (archivos locales).
2. Compara checksums registrados en tabla `schema_version` de la BD.
3. Verifica existencia de tablas mínimas: `schema_version`, `rol`, `usuario`, `camion`, `ruta`, `punto_recoleccion`, `colonia`, `domicilio`.
4. Verifica umbrales mínimos de filas por tabla (p.ej., `usuario >= 2`).
5. Ejecuta queries opcionales en `scripts/tests/postgres/seed_checks.sql` (si existe).

**Modos de validación:**

| Modo | Verifica | Uso |
|------|----------|-----|
| `checksum` | Solo checksums en `schema_version` | Rápido; confianza en init script |
| `structure` | Existencia + umbrales de tablas | Liviano; sin overhead de checksums |
| `hybrid` (defecto) | Ambos: checksums + estructura | **Recomendado** para CI/CD |

**Umbrales configurables:**
```bash
# En el script:
min_count_for_table() {
  case "$1" in
    schema_version) echo 1 ;;  # registro de versiones
    usuario) echo 2 ;;         # admin + usuario
    camion) echo 1 ;;
    # ... más tablas
  esac
}
```

**Excluir checksums de update:**
```bash
excluded_cols_for_table() {
  case "$1" in
    schema_version) echo "applied_at,applied_by" ;;
    usuario) echo "password_hash,last_login,updated_at" ;;
    # ... más columnas volátiles
  esac
}
```

**¿Cuándo ejecutar?**
- Después de `test_healthcheck.sh` (siempre).
- En CI: antes de ejecutar migraciones/seeds.
- Localmente: después de cambios en schema/seed.

**Ejemplo:**
```bash
# Modo por defecto (hybrid)
bash scripts/tests/postgres/test_seed_validation.sh

# Solo checksums
bash scripts/tests/postgres/test_seed_validation.sh --mode checksum

# Con tabla específica (ej., verificar solo rol)
bash scripts/tests/postgres/test_seed_validation.sh --mode hybrid rol

# Ejecutar seed antes de validar (ATENCIÓN: puede no ser idempotente)
bash scripts/tests/postgres/test_seed_validation.sh --run-seed --mode hybrid
```

**Flags:**
- `--mode {checksum|structure|hybrid}` — Modo de validación.
- `--run-seed` — Ejecutar seed.sql antes de validar (⚠️ no idempotente; úsalo solo si sabes que es seguro).

---

### `test_persistence.sh`

Valida que los datos persisten tras un reinicio intencional del servicio PostgreSQL.

**¿Qué hace?**
1. Toma snapshot (conteos + hashes de datos) de las tablas mínimas.
2. Reinicia el servicio `database` (via `docker compose restart`).
3. Espera a que PostgreSQL responda (retry ~30x cada 2s).
4. Compara conteos y hashes después del reinicio.
5. Reporta discrepancias (pérdida de datos).

**Hashing determinista:**
- Serializa datos con `COPY (SELECT <cols> FROM table ORDER BY <pk>)` para garantizar orden.
- Excluye columnas volátiles por tabla (p.ej., `updated_at`, `password_hash`).
- Calcula SHA256 de la salida.

**¿Cuándo ejecutar?**
- Después de cambios significativos en configuración de BD.
- En CI: después de cambios en Dockerfile o docker-compose.yml.
- Antes de deploy a producción.

**Ejemplo:**
```bash
# Ejecuta con reinicio (toma ~10-15s)
bash scripts/tests/postgres/test_persistence.sh
```

**Configuración de exclusiones:**
```bash
excluded_cols_for_table() {
  case "$1" in
    usuario) echo "password_hash,last_login,updated_at" ;;
    rol) echo "updated_at" ;;
    # ... más tablas
  esac
}
```

---

## 🎯 Umbrales y Configuración

### Tablas Mínimas
```
schema_version  (control de versiones)
rol             (permisos/roles)
usuario         (cuentas; mín. 2: admin + usuario)
camion          (flota)
ruta            (rutas cargables)
punto_recoleccion (nodos de recolección)
colonia         (colonias/barrios)
domicilio       (direcciones)
```

### Umbrales por Tabla
| Tabla | Mínimo | Razón |
|-------|--------|-------|
| `schema_version` | 1 | Registro de aplicación |
| `usuario` | 2 | Admin + Usuario típico |
| `rol` | 1 | Rol base requerido |
| `camion` | 1 | Al menos 1 vehículo |
| `ruta` | 1 | Al menos 1 ruta |
| `punto_recoleccion` | 1 | Al menos 1 punto |
| `colonia` | 1 | Al menos 1 zona |
| `domicilio` | 1 | Al menos 1 domicilio |

**Para ajustar:** Edita `scripts/tests/postgres/test_seed_validation.sh` en la función `min_count_for_table()`.

---

## 🔧 Suite Ejecutora: `run_all.sh`

Ejecuta los 3 tests en secuencia y resume resultados.

**Opciones:**
```bash
run_all.sh [--fail-fast] [--trace] [-- <args-for-seed-validation>]
```

**Ejemplos:**
```bash
# Suite completa, sin debug
bash scripts/tests/postgres/run_all.sh

# Suite con traza (muestra cada comando bash)
bash scripts/tests/postgres/run_all.sh --trace

# Suite con fail-fast (salir al primer fallo)
bash scripts/tests/postgres/run_all.sh --fail-fast

# Suite + pasar flags a seed validation
bash scripts/tests/postgres/run_all.sh -- --mode checksum

# Suite + fail-fast + trace + flags
bash scripts/tests/postgres/run_all.sh --fail-fast --trace -- --mode hybrid
```

**Salida:**
```
[SUITE] Ejecutando suite PostgreSQL:

[SUITE] Ejecutando: test_healthcheck.sh
[...output del test...]
[SUITE] test_healthcheck.sh: OK

[SUITE] Ejecutando: test_seed_validation.sh
[...output del test...]
[SUITE] test_seed_validation.sh: OK

[SUITE] Ejecutando: test_persistence.sh
[...reinicia database, espera...]
[SUITE] test_persistence.sh: OK

[SUITE] Resultado: passed=3 failed=0
[SUITE] Todas las pruebas pasaron.
```

---

## 📚 Conceptos Técnicos

### Serialización Determinista
Sin `ORDER BY`, SQL no garantiza orden de filas (resultado = conjunto). Esto causa falsos positivos al hashear.

**Solución:** `COPY (SELECT * FROM tabla ORDER BY <pk>) TO STDOUT WITH CSV` — garantiza orden y permite hashing estable.

### Exclusión de Columnas Volátiles
Campos como `updated_at`, `password_hash`, `last_login` pueden cambiar sin que cambie el dato "real".

**Solución:** Extraer columnas de `information_schema.columns`, filtrar las volátiles, incluir solo las relevantes en el hash.

### Tabla `schema_version`
Registra metadata de schema/seed aplicados:
- `script_name` (p.ej., "db_script.sql")
- `type` ("schema" o "seed")
- `checksum` (SHA256 del archivo)
- `description` (p.ej., "applied update")
- `applied_at` (timestamp)
- `applied_by` (usuario)

Se completa en `docker/postgresql/init-scripts/init-database.sh` al crear/reinicializar la BD.

---

## 🚨 Troubleshooting

### `pg_isready` falla
**Síntoma:** `[ERROR] pg_isready no responde`  
**Causa:** Contenedor no levantado, puerto incorrecto, o credenciales.  
**Solución:**
```bash
docker compose -f docker/docker.compose.yml --env-file .env ps
# Verifica que database esté Running
docker compose -f docker/docker.compose.yml --env-file .env logs database
```

### Checksum no registrado
**Síntoma:** `[ERROR] Checksum no registrado en la BD para db_script.sql`  
**Causa:** `schema_version` vacío; init script no se ejecutó o no registró checksums.  
**Solución:**
```bash
# Recrear servicios (ejecutará init scripts)
docker compose -f docker/docker.compose.yml --env-file .env down
docker compose -f docker/docker.compose.yml --env-file .env up -d

# Luego ejecutar validación
bash scripts/tests/postgres/test_seed_validation.sh
```

### Persistencia falla después del reinicio
**Síntoma:** `[ERROR] Hash de datos diferente para tabla X`  
**Causa:** Datos realmente perdidos, o exclusiones de columnas insuficientes.  
**Solución:**
1. Verificar que PostgreSQL levanta sin errores:
   ```bash
   docker compose -f docker/docker.compose.yml --env-file .env restart database
   docker compose -f docker/docker.compose.yml --env-file .env logs database
   ```
2. Revisar qué columnas cambiaron (ajustar exclusiones en script).
3. Si es `updated_at` o similar: Es esperado; añádelo a `excluded_cols_for_table()`.

### Tests no se ejecutan
**Síntoma:** `permission denied: scripts/tests/postgres/test_healthcheck.sh`  
**Solución:**
```bash
chmod +x scripts/tests/postgres/*.sh
```

---

## 🔗 Referencias

- **Redis Tests:** [docs/testing/redis-tests.md](redis-tests.md)
- **Database Ops:** [docs/02-database-operations.md](../02-database-operations.md)
- **Setup Local:** [docs/01-setup-local.md](../01-setup-local.md)
- **Main README:** [README.md](../../README.md)

---

**Última actualización:** 30 de Enero de 2026 | **Versión:** 1.0-alpha
