# 🗑️ Recolecta Web

> Sistema integral de gestión y seguimiento de rutas de recolección de residuos

**Versión:** `0.1.0-alpha` | **Estado:** En desarrollo 🚧

---

## 📋 Descripción del Proyecto

**Recolecta** es una plataforma web que permite:

- 📍 **Gestión de Rutas** - Planificación y asignación de rutas de recolección
- 🚗 **Seguimiento de Camiones** - Monitoreo en tiempo real de vehículos
- 📊 **Dashboard Inteligente** - Visualización de datos y reportes
- 🔔 **Sistema de Alertas** - Notificaciones de anomalías y mantenimiento
- 📈 **Análisis de Datos** - Estadísticas y reportes de eficiencia

### 🏗️ Stack Tecnológico

| Componente | Tecnología | Descripción |
|-----------|-----------|-----------|
| **Frontend** | React + TypeScript + Vite | Interfaz moderna y rápida |
| **Backend** | Go + Gin | API REST de alto rendimiento |
| **Infraestructura** | Docker + Docker Compose | Containerización y orquestación |
| **Web Server** | Nginx | Reverse proxy y servidor estático |

---

## 🚀 Inicio Rápido (Quick Start)

### 📋 Requisitos Previos

- **Docker** 20.10+
- **Docker Compose** 2.0+
- **Git** 2.30+

Verifica que tengas todo instalado:

```bash
docker --version
docker-compose --version
git --version
```

### ⚡ Ejecutar en Desarrollo (3 pasos)

#### 1️⃣ Clonar el repositorio con submódulos

```bash
git clone https://github.com/tu-usuario/recolecta_web.git
cd recolecta_web

# Inicializar submódulos (frontend y backend)
git submodule init
git submodule update
```

#### 2️⃣ Configurar variables de entorno

Copia el archivo de ejemplo y edítalo con tus valores:

```bash
cp .env.example .env
```

**⚠️ IMPORTANTE:** En todos los documentos verás placeholders como `<usuario>`, `<tu_contraseña_segura>`, etc. Estos deben ser **reemplazados** con los valores que definas en tu archivo `.env`.

**Variables principales:**

```env
# Backend
API_PORT=8080
DATABASE_URL=postgresql://<usuario>:<contraseña>@db:5432/<nombre_db>

# Frontend
VITE_API_URL=http://localhost:8080

# PostgreSQL
DB_USER=<tu_usuario>
DB_PASSWORD=<tu_contraseña_segura>
DB_NAME=<nombre_base_datos>

# Redis
REDIS_PASSWORD=<tu_contraseña_redis_segura>

# Docker
ENVIRONMENT=development
```

#### 3️⃣ Iniciar los servicios

```bash
# Levantar servicios (especifica .env explícitamente)
docker compose -f docker/docker.compose.yml --env-file .env up -d

# Ver logs en tiempo real
docker compose -f docker/docker.compose.yml logs -f

# Ver logs de un servicio específico
docker compose -f docker/docker.compose.yml logs -f database
```

**💡 Nota:** Siempre usa `--env-file .env` para garantizar que las variables se carguen correctamente.

**✅ Listo!** Tu aplicación estará disponible en:

- 🌐 **Frontend:** http://localhost (Nginx sirviendo placeholder)
- 🗄️ **PostgreSQL:** localhost:5432
- 🔴 **Redis:** localhost:6379
- 🔌 **Backend API:** Por configurar

---

## 📦 Comandos Docker Útiles

**⚠️ IMPORTANTE:** 
- Ejecuta todos los comandos desde la **raíz del proyecto**
- Usa siempre `--env-file .env` para garantizar que las variables se carguen correctamente

### 🚀 Inicio y Detención

