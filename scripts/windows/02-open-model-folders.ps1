#Requires -Version 5.1
<#
.SYNOPSIS
  Opens Stability Matrix shared model folders for drag-drop of checkpoints/LoRAs.

.DESCRIPTION
  Set SM_DATA to your Stability Matrix Data Directory, e.g.:
    $env:SM_DATA = "D:\StabilityMatrix\Data"
  Or pass -DataDirectory "D:\StabilityMatrix\Data"

  Portable installs often use: <StabilityMatrixFolder>\Data
#>

param(
    [string]$DataDirectory = $env:SM_DATA
)

if (-not $DataDirectory) {
    Write-Host "Set SM_DATA or pass -DataDirectory to your Stability Matrix Data folder." -ForegroundColor Yellow
    Write-Host 'Example:  $env:SM_DATA = "D:\StabilityMatrix\Data"'
    Write-Host '          .\02-open-model-folders.ps1'
    Write-Host 'Or:       .\02-open-model-folders.ps1 -DataDirectory "D:\StabilityMatrix\Data"'
    exit 1
}

if (-not (Test-Path $DataDirectory)) {
    Write-Host "Data directory not found: $DataDirectory" -ForegroundColor Red
    exit 1
}

$candidates = @(
    (Join-Path $DataDirectory "Models\StableDiffusion"),
    (Join-Path $DataDirectory "Models\Lora"),
    (Join-Path $DataDirectory "Models\VAE"),
    (Join-Path $DataDirectory "Models")
)

$opened = 0
foreach ($path in $candidates) {
    if (Test-Path $path) {
        Write-Host "Opening $path" -ForegroundColor Green
        Start-Process explorer.exe $path
        $opened++
    }
}

if ($opened -eq 0) {
    Write-Host "No Models subfolders found yet under $DataDirectory" -ForegroundColor Yellow
    Write-Host "Install ComfyUI via Stability Matrix first (creates shared Models tree), then re-run."
    Start-Process explorer.exe $DataDirectory
    exit 1
}

Write-Host "`nDrop .safetensors checkpoints into StableDiffusion (or use SM Checkpoint Manager drag-drop)." -ForegroundColor Cyan
