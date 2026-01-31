# 🗑️ Recolecta Web — Arquitectura y Orquestación

> Meta-repo de **orquestación y arquitectura** que integra y coordina los submódulos del proyecto

**Versión:** `0.5.0-alpha` | **Estado:** En desarrollo 🚧

---

## 📋 Qué es este repositorio

**Recolecta Web** es una plataforma web para gestión y seguimiento de rutas de recolección de residuos. Este repositorio es el **meta-repo de arquitectura** que:

- ✅ **Orquesta servicios** con Docker Compose (PostgreSQL, Redis, Nginx)
- ✅ **Integra submódulos** ([frontend/](frontend/), [gin-backend/](gin-backend/))
- ✅ **Centraliza configuración** (.env, variables compartidas)
- ✅ **Documenta setup** y operaciones locales

**No incluye:**
- ❌ Código del frontend (ver [frontend/README.md](frontend/README.md))
- ❌ Código del backend (ver [gin-backend/README.md](gin-backend/README.md))
- ❌ Testing de apps (documentado en sus repos)

### 🏗️ Stack Tecnológico

| Componente | Tecnología |
|-----------|-----------|
| **Frontend** | React + TypeScript + Vite |
| **Backend** | Go + Gin |
| **Base de Datos** | PostgreSQL 16 |
| **Cache** | Redis 7.2 |
| **Infraestructura** | Docker Compose + Nginx |

---

## 🚀 Quick Start (3 pasos)

#### 1️⃣ Clonar con submódulos

```bash
git clone --recurse-submodules https://github.com/RodrigoMijangos/recolecta_web.git
cd recolecta_web
```

#### 2️⃣ Configurar variables de entorno

```bash
cp .env.example .env
# Edita .env con tus credenciales (ver docs/01-setup-local.md para detalles)
```

#### 3️⃣ Levantar servicios

```bash
docker compose -f docker/docker.compose.yml --env-file .env up -d
```

✅ **Listo!** Abre http://localhost — deberías ver la página placeholder.

---

## � Documentación Central

Esta es tu guía principal. Busca información aquí primero según tu necesidad:

### 🔧 Configuración e Instalación
- **[01-setup-local.md](docs/01-setup-local.md)** — Setup completo de desarrollo local, Redis, troubleshooting

### 📊 Bases de Datos
- **[02-database-operations.md](docs/02-database-operations.md)** — Operaciones PostgreSQL y migraciones
- **[03-redis-operations.md](docs/03-redis-operations.md)** — Casos de uso reales y benchmarks
- **[04-redis-schema.md](docs/04-redis-schema.md)** — Estructura completa de datos en Redis (10 secciones)
- **[05-data-lifecycle.md](docs/05-data-lifecycle.md)** — Flujos de datos y operaciones Redis (7 flujos completos)


### 🧪 Testing y Validación
- **[testing/postgres-tests.md](docs/testing/postgres-tests.md)** — Suite de tests PostgreSQL
- **[testing/redis-tests.md](docs/testing/redis-tests.md)** — Healthchecks de Redis

### 🚀 Desarrollo
- **[frontend/README.md](frontend/README.md)** — Frontend (React + TypeScript + Vite)
- **[gin-backend/README.md](gin-backend/README.md)** — Backend (Go + Gin)

### 📋 Cambios y Versiones
- **[CHANGELOG.md](CHANGELOG.md)** — Historial de cambios por versión

---

## 🎯 Datos de Prueba — Redis MVP

**¿Necesitas cargar datos de prueba?** Sigue la guía completa en [docs/01-setup-local.md](docs/01-setup-local.md#-redis---datos-de-prueba-generación-y-carga)

**Quick reference:**
```bash
# 1. Generar 200 usuarios + 25 puntos en Suchiapa, Chiapas
cd docker/redis/init-scripts/
bash generate-seed-data.sh

# 2. Iniciar Redis
docker compose -f ../../docker.compose.yml up -d redis

# 3. Cargar en Redis
bash load-redis.sh redis 6379 redis_dev_pass_456
```

✅ **Resultado:** 200 usuarios distribuidos geográficamente con búsquedas geoespaciales O(log N)

📖 **Documentación técnica:**
- [docs/01-setup-local.md](docs/01-setup-local.md#-redis---datos-de-prueba-generación-y-carga) — Guía completa de generación y carga
- [docs/04-redis-schema.md](docs/04-redis-schema.md) — Estructura de datos
- [docs/05-data-lifecycle.md](docs/05-data-lifecycle.md) — Flujos de datos
- [docs/03-redis-operations.md](docs/03-redis-operations.md) — Casos de uso reales

---

## 🐛 Troubleshooting Rápido

**¿Puerto en uso?**
```bash
# Cambiar en .env
DB_PORT=5433
REDIS_PORT=6380
NGINX_PORT=8080
```

**¿Variables no se cargan?**
```bash
# Recrear servicios con .env explícito
docker compose -f docker/docker.compose.yml --env-file .env up -d --force-recreate
```

**¿Ver logs?**
```bash
docker compose -f docker/docker.compose.yml --env-file .env logs -f
```

**¿Validar salud de servicios?**
```bash
# Suite completa de tests PostgreSQL (healthcheck + validación + persistencia)
bash scripts/tests/postgres/run_all.sh

# Solo healthcheck rápido de PostgreSQL
bash scripts/tests/postgres/test_healthcheck.sh

# Healthcheck de Redis
bash scripts/tests/redis/run_redis_healthchecks.sh
```

📖 **Documentación de tests:** [docs/testing/postgres-tests.md](docs/testing/postgres-tests.md) (PostgreSQL) | [docs/testing/redis-tests.md](docs/testing/redis-tests.md) (Redis)  
📖 **Troubleshooting completo:** [docs/01-setup-local.md#troubleshooting](docs/01-setup-local.md#troubleshooting)

---

## 🔄 Submódulos Git

El proyecto integra frontend y backend como submódulos. Para clonar correctamente:

```bash
# Opción 1: Clonar con submódulos desde el inicio
git clone --recurse-submodules <url>

# Opción 2: Clonar e inicializar después
git clone <url>
cd recolecta_web
git submodule update --init --recursive

# Actualizar submódulos a última versión
git submodule update --remote --merge
```

---

## 🤝 Contribución

### Workflow

1. Crea rama desde `main`: `git checkout -b feature/descripcion`
2. Haz cambios y actualiza [CHANGELOG.md](CHANGELOG.md)
3. Commit: `git commit -am "feat: descripcion"`
4. Abre Pull Request
5. Espera revisión

### Convención de Commits

```
feat:     Nueva funcionalidad
fix:      Corrección de bug
chore:    Cambios de configuración
docs:     Cambios en documentación
refactor: Reorganización de código
test:     Cambios en tests
```

---

## 📞 Soporte

- 📧 Email: support@recolecta.local
- 💬 Discord: [Tu servidor]
- 🐛 Issues: [GitHub Issues](https://github.com/RodrigoMijangos/recolecta_web/issues)

---

## 📄 Licencia

Este proyecto está bajo licencia **MIT**. Ver [LICENSE](LICENSE) para más detalles.

---

## 👥 Equipo

- **Product Owner:** [Nombre]
- **Tech Lead:** [Nombre]
- **Desarrolladores:** [Nombres]

---

**Última actualización:** 30 de Enero de 2026 | **Versión:** 0.5.0-alpha
