# Grok Imagine–style Local Media Generator

Local image + video on your **RTX 4090 / Windows 11**, aimed at Grok Imagine–level ease.

**ComfyUI is the engine.** Stability Matrix installs it and builds workflows for you. You generate from **Inference** (optional SwarmUI). You never open the ComfyUI dashboard for normal use.

## Start here (your Windows PC)

1. Clone or download this repo onto the 4090 machine.  
2. In PowerShell from the repo root:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\00-start-setup.ps1
```

3. Follow **[SETUP-WINDOWS.md](./SETUP-WINDOWS.md)** through smoke tests.  
4. Add models from **[MODELS.md](./MODELS.md)** (Illustrious + SDXL via drag-drop or Model Browser).

## Docs

| Doc | Contents |
| --- | --- |
| [SETUP-WINDOWS.md](./SETUP-WINDOWS.md) | Click-path install (SM → Comfy package → Inference) |
| [MODELS.md](./MODELS.md) | Starter Illustrious / SDXL / video pack |
| [CONCEPTS.md](./CONCEPTS.md) | What ComfyUI, Stability Matrix, and SwarmUI are |
| [PLAN.md](./PLAN.md) | Full research & architecture |

## Locked choices

| Item | Choice |
| --- | --- |
| Front door | Stability Matrix **Inference** |
| Engine | ComfyUI (auto-installed; API only from your POV) |
| Models | Drag-drop + in-app browser; **SDXL + Illustrious** |
| Optional UI | SwarmUI Generate tab (ignore its Comfy Workflow tab) |

## Note

GPU packages must be installed on **your** Windows machine. This repo is the automated playbook + helpers; a cloud agent cannot drive your local 4090.
