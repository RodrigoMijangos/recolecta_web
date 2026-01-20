#!/usr/bin/env powershell
# Script para transferir issues entre repositorios
# Transfiere de: RodrigoMijangos/recolecta_web
# Hacia: vicpoo/API_recolecta (Backend) y Denzel-Santiago/RecolectaWeb (Frontend)

# Issues a transferir a vicpoo/API_recolecta (FASE 2-3: Backend)
$backend_issues = @(4,5,6,7,8,9,10)

# Issues a transferir a Denzel-Santiago/RecolectaWeb (FASE 4: Frontend)
$frontend_issues = @(11,12,13)

Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "   Transfiriendo Issues entre Repositorios" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Cyan

# Transferir a vicpoo/API_recolecta
Write-Host "`n📦 Transfiriendo a vicpoo/API_recolecta (Backend):" -ForegroundColor Green
foreach ($issue in $backend_issues) {
    Write-Host "  • Issue #$issue" -ForegroundColor Yellow
    $url = "https://github.com/RodrigoMijangos/recolecta_web/issues/$issue"
    Write-Host "    URL: $url"
}

Write-Host "`n⚠️  Para completar las transferencias:" -ForegroundColor Yellow
Write-Host "  1. Ve a cada URL arriba" -ForegroundColor Gray
Write-Host "  2. Click en ⋯ (menú)" -ForegroundColor Gray
Write-Host "  3. Click en 'Transfer issue'" -ForegroundColor Gray
Write-Host "  4. Selecciona 'vicpoo/API_recolecta'" -ForegroundColor Gray
Write-Host "  5. Confirma" -ForegroundColor Gray

# Transferir a Denzel-Santiago/RecolectaWeb
Write-Host "`n📦 Transfiriendo a Denzel-Santiago/RecolectaWeb (Frontend):" -ForegroundColor Green
foreach ($issue in $frontend_issues) {
    Write-Host "  • Issue #$issue" -ForegroundColor Yellow
    $url = "https://github.com/RodrigoMijangos/recolecta_web/issues/$issue"
    Write-Host "    URL: $url"
}

Write-Host "`n" -ForegroundColor Cyan
Write-Host "🎯 Alternativamente, abre estos links en tu navegador:" -ForegroundColor Cyan

Write-Host "`n▶ Backend (vicpoo/API_recolecta):" -ForegroundColor Green
$backend_issues | ForEach-Object {
    Write-Host "   https://github.com/RodrigoMijangos/recolecta_web/issues/$_"
}

Write-Host "`n▶ Frontend (Denzel-Santiago/RecolectaWeb):" -ForegroundColor Green
$frontend_issues | ForEach-Object {
    Write-Host "   https://github.com/RodrigoMijangos/recolecta_web/issues/$_"
}

Write-Host "`n" -ForegroundColor Cyan
