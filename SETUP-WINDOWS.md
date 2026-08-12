# Setup: Windows 11 + RTX 4090 (invisible ComfyUI)

This is the supported install path. You use **Stability Matrix**. ComfyUI is installed automatically as a package. You generate only from **Inference** (optional SwarmUI later). You do **not** open the ComfyUI web dashboard.

Full concepts: [CONCEPTS.md](./CONCEPTS.md) · Models list: [MODELS.md](./MODELS.md)

---

## 0. Before you start

| Check | Target |
| --- | --- |
| GPU | RTX 4090 visible in Windows (Task Manager → Performance → GPU) |
| Driver | Current [NVIDIA Game Ready or Studio driver](https://www.nvidia.com/Download/index.aspx) |
| Disk | Prefer a fast NVMe with **≥500 GB free** (1 TB better) |
| Power | PC plugged in; don’t throttle the 4090 during first package install |

Optional helper (from this repo on the Windows PC):

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\01-verify-gpu.ps1
```

---

## 1. Install Stability Matrix

1. Download the official Windows build:  
   **https://github.com/LykosAI/StabilityMatrix/releases/latest/download/StabilityMatrix-win-x64.zip**  
   (or https://lykos.ai/downloads)
2. Extract the zip to a permanent path on your big drive, e.g.  
   `D:\StabilityMatrix\`  
   Avoid `Downloads\` long-term.
3. Run `StabilityMatrix.exe`.
4. If SmartScreen warns: **More info → Run anyway** (only if the zip came from the official link above).

---

## 2. First-launch wizard

1. Accept the license.
2. Confirm hardware check shows your **NVIDIA / 4090** (or high VRAM NVIDIA).
3. Choose **Data Directory** on the same fast drive (e.g. `D:\StabilityMatrix\` or `D:\SM-Data\`).
4. Leave **Portable Mode** enabled (recommended) so app + `Data` stay movable together.

Everything large (ComfyUI, checkpoints, outputs) lives under that Data Directory.

---

## 3. Install ComfyUI (backend only)

If the one-click “install a package” prompt appears after first launch:

1. Choose **ComfyUI** (required for Inference).
2. Let it finish (downloads PyTorch/CUDA wheels — can take a while on first run).

If you skipped that prompt:

1. Sidebar → **Packages**
2. **Add Package** → **ComfyUI**
3. Install and wait until status is ready

You are installing the engine. You will **not** use ComfyUI’s own website for daily work.

---

## 4. First generate (Inference — your real UI)

1. Sidebar → **Inference**
2. If prompted, **Launch** the ComfyUI backend (SM starts it; wait until connected)
3. Mode: **Text to Image**
4. Pick any installed starter model, or skip to §5 and import Illustrious first
5. Prompt something simple → **Generate**
6. Confirm an image appears in the preview / gallery

**Do not** open ComfyUI from Packages → Launch → browser node UI for normal use.

---

## 5. Add Illustrious + SDXL (drag-drop or browser)

### Option A — Model Browser (easiest)

1. Open **Model Browser** in Stability Matrix  
2. Search CivitAI / HuggingFace for:
   - An **Illustrious** / WAI-Illustrious style checkpoint (see [MODELS.md](./MODELS.md))
   - One **general SDXL** checkpoint (realism / general)
3. Download — files land in the shared Models tree automatically

### Option B — Drag-and-drop

1. Download `.safetensors` checkpoints in your browser  
2. Open Stability Matrix **Checkpoints / Models** manager  
3. **Drag and drop** the files in  
4. Optional: let it fetch CivitAI metadata/thumbnails  
5. They appear in Inference’s model dropdown

Folder layout (typical under Data Directory — names can vary slightly by SM version):

```
Data/
  Models/
    StableDiffusion/     ← checkpoints (Illustrious, SDXL, …)
    Lora/
    VAE/
    ...
```

Helper to open the shared models root after you set `SM_DATA` (see script comments):

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\02-open-model-folders.ps1
```

---

## 6. Smoke tests (done = Phase 1 complete)

| # | Test | Pass when |
| --- | --- | --- |
| 1 | Illustrious Text to Image | Image in gallery; model was Illustrious-family |
| 2 | SDXL Text to Image | Different checkpoint, usable image |
| 3 | Drag-drop | New `.safetensors` appears in model list without restarting Windows |
| 4 | (Optional) Wan Image to Video | Short clip from a still; may need Wan weights from Model Browser |

Illustrious tip: prefer **comma-separated tags**, CFG often ~3–6, size 1024×1024 (or 1536-class if the ckpt card says so). Details in [MODELS.md](./MODELS.md).

---

## 7. Optional: SwarmUI (still no Comfy dashboard)

Only if you want a browser **Generate** tab as a second front door:

1. Packages → Add → **SwarmUI** → install  
2. Launch SwarmUI from Stability Matrix  
3. Use the **Generate** tab only  
4. **Ignore** the Comfy Workflow / node tab  
5. Confirm it sees the same shared models (SM model sharing)

Day-1 is complete without SwarmUI. Inference alone is enough.

---

## 8. Daily use (cheat sheet)

1. Open **Stability Matrix**  
2. **Inference** → Launch backend if needed  
3. Pick checkpoint (Illustrious / SDXL / …)  
4. Prompt → Generate  
5. Drop new models into the manager whenever you download them  

Never required: opening Comfy’s node editor, installing Python yourself, or pasting workflow JSON.

---

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| SmartScreen blocks exe | Official zip only → More info → Run anyway |
| Inference can’t connect | Packages → start ComfyUI once from SM; wait for “running”; return to Inference |
| No 4090 / CUDA errors | Update NVIDIA driver; reboot; re-check GPU in Task Manager |
| Missing `c10.dll` / VC++ | Install [VC++ Redistributable x64](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist) |
| Model missing from dropdown | Confirm file is under shared `Models` (checkpoint folder); refresh model list |
| Out of disk | Move Data Directory / Portable install to larger drive; prune unused ckpts |
| Accidentally opened Comfy UI | Close the browser tab; go back to Inference |

---

## What “set up” means here vs the cloud agent

This repository prepares the playbook and helpers. **GPU install must run on your Windows 4090 PC** (this cloud environment cannot drive your local NVIDIA card). After you finish §1–§6, Phase 1 is live on your machine.