```bash
# Iniciar servicios
docker compose -f docker/docker.compose.yml --env-file .env up -d

# Iniciar sin detach (ver logs en vivo)
docker compose -f docker/docker.compose.yml --env-file .env up

# Detener servicios
docker compose -f docker/docker.compose.yml down

# Detener y eliminar volúmenes (⚠️ BORRA DATOS)
docker compose -f docker/docker.compose.yml down -v

# Recrear contenedores (cuando cambies docker-compose.yml)
docker compose -f docker/docker.compose.yml --env-file .env up -d --force-recreate

# Rebuild imágenes (cuando cambies Dockerfiles)
docker compose -f docker/docker.compose.yml build --no-cache
docker compose -f docker/docker.compose.yml --env-file .env up -d
```

### 📊 Monitoreo

```bash
# Ver estado de servicios
docker compose -f docker/docker.compose.yml ps

# Ver logs en tiempo real
docker compose -f docker/docker.compose.yml logs -f

# Ver logs de un servicio específico
docker compose -f docker/docker.compose.yml logs -f database
docker compose -f docker/docker.compose.yml logs -f redis
docker compose -f docker/docker.compose.yml logs -f proxy

# Ver últimas N líneas de logs
docker compose -f docker/docker.compose.yml logs --tail=50 database

# Ver estadísticas de recursos
docker stats
```

### 🔍 Debugging y Acceso

```bash
# Ejecutar comando en contenedor (shell interactivo)
docker compose -f docker/docker.compose.yml exec database sh
docker compose -f docker/docker.compose.yml exec redis sh
docker compose -f docker/docker.compose.yml exec proxy sh

# Conectar a PostgreSQL (usa tus valores del .env)
docker compose -f docker/docker.compose.yml exec database psql -U <usuario> -d <nombre_db>

# Ejemplo: listar usuarios
docker compose -f docker/docker.compose.yml exec database psql -U <usuario> -d <nombre_db> -c "\du"

# Ejemplo: listar bases de datos
docker compose -f docker/docker.compose.yml exec database psql -U <usuario> -d <nombre_db> -c "\l"

# Conectar a Redis CLI (usa tu REDIS_PASSWORD del .env)
docker compose -f docker/docker.compose.yml exec redis redis-cli -a <tu_contraseña_redis>

# Ejemplo: ping a Redis
docker compose -f docker/docker.compose.yml exec redis redis-cli -a <tu_contraseña_redis> PING

# Verificar configuración de Nginx
docker compose -f docker/docker.compose.yml exec proxy nginx -t
```

### 🔧 Gestión de Datos

```bash
# Backup de PostgreSQL (usa tus valores del .env)
docker compose -f docker/docker.compose.yml exec database pg_dump -U <usuario> <nombre_db> > backup_$(date +%Y%m%d).sql

# Restaurar PostgreSQL (PowerShell)
Get-Content backup.sql | docker compose -f docker/docker.compose.yml exec -T database psql -U <usuario> -d <nombre_db>

# Limpiar datos de Redis (usa tu REDIS_PASSWORD)
docker compose -f docker/docker.compose.yml exec redis redis-cli -a <tu_contraseña_redis> FLUSHALL

# Ver volúmenes
docker volume ls

# Eliminar volumen específico (⚠️ BORRA DATOS)
docker volume rm docker_postgres_data
```

### 🔄 Variables de Entorno

```bash
# Ver variables cargadas en contenedor
docker compose -f docker/docker.compose.yml exec database env | findstr POSTGRES
docker compose -f docker/docker.compose.yml exec redis env | findstr REDIS

# Validar archivo .env antes de levantar
Get-Content .env | Select-String -Pattern "PASSWORD|USER|PORT"

# Verificar qué archivo compose está usando
docker compose -f docker/docker.compose.yml config
```

### 🧹 Limpieza

