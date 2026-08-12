#Requires -Version 5.1
<#
.SYNOPSIS
  Launches the recommended Windows setup path for this project.

.DESCRIPTION
  1) Verifies GPU / disk
  2) Opens official Stability Matrix download
  3) Opens SETUP-WINDOWS.md and MODELS.md in the default apps

  This cannot install GPU packages onto your PC by itself — it starts the guided path.
  Run from a clone of this repo on the Windows 4090 machine.
#>

$ErrorActionPreference = "Continue"
$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")

Write-Host "== Grok Imagine Local — Windows setup launcher ==" -ForegroundColor Cyan
Write-Host "Repo: $RepoRoot`n"

& (Join-Path $PSScriptRoot "01-verify-gpu.ps1")

$smUrl = "https://github.com/LykosAI/StabilityMatrix/releases/latest/download/StabilityMatrix-win-x64.zip"
Write-Host "`nOpening Stability Matrix download..." -ForegroundColor Green
Start-Process $smUrl

$setup = Join-Path $RepoRoot "SETUP-WINDOWS.md"
$models = Join-Path $RepoRoot "MODELS.md"
$concepts = Join-Path $RepoRoot "CONCEPTS.md"

foreach ($doc in @($setup, $models, $concepts)) {
    if (Test-Path $doc) {
        Write-Host "Opening $doc"
        Start-Process $doc
    }
}

Write-Host "`nChecklist:" -ForegroundColor Cyan
Write-Host "  [1] Extract StabilityMatrix-win-x64.zip to a big NVMe folder"
Write-Host "  [2] Run StabilityMatrix.exe (Portable Mode + Data on that drive)"
Write-Host "  [3] Packages → install ComfyUI"
Write-Host "  [4] Inference → Launch → generate a test image"
Write-Host "  [5] Model Browser or drag-drop: Illustrious + SDXL (see MODELS.md)"
Write-Host "  [6] Do NOT open the ComfyUI node dashboard for daily use"
Write-Host "`nOptional later: Packages → SwarmUI → use Generate tab only"
Write-Host ""
