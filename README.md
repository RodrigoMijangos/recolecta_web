# Recolecta Web

Sistema de gestión integral para recolección de residuos urbanos que permite administrar y monitorear flotas de camiones recolectores, rutas, y todo el proceso de recolección.

---

## 📚 Documentación del Proyecto

→ **[VER DOCUMENTACIÓN COMPLETA](./docs/README.md)** ← EMPEZAR AQUÍ

Aquí encontrarás:
- 🚀 Guía completa de workflow y contribuciones
- 📋 Templates de PRs e Issues
- 🤖 Automatización del GitHub Project
- 🎯 Sistema de trazabilidad de trabajo
- ⚡ Script PowerShell para automatización

---

## 🏗️ Arquitectura

- **Backend**: Go + Gin Framework (Arquitectura Hexagonal)
- **Base de Datos**: PostgreSQL 16
- **Cache**: Redis 7.2
- **Proxy**: Nginx

## 🚀 Inicio Rápido

### 1. Prerrequisitos

- Docker (v20.10+)
- Docker Compose (v2.0+)

### 2. Configurar Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto:

```env
# PostgreSQL
DB_NAME=recolecta_db
DB_USER=recolecta_user
DB_PASSWORD=tu_password_seguro
```

### 3. Levantar Servicios

```bash
# Navegar a la carpeta docker
cd docker

# Levantar todos los servicios
docker compose up -d

# Ver el estado
docker compose ps

# Ver logs
docker compose logs -f
```

### 4. Verificar Servicios

Los servicios estarán disponibles en:

- **Frontend**: http://localhost
- **Backend API**: http://localhost/api
- **PostgreSQL**: `postgres_db:5432` (red interna)
- **Redis**: `redis_cache:6379` (red interna)

## 📦 Servicios Docker

| Servicio | Contenedor | Puerto | Descripción |
|----------|-----------|--------|-------------|
| PostgreSQL | `postgres_db` | - | Base de datos principal |
| Redis | `redis_cache` | - | Sistema de cache |
| Backend | `go_backend` | 8080 | API REST en Go |
| Nginx | `nginx_proxy` | 80, 443 | Proxy y servidor web |

## 🛠️ Comandos Útiles

```bash
# Detener servicios
docker compose stop

# Reiniciar servicios
docker compose restart

# Ver logs de un servicio específico
docker compose logs backend

# Eliminar servicios y volúmenes (⚠️ BORRA DATOS)
docker compose down -v

# Reconstruir servicios
docker compose up -d --build
```

## 🗄️ Acceso a Base de Datos

```bash
# Conectar a PostgreSQL
docker exec -it postgres_db psql -U recolecta_user -d recolecta_db

# Conectar a Redis
docker exec -it redis_cache redis-cli
```

## 📝 Desarrollo

### Frontend

```bash
cd frontend
npm install
npm run dev
```

### Backend

```bash
cd gin-backend
go mod download
go run main.go
```

## 🔧 Configuración Adicional

- **Nginx**: Editar `docker/nginx/nginx.conf`
- **Frontend build**: `cd frontend && npm run build`
- **Docker Compose**: `docker/docker.compose.yml`

## 🐛 Troubleshooting

### Ver logs de todos los servicios
```bash
docker compose logs
```

### Verificar estado de contenedores
```bash
docker compose ps
```

### Reiniciar un servicio específico
```bash
docker compose restart backend
```

## 📄 Estructura del Proyecto

```
recolecta_web/
├── docker/              # Configuración Docker
├── frontend/            # Aplicación React
├── gin-backend/         # API en Go
├── map-navigator/       # Navegación de mapas
└── README.md           # Este archivo
```

---

**Desarrollado para gestión eficiente de recolección de residuos urbanos**