```bash
# Limpieza básica (contenedores detenidos, redes, caché)
docker system prune -f

# Eliminar imágenes no usadas
docker image prune -a

# Eliminar volúmenes no usados
docker volume prune

# 🔥 LIMPIEZA NUCLEAR (borra TODO: contenedores, volúmenes, imágenes, caché)
docker compose -f docker/docker.compose.yml down -v --remove-orphans
docker system prune -af --volumes

# 🔄 RESET COMPLETO (limpieza + rebuild desde cero)
docker compose -f docker/docker.compose.yml down -v --remove-orphans; docker system prune -af --volumes; docker compose -f docker/docker.compose.yml --env-file .env up -d --build
```

**⚠️ Notas importantes:**
- `-v` elimina volúmenes (BORRA datos de PostgreSQL y Redis)
- `-a` elimina imágenes (las descargará de nuevo)
- `--volumes` en prune elimina volúmenes huérfanos
- `--remove-orphans` elimina contenedores de versiones anteriores del compose
- Usa limpieza nuclear cuando cambies versiones de imágenes o tengas problemas persistentes

### 🌐 Verificación de Servicios

```bash
# Verificar PostgreSQL desde el host
# (Windows PowerShell - requiere psql instalado)
# Reemplaza valores con los de tu .env
$env:PGPASSWORD="<tu_contraseña>"; psql -h localhost -p 5432 -U <usuario> -d <nombre_db> -c "SELECT version();"

# Verificar Nginx
curl http://localhost
curl http://localhost/health

# Verificar conectividad entre contenedores
docker compose -f docker/docker.compose.yml exec proxy ping database
docker compose -f docker/docker.compose.yml exec proxy ping redis
```

---

## 💡 Consejos para usar Docker Compose

### 🎯 Sobre `--env-file .env`

- **¿Es necesario?** Técnicamente Docker Compose busca `.env` automáticamente en el directorio actual, pero es **mejor práctica** especificarlo explícitamente para:
  - Claridad en qué archivo se está usando
  - Evitar confusiones si hay múltiples archivos `.env`
  - Facilitar scripts automatizados

- **Alternativas:**
  ```bash
  # Opción 1: Dejar que Docker Compose lo busque automáticamente
  docker compose -f docker/docker.compose.yml up -d
  
  # Opción 2: Especificar explícitamente (recomendado)
  docker compose -f docker/docker.compose.yml --env-file .env up -d
  
  # Opción 3: Múltiples archivos .env
  docker compose -f docker/docker.compose.yml --env-file .env --env-file .env.local up -d
  ```

### ⚡ Atajos útiles

```bash
# Alias para PowerShell (agregar a $PROFILE)
function dcu { docker compose -f docker/docker.compose.yml --env-file .env up -d }
function dcd { docker compose -f docker/docker.compose.yml down }
function dcl { docker compose -f docker/docker.compose.yml logs -f }
function dcp { docker compose -f docker/docker.compose.yml ps }

# Usar:
dcu      # levanta servicios
dcd      # detiene servicios
dcl      # ver logs
dcp      # ver estado
```

### 🔐 Seguridad

- ⚠️ **NUNCA** hagas commit del archivo `.env` con credenciales reales
- ✅ Usa `.env.example` como plantilla
- ✅ En producción, usa Docker secrets o variables de entorno del sistema
- ✅ Cambia las contraseñas por defecto antes de producción

---

## 📦 Estructura de Docker

```
docker/
├── docker.compose.yml          # Configuración principal
├── docker.compose.dev.yml      # Configuración de desarrollo (WIP)
├── Dockerfile.nginx            # Imagen personalizada de Nginx
├── frontend-placeholder/       # HTML temporal mientras se configura frontend
│   └── index.html
└── nginx/
    └── nginx.conf/             # Configuraciones adicionales (futuro)
```

---

## 📁 Estructura del Proyecto

