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

## 📖 Documentación Específica

Para documentación completa según tu rol:

| Rol / Caso de Uso | Enlace |
|------------------|--------|
| 👤 **Usuarios** | [frontend/README.md](frontend/README.md) |
| 👨‍💻 **Desarrolladores (Frontend)** | [frontend/README.md](frontend/README.md) |
| 👨‍💻 **Desarrolladores (Backend)** | [gin-backend/README.md](gin-backend/README.md) |
| 🔧 **DevOps / Setup Local** | [docs/01-setup-local.md](docs/01-setup-local.md) |
| 🗄️ **Database Operations** | [docs/02-database-operations.md](docs/02-database-operations.md) |
| 🧪 **Testing - PostgreSQL** | [docs/testing/postgres-tests.md](docs/testing/postgres-tests.md) |
| 🧪 **Testing - Redis** | [docs/testing/redis-tests.md](docs/testing/redis-tests.md) |

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

**Última actualización:** 20 de Enero de 2026 | **Versión:** 0.1.0-alpha
