# 🗄️ Database Operations - Dump, Restore & Seed

> Runbook operacional para backups, restores y seed de datos en desarrollo local

## Requisitos Previos

- Docker Compose levantado (ver [01-setup-local.md](01-setup-local.md))
- Variables `.env` configuradas (`DB_NAME`, `DB_USER`, `DB_PASSWORD`)
- `DUMPS_HOST_PATH` en `.env` (ruta donde se guardan los dumps localmente)
- Comando `docker compose` disponible

---

## 📦 Crear Dump (Backup)

### Comando automático

```bash
docker compose -f docker/docker.compose.yml --env-file .env exec database \
  /usr/local/bin/init_dump.sh
```

Resultado:
- Archivo dump guardado en `/dumps/<DB_NAME>-<TIMESTAMP>.sql`
- Host: `${DUMPS_HOST_PATH}/<DB_NAME>-<TIMESTAMP>.sql` (ej. `./docker/postgresql/dumps/proyecto_recolecta-20260127171638.sql`)
- Tamaño mínimo esperado: >50 KB (vacío es sospechoso)

### Validación del dump

```bash
# Ver archivo creado
ls -lh docker/postgresql/dumps/

# Verificar que no está vacío
wc -l docker/postgresql/dumps/proyecto_recolecta-*.sql

# Peek al contenido (primeras líneas)
head -20 docker/postgresql/dumps/proyecto_recolecta-*.sql
```

**Checklist:**
- ✅ Archivo existe y tiene tamaño > 0
- ✅ Contiene sentencias `CREATE TABLE`, `INSERT`, etc.
- ✅ No tiene errores visibles en primeras líneas

---

## 🔄 Restaurar desde Dump (Restore)

### Procedimiento seguro (paso 1: staging)

Crear BD temporal para probar restore **sin tocar la base de datos principal**:

```bash
# 1. Conectar a PostgreSQL
docker compose -f docker/docker.compose.yml --env-file .env exec -T database \
  psql -U $DB_USER -d $DB_NAME

# 2. Dentro de psql, crear BD temporal
CREATE DATABASE proyecto_recolecta_test;
\c proyecto_recolecta_test

# 3. Salir
\q
```

### Restaurar en staging

```bash
# Restaurar dump en BD de test
docker compose -f docker/docker.compose.yml --env-file .env exec -T database \
  bash -c "cat /dumps/proyecto_recolecta-20260127171638.sql | psql -U $DB_USER -d proyecto_recolecta_test"

# O directamente (sin cat)
docker compose -f docker/docker.compose.yml --env-file .env exec -T database \
  psql -U $DB_USER -d proyecto_recolecta_test -f /dumps/proyecto_recolecta-20260127171638.sql
```

### Validar restore en staging

```bash
# Conectar a BD de test
docker compose -f docker/docker.compose.yml --env-file .env exec -T database \
  psql -U $DB_USER -d proyecto_recolecta_test -c \
  "SELECT COUNT(*) as total_tables FROM information_schema.tables WHERE table_schema = 'public';"

# Verificar datos específicos
docker compose -f docker/docker.compose.yml --env-file .env exec -T database \
  psql -U $DB_USER -d proyecto_recolecta_test -c \
  "SELECT COUNT(*) FROM rol; SELECT COUNT(*) FROM usuario;"
```

Checklist:
- ✅ Restore completa sin errores
- ✅ Número de tablas correcto (debería ser 26 incluyendo schema_version)
- ✅ Datos visibles en tablas clave

### Restaurar en producción (si validó staging)

**⚠️ ADVERTENCIA:** este paso sobrescribe datos actuales.

```bash
# 1. DETENER LA APP (evitar escrituras mientras restauras)
docker compose -f docker/docker.compose.yml --env-file .env down

# 2. Restaurar sobre BD actual
docker compose -f docker/docker.compose.yml --env-file .env up -d database
sleep 5
docker compose -f docker/docker.compose.yml --env-file .env exec -T database \
  psql -U $DB_USER -d $DB_NAME -f /dumps/proyecto_recolecta-20260127171638.sql

# 3. Validar post-restore
docker compose -f docker/docker.compose.yml --env-file .env exec -T database \
  psql -U $DB_USER -d $DB_NAME -c "SELECT COUNT(*) FROM schema_version;"

# 4. Resubir todos los servicios
docker compose -f docker/docker.compose.yml --env-file .env up -d
```