```
recolecta_web/
├── frontend/                    # React + TypeScript (submódulo)
│   ├── src/
│   │   ├── components/         # Componentes reutilizables
│   │   ├── Pages/              # Páginas principales
│   │   ├── Router/             # Configuración de rutas
│   │   └── main.tsx
│   ├── package.json
│   └── vite.config.ts
│
├── gin-backend/                 # Go + Gin (submódulo)
│   ├── src/
│   │   ├── alerta_mantenimiento/
│   │   ├── anomalia/
│   │   ├── camion/
│   │   ├── ruta/
│   │   └── ... [otros módulos]
│   ├── main.go
│   └── go.mod
│
├── docker/                      # Configuración Docker
│   ├── docker.compose.dev.yml  # Desarrollo
│   ├── docker.compose.yml      # Producción
│   ├── Dockerfile.nginx        # Imagen Nginx
│   └── nginx/
│       └── nginx.conf/         # Configuración Nginx
│
├── map-navigator/              # Módulo de mapas
├── CHANGELOG.md               # Registro de cambios
├── README.md                  # Este archivo
└── .env.example              # Variables de entorno ejemplo
```

---

## 🔄 Submódulos Git

El proyecto usa **submódulos Git** para el frontend y backend:

### Actualizar submódulos

```bash
# Actualizar todos los submódulos
git submodule update --remote --merge

# Actualizar un submódulo específico
cd frontend
git pull origin main
cd ..
git add frontend
git commit -m "chore: update frontend submodule"
```

### Clonar con submódulos

```bash
# Opción 1: Clonar e inicializar de una vez
git clone --recurse-submodules <url>

# Opción 2: Clonar e inicializar después
git clone <url>
cd recolecta_web
git submodule update --init --recursive
```

---

## 🛠️ Desarrollo

### Cambios en Frontend

```bash
cd frontend
npm install
npm run dev
```

Los cambios se reflejan automáticamente gracias a Vite.

### Cambios en Backend

```bash
cd gin-backend
go mod download
go run main.go
```

El backend se reinicia automáticamente con hot-reload (depende de configuración).

---

---

## 🧪 Testing

El proyecto incluye tests automatizados para validar la configuración y funcionamiento de los servicios.

### Tests de Redis

Suite de tests para validar:
- ✅ Configuración de `redis.conf`
- ✅ Healthcheck en Docker Compose
- ✅ Inicio del servicio y conectividad
- ✅ Persistencia de datos (AOF)

#### Ejecutar tests

**Requisitos:**
- Docker y Docker Compose corriendo
- WSL integrado con Docker Desktop (Windows)
- Bash disponible

**Desde WSL/Linux:**
```bash
bash scripts/tests/redis/run_all.sh
```

**Desde PowerShell (Windows con WSL):**
```powershell
wsl -d Ubuntu bash -c "cd /mnt/c/Users/TU_USUARIO/Documents/GithubProjects/recolecta_web && bash scripts/tests/redis/run_all.sh"
```

#### Salida esperada

```bash
Executing all Redis tests...
==================================
Starting Redis configuration test...
Redis configuration test passed successfully!
Starting Redis healthcheck test...
Redis healthcheck test passed successfully!
Starting Redis service startup test...
Redis service is up and responding to PING.
✅ Service started successfully and is healthy.
Starting Redis persistence test...
Persistence verified: value retrieved successfully (test-data)
==================================
All tests passed successfully!
```

#### Tests individuales

```bash
# Solo configuración
bash scripts/tests/redis/test_redis_config.sh

# Solo healthcheck
bash scripts/tests/redis/test_healthcheck.sh

# Solo startup
bash scripts/tests/redis/test_service_startup.sh

# Solo persistencia
bash scripts/tests/redis/test_persistence.sh
```

📖 **Documentación completa:** [docs/testing/redis-tests.md](docs/testing/redis-tests.md)

---

## ✅ Verificar Instalación

Después de ejecutar `docker compose -f docker/docker.compose.yml --env-file .env up -d`, verifica que todo funciona:

### 1. Estado de Contenedores

```bash
docker compose -f docker/docker.compose.yml ps
```

