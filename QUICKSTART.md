# 🚀 Guía Rápida de Inicio - Recolecta Web

Esta es una guía ultra-condensada para desarrolladores que quieren empezar **YA**.

## ⚡ 3 Comandos = Proyecto Corriendo

```bash
# 1. Clonar e inicializar
git clone <url-repo> && cd recolecta_web
git submodule update --init --recursive

# 2. Copiar .env y editar con tus valores
cp .env.example .env
# Abre .env y cambia las contraseñas

# 3. Levantar servicios (con wrapper que carga .env automáticamente)
./docker/docker-compose.sh up -d

# Alternativa: usar docker compose directamente
# docker compose -f docker/docker.compose.yml up -d
```

## ✅ Verificar que funciona

- 🌐 Abre http://localhost → Deberías ver "Recolecta Web - En Construcción"
- 🔍 http://localhost/health → Debería responder "healthy"

```bash
# Ver estado
./docker/docker-compose.sh ps

# Ver logs
./docker/docker-compose.sh logs -f

# Ejecutar tests de integridad
bash scripts/tests/redis/test_seed_integrity.sh
```

## 🔑 Credenciales (configurables en .env)

### PostgreSQL
```
Host: localhost
Port: 5432
User: <tu_usuario del .env>
Password: <tu_contraseña del .env>
Database: <nombre_base_datos del .env>
```

### Redis
```
Host: localhost
Port: 6379
Password: <tu_contraseña_redis del .env>
```

## 🛠️ Comandos Más Usados

```bash
# Levantar
docker compose -f docker/docker.compose.yml --env-file .env up -d

# Detener
docker compose -f docker/docker.compose.yml down

# Ver logs
docker compose -f docker/docker.compose.yml logs -f

# Estado
docker compose -f docker/docker.compose.yml ps

# Recrear todo (borra datos)
docker compose -f docker/docker.compose.yml down -v
docker compose -f docker/docker.compose.yml --env-file .env up -d

# PostgreSQL CLI (reemplaza valores con los de tu .env)
docker compose -f docker/docker.compose.yml exec database psql -U <usuario> -d <nombre_db>

# Redis CLI (usa tu REDIS_PASSWORD)
docker compose -f docker/docker.compose.yml exec redis sh -c 'REDISCLI_AUTH=<tu_contraseña_redis> redis-cli PING'
```

## 📚 Documentación Completa

- [README.md](README.md) - Guía completa del proyecto
- [docker/README.md](docker/README.md) - Referencia completa de Docker
- [CHANGELOG.md](CHANGELOG.md) - Historial de cambios

---

## 🔧 Comandos de Limpieza

```bash
# Detener servicios
docker compose -f docker/docker.compose.yml down

# Detener y borrar volúmenes (BORRA DATOS)
docker compose -f docker/docker.compose.yml down -v

# 🔥 LIMPIEZA COMPLETA (borra TODO: datos, imágenes, caché)
docker compose -f docker/docker.compose.yml down -v --remove-orphans
docker system prune -af --volumes

# 🔄 RESET TOTAL (limpieza + rebuild)
docker compose -f docker/docker.compose.yml down -v --remove-orphans; docker system prune -af --volumes; docker compose -f docker/docker.compose.yml --env-file .env up -d --build
```

**Cuándo usar limpieza completa:**
- Variables de entorno no se aplican
- Cambios en Dockerfiles no se reflejan
- Errores persistentes en contenedores
- Cambio de versiones de PostgreSQL/Redis

---

**¿Problemas?** Ve a [README.md#solución-de-problemas](README.md#-solución-de-problemas)
