# 🐳 Docker - Configuración y Uso

Este directorio contiene toda la configuración de Docker para el proyecto Recolecta.

## 📋 Estructura

```
docker/
├── docker.compose.yml          # Configuración principal (Producción)
├── docker.compose.dev.yml      # Configuración de desarrollo (WIP)
├── Dockerfile.nginx            # Imagen personalizada de Nginx
├── frontend-placeholder/       # HTML temporal
│   └── index.html             # Página "En construcción"
└── nginx/
    └── nginx.conf/            # Configuraciones futuras
```

---

## 🚀 Inicio Rápido

### Levantar servicios

```bash
# Desde la raíz del proyecto
docker compose -f docker/docker.compose.yml --env-file .env up -d
```

### Detener servicios

```bash
docker compose -f docker/docker.compose.yml down
```

### Ver logs

```bash
docker compose -f docker/docker.compose.yml logs -f
```

---

## 🔧 Servicios Configurados

### 1. PostgreSQL (`database`)

- **Imagen:** `postgres:16-alpine`
- **Container:** `postgres_db`
- **Puerto:** `5432` (expuesto al host)
- **Red:** `app_internal_net`
- **Volumen:** `postgres_data`

**Variables de entorno (desde `.env`):**
- `POSTGRES_USER` → Usuario de la base de datos
- `POSTGRES_PASSWORD` → Contraseña del usuario
- `POSTGRES_DB` → Nombre de la base de datos

**Credenciales (configurables en .env):**
```
Usuario: <tu_usuario del .env>
Password: <tu_contraseña del .env>
Database: <nombre_base_datos del .env>
Host: localhost (desde PC) o database (desde contenedores)
Puerto: 5432
```

**Comandos útiles:**
```bash
# Conectar desde el host (reemplaza <usuario> y <nombre_db> con tus valores)
docker compose -f docker/docker.compose.yml exec database psql -U <usuario> -d <nombre_db>

# Listar bases de datos (reemplaza valores con los de tu .env)
docker compose -f docker/docker.compose.yml exec database psql -U <usuario> -d <nombre_db> -c "\l"

# Listar usuarios
docker compose -f docker/docker.compose.yml exec database psql -U <usuario> -d <nombre_db> -c "\du"

# Backup
docker compose -f docker/docker.compose.yml exec database pg_dump -U <usuario> <nombre_db> > backup.sql

# Restore (PowerShell)
Get-Content backup.sql | docker compose -f docker/docker.compose.yml exec -T database psql -U <usuario> -d <nombre_db>
```

---

### 2. Redis (`redis`)

- **Imagen:** `redis:7.2-alpine`
- **Container:** `redis_cache`
- **Puerto:** `6379` (expuesto al host)
- **Red:** `app_internal_net`
- **Volumen:** `redis_data`
- **Persistencia:** AOF habilitado

**Variables de entorno (desde `.env`):**
- `REDIS_PASSWORD` → Password para autenticación

**Credenciales (configurables en .env):**
```
Host: localhost (desde PC) o redis (desde contenedores)
Puerto: 6379
Password: <tu_contraseña_redis del .env>
```

**Comandos útiles:**
```bash
# Conectar a Redis CLI (reemplaza <password> con tu REDIS_PASSWORD)
docker compose -f docker/docker.compose.yml exec redis redis-cli -a <tu_contraseña_redis>

# Ping (usa tu REDIS_PASSWORD del .env)
docker compose -f docker/docker.compose.yml exec redis redis-cli -a <tu_contraseña_redis> PING

# Ver configuración
docker compose -f docker/docker.compose.yml exec redis redis-cli -a <tu_contraseña_redis> CONFIG GET requirepass

# Flush all (limpiar datos)
docker compose -f docker/docker.compose.yml exec redis redis-cli -a <tu_contraseña_redis> FLUSHALL

# Info
docker compose -f docker/docker.compose.yml exec redis redis-cli -a <tu_contraseña_redis> INFO
```

---

### 3. Nginx (`proxy`)

- **Imagen:** Construida desde `Dockerfile.nginx`
- **Container:** `nginx_proxy`
- **Puertos:** `80`, `443` (expuestos al host)
- **Red:** `app_internal_net`
- **Contenido:** `frontend-placeholder/`

**Endpoints disponibles:**
```
http://localhost/         → Página placeholder (frontend-placeholder/index.html)
http://localhost/health   → Health check (responde "healthy")
http://localhost/api/     → Backend (actualmente responde 503 - no configurado)
```

**Comandos útiles:**
```bash
# Verificar configuración de Nginx
docker compose -f docker/docker.compose.yml exec proxy nginx -t

# Recargar configuración (sin reiniciar)
docker compose -f docker/docker.compose.yml exec proxy nginx -s reload

# Ver logs
docker compose -f docker/docker.compose.yml logs proxy

# Acceder al contenedor
docker compose -f docker/docker.compose.yml exec proxy sh

# Test desde terminal
curl http://localhost
curl http://localhost/health
```

**Configuración actual:**
- Sirve archivos estáticos desde `/usr/share/nginx/html`
- Proxy hacia backend en `/api/` (pendiente configuración)
- Gzip habilitado para mejor compresión
- Cache headers configurados
- Client max body size: 20MB

---

