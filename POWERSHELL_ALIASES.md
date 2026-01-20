# 🔧 Aliases de PowerShell para Recolecta

Estos aliases te facilitan trabajar con Docker Compose sin escribir comandos largos.

## 📥 Instalación

### Opción 1: Copiar y pegar en tu sesión actual

```powershell
# Copiar todo el bloque siguiente y ejecutar en PowerShell
function dcu { docker compose -f docker/docker.compose.yml --env-file .env up -d }
function dcd { docker compose -f docker/docker.compose.yml down }
function dcl { docker compose -f docker/docker.compose.yml logs -f }
function dcp { docker compose -f docker/docker.compose.yml ps }
function dcr { docker compose -f docker/docker.compose.yml down -v; docker compose -f docker/docker.compose.yml --env-file .env up -d }
function dcdb { docker compose -f docker/docker.compose.yml exec database psql -U <usuario> -d <nombre_db> }
function dcredis { docker compose -f docker/docker.compose.yml exec redis redis-cli -a <tu_contraseña_redis> }
```

### Opción 2: Agregar a tu perfil de PowerShell (permanente)

```powershell
# 1. Abrir tu perfil de PowerShell
notepad $PROFILE

# Si dice que no existe, créalo:
New-Item -Path $PROFILE -Type File -Force
notepad $PROFILE

# 2. Pegar todo lo siguiente en el archivo y guardar:
```

```powershell
# ============================================
# Recolecta Web - Docker Compose Aliases
# ============================================

# Shortcuts para proyecto Recolecta
function dcu {
    <#
    .SYNOPSIS
    Levanta los servicios de Docker
    #>
    docker compose -f docker/docker.compose.yml --env-file .env up -d
}

function dcd {
    <#
    .SYNOPSIS
    Detiene los servicios de Docker
    #>
    docker compose -f docker/docker.compose.yml down
}

function dcl {
    <#
    .SYNOPSIS
    Muestra logs en tiempo real
    #>
    param([string]$Service = "")
    if ($Service) {
        docker compose -f docker/docker.compose.yml logs -f $Service
    } else {
        docker compose -f docker/docker.compose.yml logs -f
    }
}

function dcp {
    <#
    .SYNOPSIS
    Muestra el estado de los servicios
    #>
    docker compose -f docker/docker.compose.yml ps
}

function dcr {
    <#
    .SYNOPSIS
    Reinicia todo desde cero (BORRA DATOS)
    #>
    Write-Host "⚠️  ADVERTENCIA: Esto borrará todos los datos de la base de datos" -ForegroundColor Yellow
    $confirm = Read-Host "¿Continuar? (y/N)"
    if ($confirm -eq 'y' -or $confirm -eq 'Y') {
        docker compose -f docker/docker.compose.yml down -v
        docker compose -f docker/docker.compose.yml --env-file .env up -d
        Write-Host "✅ Servicios recreados" -ForegroundColor Green
    } else {
        Write-Host "❌ Cancelado" -ForegroundColor Red
    }
}

function dcdb {
    <#
    .SYNOPSIS
    Conecta a PostgreSQL CLI
    .DESCRIPTION
    Reemplaza <usuario> y <nombre_db> con los valores de tu .env
    #>
    param([string]$Command = "")
    if ($Command) {
        docker compose -f docker/docker.compose.yml exec database psql -U <usuario> -d <nombre_db> -c $Command
    } else {
        docker compose -f docker/docker.compose.yml exec database psql -U <usuario> -d <nombre_db>
    }
}

function dcredis {
    <#
    .SYNOPSIS
    Conecta a Redis CLI
    .DESCRIPTION
    Reemplaza <tu_contraseña_redis> con el valor de tu REDIS_PASSWORD del .env
    #>
    param([string]$Command = "PING")
    docker compose -f docker/docker.compose.yml exec redis redis-cli -a <tu_contraseña_redis> $Command
}

function dcrestart {
    <#
    .SYNOPSIS
    Reinicia un servicio específico
    #>
    param([string]$Service)
    if (-not $Service) {
        Write-Host "❌ Especifica un servicio: database, redis, proxy" -ForegroundColor Red
        return
    }
    docker compose -f docker/docker.compose.yml restart $Service
    Write-Host "✅ Servicio $Service reiniciado" -ForegroundColor Green
}

function dcstats {
    <#
    .SYNOPSIS
    Muestra estadísticas de recursos
    #>
    docker stats postgres_db redis_cache nginx_proxy
}

# Mensaje de bienvenida (opcional - comentar si no quieres verlo)
Write-Host "🚀 Aliases de Recolecta cargados. Usa: dcu, dcd, dcl, dcp, dcr, dcdb, dcredis" -ForegroundColor Cyan
```