### Rollback si algo falla

Si restore falló y la BD quedó en estado inconsistente:

```bash
# 1. Detener servicios
docker compose -f docker/docker.compose.yml down -v

# 2. Limpiar volúmenes
docker volume rm docker_postgres_data

# 3. Levantar de nuevo (volverá a ejecutar init scripts y seed)
docker compose -f docker/docker.compose.yml --env-file .env up -d

# 4. Esperar a que termine init
sleep 15

# 5. Reintentar restore si lo necesitas
docker compose -f docker/docker.compose.yml --env-file .env exec -T database \
  psql -U $DB_USER -d $DB_NAME -f /dumps/proyecto_recolecta-20260127171638.sql
```

---

## 🌱 Seed (Datos Iniciales)

### Automático en primer init

Cuando haces `docker compose up` la **primera vez**:

1. `00-init-database.sh` crea schema y registra `schema_version = 1.0.0`
2. `seed-if-empty.sh` verifica que tabla `rol` está vacía y ejecuta seed
3. Seed inserta 3 roles (admin, operador, conductor), 2 colonias, 1 usuario admin
4. Registra `schema_version = 1.0.1`

### Manual re-seed (si eliminaste datos)

```bash
# Usar script de seeding manual
docker compose -f docker/docker.compose.yml --env-file .env exec database \
  /usr/local/bin/init_seeding.sh
```

**Garantías:**
- Idempotente (usa `ON CONFLICT DO NOTHING`)
- Safe para ejecutar múltiples veces
- No duplica datos

### Verificar seed ejecutado

```bash
# Ver versiones aplicadas
docker compose -f docker/docker.compose.yml --env-file .env exec -T database \
  psql -U $DB_USER -d $DB_NAME -c "SELECT version, applied_at FROM schema_version ORDER BY version_id;"

# Ver datos de roles
docker compose -f docker/docker.compose.yml --env-file .env exec -T database \
  psql -U $DB_USER -d $DB_NAME -c "SELECT role_id, nombre FROM rol;"
```

---

## 🗂️ Rotación de Backups (Retención Local)

### Script de rotación simple

Crear archivo `/usr/local/bin/rotate-dumps.sh` (en el host):

```bash
#!/bin/sh
D="/var/lib/recolecta/dumps"  # Ajusta ruta según DUMPS_HOST_PATH
KEEP=7                         # Guardar últimos 7 dumps

cd "$D" || exit 0
# Listar archivos ordenados por fecha, eliminar los más antiguos
ls -1t *.sql 2>/dev/null | tail -n +$((KEEP+1)) | xargs -r rm --
echo "Dumps kept: $(ls -1 *.sql 2>/dev/null | wc -l)"
```

Hacer ejecutable:
```bash
chmod 750 /usr/local/bin/rotate-dumps.sh
```

### Ejecutar manualmente

```bash
/usr/local/bin/rotate-dumps.sh
```

### Programar cron (ejecución automática diaria)

Editar crontab:
```bash
crontab -e
```

Añadir línea (ejecuta dump + rotación cada día a las 02:00 AM):
```cron
0 2 * * * /usr/local/bin/init_dump.sh && /usr/local/bin/rotate-dumps.sh
```

O si prefieres una rotación separada (cada medianoche):
```cron
0 2 * * * docker compose -f /path/to/docker.compose.yml --env-file /path/to/.env exec -T database /usr/local/bin/init_dump.sh
0 3 * * * /usr/local/bin/rotate-dumps.sh
```

---

## 🆘 Troubleshooting

### ❌ Dump falla con "permission denied"

