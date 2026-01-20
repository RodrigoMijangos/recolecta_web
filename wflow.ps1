# Wrapper para ejecutar el workflow con un alias corto
# Uso: ./wflow.ps1 -action status
# Pasa todos los argumentos directamente al script original

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    $Args
)

$scriptPath = Join-Path $PSScriptRoot "docs/workflow/workflow-submodules.ps1"

if (-not (Test-Path $scriptPath)) {
    Write-Error "No se encontró el script en $scriptPath"
    exit 1
}

# Propaga los argumentos al script original
& $scriptPath @Args
