# Workflow para trabajar con submódulos y mantener trazabilidad en el Project
# Uso: .\workflow-submodules.ps1 -action <action> -submodule <submodule> -message <message> -branch <branch>

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("init-branch", "work", "commit-submodule", "update-parent", "sync-all", "status")]
    [string]$action,
    
    [Parameter(Mandatory = $false)]
    [ValidateSet("frontend", "backend", "gin-backend")]
    [string]$submodule,
    
    [Parameter(Mandatory = $false)]
    [string]$message = "Update submodule",
    
    [Parameter(Mandatory = $false)]
    [string]$branch,
    
    [Parameter(Mandatory = $false)]
    [string]$issueNumber
)

$repoRoot = Get-Location

# Colores para output
$colors = @{
    info    = "Cyan"
    success = "Green"
    warning = "Yellow"
    error   = "Red"
}

function Write-Log {
    param([string]$message, [string]$level = "info")
    Write-Host $message -ForegroundColor $colors[$level]
}

function Invoke-Submodule {
    param([string]$submodule, [scriptblock]$script)
    Push-Location $submodule
    Write-Log "→ Entrando a: $submodule" "info"
    & $script
    Pop-Location
    Write-Log "← Saliendo de: $submodule" "info"
}

# ====== ACCIÓN: Inicializar rama de trabajo ======
if ($action -eq "init-branch") {
    if (-not $branch) {
        Write-Log "Error: Especifica -branch" "error"
        exit 1
    }
    if (-not $issueNumber) {
        Write-Log "Error: Especifica -issueNumber" "error"
        exit 1
    }
    
    Write-Log "🔄 Inicializando rama de trabajo: $branch" "info"
    git fetch origin
    git checkout -b $branch --track origin/main
    Write-Log "✅ Rama $branch creada y trackeando origin/main" "success"
    Write-Log "`n📝 Próximos pasos:" "info"
    Write-Log "1. Abre GitHub y crea un Issue #$issueNumber en recolecta_web" "info"
    Write-Log "2. Etiquétalo con la rama: $branch" "info"
    Write-Log "3. Comienza a trabajar en los submódulos con: .\workflow-submodules.ps1 -action work -submodule <nombre>" "info"
}

# ====== ACCIÓN: Cambiar a submódulo para trabajar ======
elseif ($action -eq "work") {
    if (-not $submodule) {
        Write-Log "Error: Especifica -submodule" "error"
        exit 1
    }
    
    Write-Log "📂 Navegando a submódulo: $submodule" "info"
    Push-Location $submodule
    Write-Log "✅ Ahora estás en: $(Get-Location)" "success"
    Write-Log "`n💡 Recuerda:" "warning"
    Write-Log "- Haz cambios y usa: git add/commit/push" "info"
    Write-Log "- Luego vuelve al padre y usa: .\workflow-submodules.ps1 -action commit-submodule -submodule $submodule -message '<mensaje>'" "info"
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") > $null
}

# ====== ACCIÓN: Commitear cambios en submódulo ======
elseif ($action -eq "commit-submodule") {
    if (-not $submodule) {
        Write-Log "Error: Especifica -submodule" "error"
        exit 1
    }
    
    Invoke-Submodule $submodule {
        Write-Log "📤 Pusheando cambios a origin/main..." "info"
        $currentBranch = git rev-parse --abbrev-ref HEAD
        if ($currentBranch -ne "main") {
            Write-Log "⚠️  Estás en rama '$currentBranch', no en 'main'" "warning"
            Write-Log "¿Deseas cambiar a main y mergear? (s/n)" "warning"
            $response = Read-Host
            if ($response -eq "s") {
                git checkout main
                git merge $currentBranch
            }
        }
        git push origin main
        Write-Log "✅ Cambios pusheados" "success"
    }
}

# ====== ACCIÓN: Actualizar referencia del submódulo en padre ======
elseif ($action -eq "update-parent") {
    if (-not $submodule) {
        Write-Log "Error: Especifica -submodule" "error"
        exit 1
    }
    
    Set-Location $repoRoot
    Write-Log "🔗 Actualizando referencia del submódulo en padre..." "info"
    
    git add $submodule
    git commit -m "chore: update $submodule ref"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "✅ Referencia actualizada en padre" "success"
        Write-Log "📤 Pusheando cambios del padre..." "info"
        git push origin HEAD
        Write-Log "✅ Padre pusheado" "success"
    }
    else {
        Write-Log "⚠️  No hay cambios nuevos en $submodule" "warning"
    }
}

# ====== ACCIÓN: Sincronizar TODOS los submódulos ======
elseif ($action -eq "sync-all") {
    Write-Log "🔄 Sincronizando todos los submódulos..." "info"
    
    @("frontend", "backend", "gin-backend") | ForEach-Object {
        $sub = $_
        if (Test-Path $sub) {
            Write-Log "`n→ Sincronizando: $sub" "info"
            Invoke-Submodule $sub {
                git fetch origin
                git merge origin/main
                Write-Log "✅ $sub sincronizado" "success"
            }
        }
    }
    
    Write-Log "`n🔗 Actualizando referencias en padre..." "info"
    git add frontend backend gin-backend
    git commit -m "chore: sync all submodule refs" -m "Sincronización de todos los submódulos a main"
    
    if ($LASTEXITCODE -eq 0) {
        git push origin HEAD
        Write-Log "✅ Todos los submódulos sincronizados" "success"
    }
    else {
        Write-Log "⚠️  Ya estaban sincronizados" "warning"
    }
}

# ====== ACCIÓN: Ver estado ======
elseif ($action -eq "status") {
    Write-Log "📊 Estado del repositorio:" "info"
    Write-Log "`n=== PADRE ===" "info"
    git status
    
    Write-Log "`n=== SUBMÓDULOS ===" "info"
    @("frontend", "backend", "gin-backend") | ForEach-Object {
        if (Test-Path $_) {
            Write-Log "`n→ $_" "info"
            Invoke-Submodule $_ { git status --short }
        }
    }
}

else {
    Write-Log "Acción no reconocida" "error"
}

Write-Log "`n" "info"