Deberías ver 3 contenedores **Up**:
- `postgres_db` - En puerto 5432
- `redis_cache` - En puerto 6379
- `nginx_proxy` - En puertos 80 y 443

### 2. Servicios Web

Abre tu navegador en:
- **http://localhost** - Deberías ver la página placeholder "Recolecta Web - En Construcción"
- **http://localhost/health** - Debería responder "healthy"

O desde terminal:
```bash
curl http://localhost
curl http://localhost/health
```

### 3. PostgreSQL

```bash
# Verificar conexión (reemplaza <usuario> y <nombre_db> con tus valores del .env)
docker compose -f docker/docker.compose.yml exec database psql -U <usuario> -d <nombre_db> -c "SELECT version();"

# Listar usuarios
docker compose -f docker/docker.compose.yml exec database psql -U <usuario> -d <nombre_db> -c "\du"

# Desde herramientas externas (pgAdmin, DBeaver, etc.):
# Host: localhost
# Port: 5432
# User: <tu_usuario del .env>
# Password: <tu_contraseña del .env>
# Database: <nombre_base_datos del .env>
```

### 4. Redis

```bash
# Ping a Redis (reemplaza <password> con tu REDIS_PASSWORD del .env)
docker compose -f docker/docker.compose.yml exec redis redis-cli -a <tu_contraseña_redis> PING

# Debería responder: PONG
```

### 5. Logs

```bash
# Si algo falla, revisa los logs
docker compose -f docker/docker.compose.yml logs
```

---

## 🐛 Solución de Problemas

### ❌ Puerto ya en uso

```bash
# Windows - Encontrar qué proceso usa el puerto
netstat -ano | findstr :5432
netstat -ano | findstr :6379
netstat -ano | findstr :80

# Matar proceso (reemplaza PID con el número que encontraste)
taskkill /PID <PID> /F

# O cambiar el puerto en .env
DB_PORT=5433
REDIS_PORT=6380
NGINX_PORT=8080
```

### ❌ No se puede conectar a PostgreSQL

**Problema:** "connection refused" o no puedes conectar desde herramientas externas

```bash
# 1. Verificar que el contenedor está corriendo
docker compose -f docker/docker.compose.yml ps

# 2. Verificar que el puerto está expuesto
docker compose -f docker/docker.compose.yml ps | findstr postgres

# Deberías ver: 0.0.0.0:5432->5432/tcp

# 3. Verificar variables de entorno dentro del contenedor
docker compose -f docker/docker.compose.yml exec database env | findstr POSTGRES

# 4. Probar conexión desde dentro del contenedor (usa tus valores del .env)
docker compose -f docker/docker.compose.yml exec database psql -U <usuario> -d <nombre_db> -c "SELECT 1;"

# 5. Si funciona desde dentro pero no desde fuera, es firewall
# Windows: Agregar regla en Windows Defender Firewall
```

### ❌ Redis: "NOAUTH Authentication required"

**Problema:** No puedes conectar a Redis o te pide autenticación

```bash
# Verificar que el password está configurado (debería mostrar tu REDIS_PASSWORD)
docker compose -f docker/docker.compose.yml exec redis redis-cli CONFIG GET requirepass

# Conectar con password (usa tu REDIS_PASSWORD del .env)
docker compose -f docker/docker.compose.yml exec redis redis-cli -a <tu_contraseña_redis> PING

# Si no funciona, recrear el contenedor
docker compose -f docker/docker.compose.yml down
docker compose -f docker/docker.compose.yml --env-file .env up -d --force-recreate
```

### ❌ Variables de entorno no se cargan

**Problema:** Los servicios usan valores por defecto en lugar de los de `.env`

