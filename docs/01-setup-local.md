# 🐳 Setup Local - Docker y Orquestación

> Guía para levantar el ambiente local con Docker Compose

## Qué hay en este repo

Este repositorio es un **meta-repo de orquestación y arquitectura** que integra:

- **docker/** — Docker Compose, configuración de servicios
- **docker/postgresql/** — Scripts de inicialización, seed, dump
- **.env** — Configuración centralizada de variables de entorno
- **.gitattributes** — Control de line endings (LF)
- Submódulos Git:
  - **[frontend/](../frontend/)** — React + TypeScript (su propio README)
  - **[gin-backend/](../gin-backend/)** — Go + Gin API (su propio README)

## Qué NO está aquí

- Código del frontend (ver [frontend/README.md](../frontend/README.md))
- Código del backend (ver [gin-backend/README.md](../gin-backend/README.md))
- Testing de frontend/backend (documentado en sus repos)

---

## 📋 Requisitos Previos

- **Docker** 20.10+
- **Docker Compose** 2.0+
- **Git** 2.30+

Verifica:
```bash
docker --version
docker-compose --version
git --version
```

---

## 🚀 Setup Local (3 pasos)

### 1. Clonar con submódulos

```bash
git clone --recurse-submodules https://github.com/RodrigoMijangos/recolecta_web.git
cd recolecta_web
```

Si ya clonaste sin submódulos:
```bash
git submodule update --init --recursive
```

### 2. Configurar variables de entorno

Copia el archivo de ejemplo:
```bash
cp .env.example .env
```

Edita `.env` con tus valores. Ejemplo mínimo:
```env
DB_USER=recolecta
DB_PASSWORD=tu_contraseña_segura
DB_NAME=proyecto_recolecta
REDIS_PASSWORD=tu_redis_password
ENVIRONMENT=development
```

**⚠️ Importante:**
- `.env` debe tener permisos restrictivos (no hacer commit)
- Usa `.env.example` como referencia
- En producción, usa gestión de secretos

### 3. Levantar servicios

```bash
docker compose -f docker/docker.compose.yml --env-file .env up -d
```

Ver logs:
```bash
docker compose -f docker/docker.compose.yml logs -f
```

---

## ✅ Verificación

Después de 10–15 segundos, verifica que todo funciona:

### Acceso web
```bash
curl http://localhost
# Debería devolver HTML (página placeholder)

curl http://localhost/health
# Debería devolver "healthy"
```

### PostgreSQL
```bash
# Reemplaza <usuario> y <nombre_db> con los valores de tu .env
docker compose -f docker/docker.compose.yml exec -T database \
  psql -U <usuario> -d <nombre_db> -c "SELECT version();"
```

### Redis
```bash
# Reemplaza <password> con tu REDIS_PASSWORD
docker compose -f docker/docker.compose.yml exec redis \
  redis-cli -a <password> PING
# Debería responder: PONG
```

### Contenedores corriendo
```bash
docker compose -f docker/docker.compose.yml ps
# Deberías ver 3 contenedores "Up"
```

---

## 🔧 Servicios

### PostgreSQL (5432)
- **Imagen:** `postgres:16-alpine`
- **Container:** `postgres_db`
- **Volumen:** `postgres_data` (persistente)
- **Credenciales:** desde `.env` (`DB_USER`, `DB_PASSWORD`, `DB_NAME`)

Inicialización automática:
- `docker/postgresql/init-scripts/init-database.sh` — crea schema
- `docker/postgresql/init-scripts/seed-if-empty.sh` — carga datos iniciales
- Schema version table: `schema_version` (historial de cambios)

### Redis (6379)
- **Imagen:** `redis:7.2-alpine`
- **Container:** `redis_cache`
- **Volumen:** `redis_data` (persistente, AOF enabled)
- **Password:** desde `.env` (`REDIS_PASSWORD`)

### Nginx (80)
- **Imagen:** Build custom (`Dockerfile.nginx`)
- **Container:** `nginx_proxy`
- **Puertos:** 80 (HTTP), 443 (futuro HTTPS)
- **Contenido:** Frontend placeholder en `docker/frontend-placeholder/`

---

## 📝 Variables de Entorno

### PostgreSQL
```env
DB_HOST=db                          # Nombre del contenedor (en red Docker)
DB_PORT=5432                        # Puerto
DB_USER=recolecta                   # Usuario BD
DB_PASSWORD=tu_contraseña_segura    # Contraseña
DB_NAME=proyecto_recolecta          # Nombre BD
```

### Redis
```env
REDIS_HOST=redis                    # Nombre del contenedor
REDIS_PORT=6379                     # Puerto
REDIS_PASSWORD=tu_redis_password    # Password
```

### Aplicación
```env
ENVIRONMENT=development             # development | production
```

---

## 🔄 Comandos Comunes

### Iniciar/detener
```bash
# Iniciar
docker compose -f docker/docker.compose.yml --env-file .env up -d

# Ver estado
docker compose -f docker/docker.compose.yml ps

# Detener (sin eliminar datos)
docker compose -f docker/docker.compose.yml down

# Detener y eliminar TODOS los datos
docker compose -f docker/docker.compose.yml down -v
```

### Logs
```bash
# Todos los servicios
docker compose -f docker/docker.compose.yml logs -f

# Solo PostgreSQL
docker compose -f docker/docker.compose.yml logs -f database

# Últimas 50 líneas
docker compose -f docker/docker.compose.yml logs --tail=50 database
```

### Acceso a contenedores
```bash
# Shell en PostgreSQL
docker compose -f docker/docker.compose.yml exec database sh

# psql en PostgreSQL
docker compose -f docker/docker.compose.yml exec -T database \
  psql -U <usuario> -d <nombre_db>

# Redis CLI
docker compose -f docker/docker.compose.yml exec redis \
  redis-cli -a <password>
```

### Limpieza
```bash
# Limpiar datos detallada (solo espacios sin usar)
docker system prune

# Limpieza nuclear (⚠️ BORRA TODO)
docker compose -f docker/docker.compose.yml down -v
docker system prune -af --volumes
```

---

## 🐛 Troubleshooting

### ❌ Puerto ya en uso (5432, 6379, 80)

```bash
# Encontrar qué proceso usa el puerto
netstat -ano | findstr :5432

# Cambiar puerto en .env
DB_PORT=5433
REDIS_PORT=6380
```

Luego reinicia:
```bash
docker compose -f docker/docker.compose.yml down
docker compose -f docker/docker.compose.yml --env-file .env up -d
```

### ❌ No se puede conectar a PostgreSQL

```bash
# 1. Verificar que el contenedor está corriendo
docker compose -f docker/docker.compose.yml ps | findstr database

# 2. Verificar logs
docker compose -f docker/docker.compose.yml logs database

# 3. Probar conexión desde dentro del contenedor (usa valores de .env)
docker compose -f docker/docker.compose.yml exec -T database \
  psql -U <usuario> -d <nombre_db> -c "SELECT 1;"
```

### ❌ Variables de entorno no se cargan

```bash
# Verificar que .env existe y tiene valores
Test-Path .env
Get-Content .env

# Validar que Docker Compose lee el .env
docker compose -f docker/docker.compose.yml config | grep DB_

# Recrear con .env explícito
docker compose -f docker/docker.compose.yml down -v
docker compose -f docker/docker.compose.yml --env-file .env up -d
```

### ❌ Volumen con datos viejos

PostgreSQL solo lee variables de entorno en la **primera inicialización**. Si cambiaste credenciales:

```bash
# Eliminar volumen (⚠️ BORRA DATOS)
docker compose -f docker/docker.compose.yml down -v

# Limpiar completamente
docker system prune -af --volumes

# Levantar de nuevo
docker compose -f docker/docker.compose.yml --env-file .env up -d
```

---

## 📚 Documentación Relacionada

- **BD Operations:** [02-database-operations.md](02-database-operations.md) — dump, restore, seed
- **Frontend:** [../frontend/README.md](../frontend/README.md) — React development
- **Backend:** [../gin-backend/README.md](../gin-backend/README.md) — Go API development
- **Changelog:** [../CHANGELOG.md](../CHANGELOG.md) — historial de cambios

---

**Última actualización:** 27 de Enero de 2026