```powershell
# 3. Cerrar y reabrir PowerShell, o recargar perfil:
. $PROFILE
```

---

## 📝 Uso de los Aliases

### `dcu` - Up (Levantar servicios)
```powershell
dcu
# Equivale a:
# docker compose -f docker/docker.compose.yml --env-file .env up -d
```

### `dcd` - Down (Detener servicios)
```powershell
dcd
# Equivale a:
# docker compose -f docker/docker.compose.yml down
```

### `dcl` - Logs (Ver logs)
```powershell
# Todos los servicios
dcl

# Un servicio específico
dcl database
dcl redis
dcl proxy
```

### `dcp` - PS (Estado de servicios)
```powershell
dcp
# Equivale a:
# docker compose -f docker/docker.compose.yml ps
```

### `dcr` - Reset (Recrear todo)
```powershell
dcr
# ⚠️ CUIDADO: Borra todos los datos y recrea los servicios
```

### `dcdb` - PostgreSQL CLI
```powershell
# Entrar a psql interactivo
dcdb

# Ejecutar comando directo
dcdb "SELECT version();"
dcdb "\du"
dcdb "\l"
```

### `dcredis` - Redis CLI
```powershell
# Ping
dcredis

# Otro comando
dcredis "INFO"
dcredis "KEYS *"
dcredis "GET mikey"
```

### `dcrestart` - Reiniciar servicio
```powershell
dcrestart database
dcrestart redis
dcrestart proxy
```

### `dcstats` - Estadísticas de recursos
```powershell
dcstats
# Muestra CPU, RAM, Red de los contenedores
```

---

## 🎯 Ejemplos de Uso Común

### Workflow diario
```powershell
# 1. Llegar por la mañana
cd C:\Users\...\recolecta_web
dcu                    # Levantar servicios
dcp                    # Verificar estado

# 2. Trabajar en el código...

# 3. Ver logs si algo falla
dcl database          # Ver logs de PostgreSQL
dcl                   # Ver logs de todos

# 4. Al terminar el día
dcd                   # Detener servicios
```

### Debugging rápido
```powershell
# Ver estado
dcp

# Ver logs del que falla
dcl proxy

# Reiniciar el servicio problemático
dcrestart proxy

# Ver estadísticas
dcstats
```

### Probar conexiones
```powershell
# PostgreSQL
dcdb "SELECT version();"
dcdb "\du"

# Redis
dcredis "PING"
dcredis "INFO server"
```

### Reset completo (cuando algo está muy roto)
```powershell
dcr
# Confirma con 'y'
# Espera a que termine
dcp     # Verificar que todo está OK
```

---

## 🔧 Personalización

Puedes agregar tus propios aliases editando `$PROFILE`:

```powershell
# Ejemplo: Backup rápido de PostgreSQL
function dcbackup {
    $fecha = Get-Date -Format "yyyyMMdd_HHmmss"
    # Reemplaza <usuario> y <nombre_db> con tus valores del .env
    docker compose -f docker/docker.compose.yml exec database pg_dump -U <usuario> <nombre_db> > "backup_$fecha.sql"
    Write-Host "✅ Backup guardado: backup_$fecha.sql" -ForegroundColor Green
}

# Ejemplo: Ver variables de entorno del .env
function dcenv {
    Get-Content .env | Select-String -Pattern "PASSWORD" -NotMatch
}

# Ejemplo: Abrir navegador en localhost
function dcweb {
    Start-Process "http://localhost"
}
```

---

## 🐛 Troubleshooting

### "no se reconoce como cmdlet"
Significa que el alias no está cargado. Soluciones:
```powershell
# Recargar perfil
. $PROFILE

# O ejecutar las funciones manualmente en esta sesión
```

### "cannot be loaded because running scripts is disabled"
Cambiar política de ejecución:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Los aliases no funcionan en otras carpetas
Los aliases asumen que estás en la raíz del proyecto `recolecta_web`. Si quieres usarlos desde cualquier lugar:

```powershell
# Modificar los aliases para usar path absoluto
$RecolectaPath = "C:\Users\TuUsuario\Documents\GithubProjects\recolecta_web"

function dcu {
    Push-Location $RecolectaPath
    docker compose -f docker/docker.compose.yml --env-file .env up -d
    Pop-Location
}

# ... etc para cada función
```

---

## 📚 Más Información

- [README.md](README.md) - Guía completa
- [QUICKSTART.md](QUICKSTART.md) - Inicio rápido
- [docker/README.md](docker/README.md) - Documentación Docker detallada

---

**Última actualización:** 20 de Enero de 2026
