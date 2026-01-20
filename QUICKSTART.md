# 🚀 Guía Rápida de Inicio - Recolecta Web

Esta es una guía ultra-condensada para desarrolladores que quieren empezar **YA**.

## ⚡ 3 Comandos = Proyecto Corriendo

```bash
# 1. Clonar e inicializar
git clone <url-repo> && cd recolecta_web
git submodule update --init --recursive

# 2. Copiar .env
cp .env.example .env

# 3. Levantar servicios
docker compose -f docker/docker.compose.yml --env-file .env up -d
```

## ✅ Verificar que funciona

- 🌐 Abre http://localhost → Deberías ver "Recolecta Web - En Construcción"
- 🔍 http://localhost/health → Debería responder "healthy"

```bash
# Ver estado
docker compose -f docker/docker.compose.yml ps

# Ver logs
docker compose -f docker/docker.compose.yml logs -f
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
docker compose -f docker/docker.compose.yml exec redis redis-cli -a <tu_contraseña_redis>
```

## 📚 Documentación Completa

- [README.md](README.md) - Guía completa del proyecto
- [docker/README.md](docker/README.md) - Referencia completa de Docker
- [CHANGELOG.md](CHANGELOG.md) - Historial de cambios

---

**¿Problemas?** Ve a [README.md#solución-de-problemas](README.md#-solución-de-problemas)