```bash
# Verificar ownership de carpeta dumps
ls -ld docker/postgresql/dumps/

# Ajustar permisos (cambia UID según necesites)
sudo chown 999:999 docker/postgresql/dumps/
sudo chmod 750 docker/postgresql/dumps/
```

Nota: `999` es UID típico de postgres en Alpine. Verifica con:
```bash
docker run --rm postgres:16-alpine id -u postgres
```

### ❌ Restore da error de constraints

```
ERROR: insert or update on table "X" violates foreign key constraint
```

Soluciones:
1. Restaurar en BD nueva (vacía) primero para validar
2. Verificar que todas las tablas existen en orden correcto
3. Si la BD tiene datos parciales: usar `docker compose down -v` y restart limpio

### ❌ Seed no se ejecuta en fresh init

Verificar logs:
```bash
docker compose -f docker/docker.compose.yml logs database | grep -i seed
```

Si no aparece "SEED" en logs:
- Probablemente la BD fue pre-creada por entrypoint (comportamiento esperado)
- Ejecutar manual: `/usr/local/bin/init_seeding.sh`

### ❌ Schema versioning conflictos

Si `schema_version` ya tiene registros y quieres resetear:

```bash
docker compose -f docker/docker.compose.yml --env-file .env exec -T database \
  psql -U $DB_USER -d $DB_NAME -c "DELETE FROM schema_version;"

# Luego re-seed manualmente
docker compose -f docker/docker.compose.yml --env-file .env exec database \
  /usr/local/bin/init_seeding.sh
```

---

## ✅ Acceptance Tests (Verificación Post-Operación)

### Checklist post-dump

- [ ] Archivo dump existe: `ls -l docker/postgresql/dumps/proyecto_recolecta-*.sql`
- [ ] Tamaño > 50 KB: `wc -c docker/postgresql/dumps/proyecto_recolecta-*.sql`
- [ ] Contiene tablas: `grep -c "CREATE TABLE" docker/postgresql/dumps/proyecto_recolecta-*.sql`

### Checklist post-restore

- [ ] DB conecta: `psql -U <user> -d <name> -c "SELECT 1;"`
- [ ] Tablas creadas: `psql -U <user> -d <name> -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public';"`
- [ ] Datos presentes: `psql -U <user> -d <name> -c "SELECT COUNT(*) FROM rol;"`
- [ ] Schema version OK: `psql -U <user> -d <name> -c "SELECT * FROM schema_version;"`

### Checklist post-seed

- [ ] Versión 1.0.1 registrada: `psql -U <user> -d <name> -c "SELECT version FROM schema_version WHERE version='1.0.1';"`
- [ ] Roles existen: `psql -U <user> -d <name> -c "SELECT COUNT(*) FROM rol;"` (debería ser 3)
- [ ] Datos no duplicados (re-seed): ejecutar seed 2 veces y validar COUNT igual

---

## 🔮 Futuro: Migration a Enterprise

Cuando escales a producción/cloud:

1. **Flyway/Liquibase:** versionar migrations como código
   - Mover `01-init-schema` → `V1.0.0__initial_schema.sql`
   - Mover `01-seed` → `V1.0.1__seed_data.sql`
   - Flyway usará `schema_version` como baseline

2. **S3/GCS:** backups cifrados y persistentes
   - Extender `init_dump.sh` para `aws s3 cp` después
   - Implementar restore desde S3

3. **CI/CD:** automated dumps y restore testing
   - GitHub Actions job para dump diario
   - Restored testing en CI

4. **Monitoreo:** alertas y métricas de backup
   - Cloudwatch: tamaño de dump, duración
   - Alertas si dump falla

---

## 📚 Referencias

- Scripts en: `docker/postgresql/init-scripts/`
  - `init_dump.sh` — crea dump
  - `init_seeding.sh` — re-seed manual
  - `00-init-database.sh` — schema init
  - `seed-if-empty.sh` — seed automático
- Schema definition: `gin-backend/db_script.sql`
- Seed data: `docker/postgresql/seeds/seed.sql`

---

**Última actualización:** 27 de Enero de 2026