```bash
# 1. Verificar que el archivo .env existe
Test-Path .env

# 2. Ver contenido del .env (sin mostrar passwords en pantalla)
Get-Content .env | Select-String -Pattern "USER|PORT|HOST" -NotMatch "PASSWORD"

# 3. Validar sintaxis del docker-compose.yml
docker compose -f docker/docker.compose.yml config

# 4. Recrear servicios asegurando que cargue .env
docker compose -f docker/docker.compose.yml down
docker compose -f docker/docker.compose.yml --env-file .env up -d

# 5. Verificar variables dentro del contenedor
docker compose -f docker/docker.compose.yml exec database env | findstr POSTGRES
docker compose -f docker/docker.compose.yml exec redis env | findstr REDIS
```

### ❌ Nginx muestra 502 Bad Gateway o 503

**Problema:** Nginx no puede conectar al backend

```bash
# 1. Ver logs de Nginx
docker compose -f docker/docker.compose.yml logs proxy

# 2. Verificar conectividad desde Nginx a otros servicios
docker compose -f docker/docker.compose.yml exec proxy ping database
docker compose -f docker/docker.compose.yml exec proxy ping redis

# 3. El backend aún no está configurado, es normal ver 503 en /api/
# Por ahora solo funciona la página placeholder
curl http://localhost        # Funciona
curl http://localhost/api/   # 503 (esperado)
```

### ❌ Volúmenes con datos viejos

**Problema:** Cambios en `.env` no se aplican porque PostgreSQL ya se inicializó

```bash
# PostgreSQL solo lee variables de entorno en la PRIMERA inicialización
# Si el volumen ya existe, ignora las nuevas variables

# Solución: Eliminar volúmenes y recrear (⚠️ BORRA TODOS LOS DATOS)
docker compose -f docker/docker.compose.yml down -v
docker compose -f docker/docker.compose.yml --env-file .env up -d

# Verificar que se creó con nuevas credenciales (usa tu DB_USER del .env)
docker compose -f docker/docker.compose.yml exec database psql -U <usuario> -d <nombre_db> -c "\du"
```

### ❌ Permisos denegados en Docker (Linux/Mac)

```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER
newgrp docker

# Verificar
docker run hello-world
```

### ❌ Docker Compose no encuentra el comando (Windows)

```bash
# Docker Compose v2 usa 'docker compose' (sin guión)
docker compose version

# Si tienes v1, usa 'docker-compose' (con guión)
docker-compose version

# Actualizar Docker Desktop a la última versión
```

---

## 📚 Documentación Adicional

| Documento | Propósito |
|-----------|-----------|
| [CHANGELOG.md](CHANGELOG.md) | Registro de cambios y versiones |
| [docker/README.md](docker/README.md) | **Guía completa de Docker**: comandos, servicios, credenciales |
| [.env.example](.env.example) | Plantilla de variables de entorno |
| [frontend/README.md](frontend/README.md) | Guía del frontend (WIP) |
| [gin-backend/README.md](gin-backend/README.md) | Guía del backend (WIP) |

---

## 🤝 Contribución

### Workflow de Desarrollo

1. **Crea una rama** desde `main`:
   ```bash
   git checkout -b feature/mi-nueva-funcionalidad
   ```

2. **Haz cambios** y actualiza el [CHANGELOG.md](CHANGELOG.md):
   ```bash
   # Añade tu cambio a la sección [Sin liberar]
   ```

3. **Haz commit** con mensaje descriptivo:
   ```bash
   git commit -am "feat: agregar nueva funcionalidad"
   ```

4. **Abre Pull Request** con descripción clara

5. **Espera revisión** del equipo

### Convención de Commits

```
<tipo>: <descripción corta>

feat:    Nueva funcionalidad
fix:     Corrección de bug
chore:   Cambios de configuración
docs:    Cambios en documentación
refactor: Reorganización de código
test:    Cambios en tests
```

---

## 📞 Soporte

- 📧 Email: support@recolecta.local
- 💬 Discord: [Tu servidor]
- 🐛 Issues: [GitHub Issues](https://github.com/tu-usuario/recolecta_web/issues)

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