## 🔄 Variables de Entorno

El archivo `.env` en la raíz del proyecto contiene todas las variables necesarias:

**⚠️ NOTA IMPORTANTE:** En esta documentación usamos placeholders como `<usuario>`, `<tu_contraseña_segura>`, etc. 
Estos **deben ser reemplazados** con los valores reales que definas en tu archivo `.env`.

**Ejemplo de configuración en .env:**

```env
# PostgreSQL
DB_HOST=db
DB_PORT=5432
DB_USER=<tu_usuario>
DB_PASSWORD=<tu_contraseña_segura>
DB_NAME=<nombre_base_datos>

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=<tu_contraseña_redis_segura>

# Nginx
NGINX_PORT=80
NGINX_SSL_PORT=443
```

**⚠️ Importante:**
- El archivo `.env` no debe tener espacios alrededor del `=`
- Usa `.env.example` como referencia
- NUNCA hagas commit del `.env` con credenciales reales

---

## 🗄️ Volúmenes

Docker Compose crea volúmenes persistentes para los datos:

```bash
# Listar volúmenes
docker volume ls | findstr docker

# Ver detalles de un volumen
docker volume inspect docker_postgres_data
docker volume inspect docker_redis_data

# ⚠️ ELIMINAR volúmenes (BORRA TODOS LOS DATOS)
docker volume rm docker_postgres_data
docker volume rm docker_redis_data

# O con compose
docker compose -f docker/docker.compose.yml down -v
```

**Ubicación de datos:**
- `postgres_data` → `/var/lib/postgresql/data` (dentro del contenedor)
- `redis_data` → `/data` (dentro del contenedor)

---

## 🌐 Redes

Docker Compose crea una red bridge personalizada: `app_internal_net`

**Ventajas:**
- Los contenedores pueden comunicarse por nombre (ej: `database`, `redis`)
- Aislamiento de otros proyectos Docker
- DNS interno automático

**Comandos:**
```bash
# Ver redes
docker network ls | findstr docker

# Inspeccionar red
docker network inspect docker_app_internal_net

# Ver qué contenedores están en la red
docker network inspect docker_app_internal_net --format='{{range .Containers}}{{.Name}} {{end}}'
```

**Conectividad:**
```bash
# Probar conectividad entre contenedores
docker compose -f docker/docker.compose.yml exec proxy ping database
docker compose -f docker/docker.compose.yml exec proxy ping redis
```

---

## 🔒 Seguridad

### Contraseñas por defecto

Las contraseñas en `.env.example` son **SOLO PARA DESARROLLO**.

**En producción:**
1. Genera contraseñas fuertes únicas
2. Usa Docker Secrets o un gestor de secretos
3. Cambia todas las credenciales
4. Habilita SSL/TLS en PostgreSQL
5. Configura firewall para limitar acceso a puertos

### Ejemplo de contraseñas seguras

```bash
# Generar password aleatorio (PowerShell)
-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | % {[char]$_})
```

### PostgreSQL - Usuarios adicionales

Si necesitas crear usuarios adicionales con permisos limitados, crea scripts en:
```
docker/database/init/001-create-users.sql
```

Ejemplo:
```sql
-- Usuario read-only
CREATE ROLE readonly_user LOGIN PASSWORD 'secure_pass';
GRANT CONNECT ON DATABASE recolecta_db TO readonly_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;

-- Usuario para aplicación (sin privilegios de superuser)
CREATE ROLE app_user LOGIN PASSWORD 'app_secure_pass';
GRANT CONNECT ON DATABASE recolecta_db TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_user;
```

Luego monta el directorio en `docker.compose.yml`:
```yaml
volumes:
  - postgres_data:/var/lib/postgresql/data
  - ./database/init:/docker-entrypoint-initdb.d
```

---

## 🧪 Testing y Desarrollo

### Recrear desde cero

```bash
# 1. Detener y eliminar todo
docker compose -f docker/docker.compose.yml down -v

# 2. Verificar que no queden contenedores
docker ps -a | findstr "postgres\|redis\|nginx"

# 3. Verificar que no queden volúmenes
docker volume ls | findstr docker

# 4. Levantar de nuevo
docker compose -f docker/docker.compose.yml --env-file .env up -d

# 5. Verificar logs
docker compose -f docker/docker.compose.yml logs
```

### Cambiar versiones de imágenes

Edita `docker.compose.yml`:
```yaml
database:
  image: postgres:15-alpine  # Cambiar versión
```

Luego:
```bash
docker compose -f docker/docker.compose.yml pull
docker compose -f docker/docker.compose.yml up -d
```

---

## 📊 Monitoreo

### Logs en tiempo real

```bash
# Todos los servicios
docker compose -f docker/docker.compose.yml logs -f

# Un servicio específico
docker compose -f docker/docker.compose.yml logs -f database

# Con timestamps
docker compose -f docker/docker.compose.yml logs -f --timestamps
```

### Recursos

```bash
# Ver uso de CPU/RAM/Red
docker stats

# Solo servicios del proyecto
docker stats postgres_db redis_cache nginx_proxy
```

---

## 🚨 Troubleshooting

Ver sección de troubleshooting en el [README principal](../README.md#-solución-de-problemas).

---

**Última actualización:** 20 de Enero de 2026
