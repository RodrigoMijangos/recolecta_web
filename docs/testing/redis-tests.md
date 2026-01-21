# Tests de Redis

## Propósito
Verificar que Redis se configura, levanta y persiste correctamente en el entorno Docker.

## Requisitos previos
- Docker / Docker Compose instalado y en ejecución
- Bash >= 4.0 (WSL o Git Bash en Windows)
- Variables de entorno configuradas en `.env` (especialmente `REDIS_PASSWORD`)
- WSL integrado con Docker Desktop (Windows)

## Estructura de tests

```
scripts/tests/redis/
├── test_redis_config.sh      # Verifica redis.conf
├── test_healthcheck.sh        # Verifica healthcheck en docker-compose
├── test_service_startup.sh    # Verifica que el servicio levanta
├── test_persistence.sh        # Verifica persistencia AOF
└── run_all.sh                 # Ejecuta todos los tests
```

## Ejecutar tests

### Suite completa
```bash
bash scripts/tests/redis/run_all.sh
```

### Tests individuales
```bash
# Configuración
bash scripts/tests/redis/test_redis_config.sh

# Healthcheck
bash scripts/tests/redis/test_healthcheck.sh

# Startup
bash scripts/tests/redis/test_service_startup.sh

# Persistencia
bash scripts/tests/redis/test_persistence.sh
```

### Desde PowerShell (Windows con WSL)
```powershell
wsl -d Ubuntu bash -c "cd /mnt/c/Users/TU_USUARIO/Documents/GithubProjects/recolecta_web && bash scripts/tests/redis/run_all.sh"
```

## Qué verifica cada test

### test_redis_config.sh
Valida que `docker/redis/redis.conf` existe y contiene:
- `appendonly yes` — AOF habilitado
- `appendfsync everysec` — sincronización cada segundo
- `requirepass` — autenticación configurada
- `maxmemory` — límite de memoria establecido

**Salida esperada:**
```
Starting Redis configuration test...
✅ redis.conf válido
Redis configuration test passed successfully!
```

### test_healthcheck.sh
Valida que `docker/docker.compose.yml` contiene:
- Sección `healthcheck` en el servicio `redis`
- Test command con `redis-cli PING`
- Parámetros: `interval`, `timeout`, `retries`

**Salida esperada:**
```
Starting Redis healthcheck test...
✅ Healthcheck configurado correctamente
Redis healthcheck test passed successfully!
```

### test_service_startup.sh
Verifica que el servicio:
- Se levanta correctamente con `docker compose up -d redis`
- Responde a `PING` en menos de 30 segundos
- El healthcheck eventualmente pasa (puede estar en `starting` durante primeros 30s)

**Salida esperada:**
```
Starting Redis service startup test...
Redis service is up and responding to PING.
⚠️  Healthcheck status: starting (puede estar en progreso)
✅ Service started successfully and is healthy.
```

### test_persistence.sh
Verifica que:
- Se puede escribir una clave (`SET test:persist "test-data"`)
- Se ejecuta `BGSAVE` correctamente
- Tras reiniciar el contenedor, la clave persiste
- `GET test:persist` devuelve el valor original

**Salida esperada:**
```
Starting Redis persistence test...
SET key 'test:persist' with value 'test-data'
BGSAVE completed
Container restarted
Persistence verified: value retrieved successfully (test-data)
```

## Salida completa exitosa

```bash
Executing all Redis tests...
==================================
Starting Redis configuration test...
Redis configuration test passed successfully!
Starting Redis healthcheck test...
Redis healthcheck test passed successfully!
Starting Redis service startup test...
[+] Running 1/1
 ✔ Container redis_cache  Running                                                                                        
Redis service is up and responding to PING.
⚠️  Healthcheck status: starting (puede estar en progreso)
✅ Service started successfully and is healthy.
Starting Redis persistence test...
SET key 'test:persist' with value 'test-data'
BGSAVE completed
Container restarted
Persistence verified: value retrieved successfully (test-data)
==================================
All tests passed successfully!
```

## Troubleshooting

### Error: "AUTH failed: WRONGPASS"
**Causa:** La variable `REDIS_PASSWORD` no está cargada o es incorrecta.

**Solución:**
```bash
# Verificar el valor en .env
grep REDIS_PASSWORD .env

# En PowerShell, cargar manualmente
$Env:REDIS_PASSWORD='r3d1s_s3cur3_p4ss'

# En bash
export REDIS_PASSWORD='r3d1s_s3cur3_p4ss'
```

### Error: "docker-compose: command not found"
**Causa:** Docker no está integrado con WSL.

**Solución:**
1. Abre Docker Desktop
2. Settings → Resources → WSL Integration
3. Habilita integración con Ubuntu
4. Aplica y reinicia Docker Desktop

### Error: "Healthcheck not found"
**Causa:** El script no encuentra la configuración (problema de path o formato YAML).

**Solución:**
- Verifica que ejecutas desde la raíz del proyecto
- Verifica que `docker/docker.compose.yml` existe y tiene formato correcto

### Warning: "Healthcheck status: starting"
**Causa:** El healthcheck aún no ha completado su primer check (normal en primeros 30s).

**Solución:** No es un error. Si el servicio responde a PING, está funcionando. El healthcheck eventualmente pasará a `healthy`.

## Integración continua (CI)

Estos tests pueden ejecutarse en GitHub Actions para validar automáticamente cada PR/push.

Ver: [GitHub Actions para Redis](#github-actions) (próxima sección)

## Mantenimiento

### Actualizar tests cuando cambies:
- `docker/redis/redis.conf` → revisar `test_redis_config.sh`
- `docker/docker.compose.yml` (redis service) → revisar `test_healthcheck.sh`
- Contraseña de Redis → actualizar `.env` y `test_persistence.sh`

### Añadir nuevos tests
1. Crear script en `scripts/tests/redis/test_nuevo.sh`
2. Añadirlo a `run_all.sh`
3. Documentar en esta guía

## Referencias
- [Redis Persistence](https://redis.io/docs/management/persistence/)
- [Docker Compose Healthchecks](https://docs.docker.com/compose/compose-file/compose-file-v3/#healthcheck)
- [Redis Configuration](https://redis.io/docs/management/config/)
