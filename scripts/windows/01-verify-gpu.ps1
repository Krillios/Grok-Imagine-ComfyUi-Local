#Requires -Version 5.1
<#
.SYNOPSIS
  Quick preflight for RTX 4090 + Windows before Stability Matrix install.
#>

$ErrorActionPreference = "Continue"
Write-Host "== Grok-Imagine-Local preflight ==" -ForegroundColor Cyan

# NVIDIA driver / GPU
$nvidiaSmi = Get-Command nvidia-smi -ErrorAction SilentlyContinue
if ($nvidiaSmi) {
    Write-Host "`n[nvidia-smi]" -ForegroundColor Green
    & nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader
} else {
    Write-Host "`n[nvidia-smi] NOT FOUND" -ForegroundColor Yellow
    Write-Host "Install/update NVIDIA drivers, then re-run this script."
    Write-Host "https://www.nvidia.com/Download/index.aspx"
}

# Disk free space on non-tiny volumes
Write-Host "`n[Disk free space]" -ForegroundColor Green
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } | ForEach-Object {
    $freeGB = [math]::Round(($_.Free / 1GB), 1)
    $color = if ($freeGB -ge 500) { "Green" } elseif ($freeGB -ge 200) { "Yellow" } else { "Red" }
    Write-Host ("  {0}: {1} GB free" -f $_.Name, $freeGB) -ForegroundColor $color
}

Write-Host "`n[Recommendation]" -ForegroundColor Cyan
Write-Host "Put Stability Matrix + Data Directory on a drive with >= 500 GB free (1 TB better)."
Write-Host "Next: follow SETUP-WINDOWS.md or run 00-start-setup.ps1"
Write-Host ""
