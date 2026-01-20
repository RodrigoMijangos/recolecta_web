# Script para automatizar transferencias de issues

Este documento proporciona scripts para facilitar la transferencia de issues a sus repositorios correspondientes.

## Opción 1: Script PowerShell (Windows)

Crea un archivo `transfer-issues.ps1`:

```powershell
# FASE 2-3: Transferir a vicpoo/API_recolecta
$backend_issues = @(4,5,6,7,8,9,10)
foreach ($issue in $backend_issues) {
    Write-Host "Abriendo issue #$issue para transferir a vicpoo/API_recolecta..."
    Start-Process "https://github.com/RodrigoMijangos/recolecta_web/issues/$issue"
    Write-Host "1. Click en ⋯"
    Write-Host "2. Click en 'Transfer issue'"
    Write-Host "3. Selecciona 'vicpoo/API_recolecta'"
    Read-Host "Presiona Enter cuando hayas completado la transferencia"
}

# FASE 4: Transferir a Denzel-Santiago/RecolectaWeb
$frontend_issues = @(11,12,13)
foreach ($issue in $frontend_issues) {
    Write-Host "Abriendo issue #$issue para transferir a Denzel-Santiago/RecolectaWeb..."
    Start-Process "https://github.com/RodrigoMijangos/recolecta_web/issues/$issue"
    Write-Host "1. Click en ⋯"
    Write-Host "2. Click en 'Transfer issue'"
    Write-Host "3. Selecciona 'Denzel-Santiago/RecolectaWeb'"
    Read-Host "Presiona Enter cuando hayas completado la transferencia"
}

Write-Host "Transferencias completadas!"
```

Ejecutar:
```powershell
.\transfer-issues.ps1
```

## Opción 2: Script Bash (Linux/Mac)

Crea un archivo `transfer-issues.sh`:

```bash
#!/bin/bash

# transfer-issues.sh
# Script para transferir issues

echo "=== Transfiriendo issues a gin-backend (FASE 2-3) ==="
for issue in 4 5 6 7 8 9 10; do
    echo "Abre en navegador: https://github.com/RodrigoMijangos/recolecta_web/issues/$issue"
    echo "1. Click en ⋯ → Transfer issue"
    echo "2. Selecciona: RodrigoMijangos/gin-backend"
    read -p "Presiona Enter cuando hayas completado..."
done

echo -e "\n=== Transfiriendo issues a frontend (FASE 4) ==="
for issue in 11 12 13; do
    echo "Abre en navegador: https://github.com/RodrigoMijangos/recolecta_web/issues/$issue"
    echo "1. Click en ⋯ → Transfer issue"
    echo "2. Selecciona: RodrigoMijangos/frontend"
    read -p "Presiona Enter cuando hayas completado..."
done

echo "¡Transferencias completadas!"
```

Ejecutar:
```bash
chmod +x transfer-issues.sh
./transfer-issues.sh
```

## Opción 3: URLs Directas (Manual más rápido)

Simplemente abre estas URLs y sigue los pasos:

### Transferir a vicpoo/API_recolecta (Backend):
- https://github.com/RodrigoMijangos/recolecta_web/issues/4
- https://github.com/RodrigoMijangos/recolecta_web/issues/5
- https://github.com/RodrigoMijangos/recolecta_web/issues/6
- https://github.com/RodrigoMijangos/recolecta_web/issues/7
- https://github.com/RodrigoMijangos/recolecta_web/issues/8
- https://github.com/RodrigoMijangos/recolecta_web/issues/9
- https://github.com/RodrigoMijangos/recolecta_web/issues/10

En cada issue:
1. Click en ⋯ → "Transfer issue"
2. Selecciona: `vicpoo/API_recolecta`

### Transferir a Denzel-Santiago/RecolectaWeb (Frontend):
- https://github.com/RodrigoMijangos/recolecta_web/issues/11
- https://github.com/RodrigoMijangos/recolecta_web/issues/12
- https://github.com/RodrigoMijangos/recolecta_web/issues/13

En cada issue:
1. Click en ⋯ → "Transfer issue"
2. Selecciona: `Denzel-Santiago/RecolectaWeb`

## Después de transferencias

Una vez transferidos todos los issues, puedes ver el estado con:

```bash
# Ver issues en recolecta_web
gh issue list --repo RodrigoMijangos/recolecta_web

# Ver issues en API_recolecta
gh issue list --repo vicpoo/API_recolecta

# Ver issues en RecolectaWeb
gh issue list --repo Denzel-Santiago/RecolectaWeb
```

---

## Verificación de Transferencias

Después de completar las transferencias, deberías tener:

**recolecta_web:** Issues #1-3, #14-24 (15 issues)
- FASE 1: Config (3) - Docker, .env, migraciones
- FASE 5: Testing (3) - E2E, persistencia, carga
- FASE 6: Docs (3) - Wiki, Redis docs, diagramas
- FASE 7: Producción (5) - Logging, métricas, HTTPS, alertas, disaster recovery

**vicpoo/API_recolecta (Backend):** Issues #4-10 (7 issues)
- FASE 2: Redis (3) - Cliente, estructuras, documentación
- FASE 3: Backend Notificaciones (4) - Proximidad, FCM, endpoints, tests

**Denzel-Santiago/RecolectaWeb (Frontend):** Issues #11-13 (3 issues)
- FASE 4: Frontend (3) - FCM web, Dashboard, token FCM
