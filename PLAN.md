# Grok Imagine–style Local Media Generator — Research & Plan

**Goal:** A local system that feels as easy as Grok Imagine (prompt → media, iterate) on your RTX 4090 — powered by ComfyUI under the hood, with **all backend/workflow setup automatic** so you never open the ComfyUI dashboard.

---

## Hard constraints (locked)

| Constraint | Implication |
| --- | --- |
| **RTX 4090 (24 GB), Windows 11 Pro** | Full-quality Flux + SDXL/Illustrious + Wan/LTX video are all in range |
| **ComfyUI is fine as the engine** | We *want* ComfyUI’s model support and speed — just not its UI |
| **Backend + workflows set up automatically** | Installer/front door installs Comfy, deps, and builds graphs for you |
| **Never see the ComfyUI dashboard** | No node editor, no workflow JSON, no “Queue Prompt” in Comfy’s web UI |
| **Drag-drop checkpoints into the UI** | Shared model library with import-by-drop + CivitAI/HF browser |
| **SDXL + Illustrious required** | First-class checkpoint list; Illustrious is a normal SDXL `.safetensors` family |

### Invisible-Comfy principle

```
You see:     prompt · mode · model dropdown · Generate · gallery · drag-drop models
You never:   Comfy web UI · node graph · wiring Load Checkpoint → KSampler → VAE Decode
Comfy does:  everything behind the API (graphs auto-built by Stability Matrix / SwarmUI)
```

Allowed: ComfyUI running as a local service.  
Not allowed (for daily use): you configuring or even looking at that service’s dashboard.

---

## Locked architecture (recommended)

```
┌──────────────────────────────────────────────────────────┐
│  YOUR UI (Stability Matrix Inference, optional SwarmUI)  │
│  • Modes: Image / Img2Img / Upscale / Wan video          │
│  • Model Browser + drag-drop checkpoints / LoRAs         │
│  • Outputs gallery + projects                            │
│  • Auto-builds Comfy graphs from panel settings          │
└────────────────────────────┬─────────────────────────────┘
                             │ HTTP/WS API only (headless to you)
┌────────────────────────────▼─────────────────────────────┐
│  ComfyUI (auto-installed backend)                        │
│  Installed & launched by Stability Matrix                │
│  Workflows generated programmatically — not by you       │
│  Dashboard: do not open                                  │
└────────────────────────────┬─────────────────────────────┘
                             │
┌────────────────────────────▼─────────────────────────────┐
│  Shared Models folder                                    │
│  Drop Illustrious/SDXL/Flux/Wan files → appear in UI list│
└──────────────────────────────────────────────────────────┘
```

**How “automatic workflow setup” works in practice**

1. You install **Stability Matrix** (one Windows app).  
2. SM’s Package Manager installs **ComfyUI** (Python, torch, custom nodes as needed).  
3. You use **Inference** (or SwarmUI). When you hit Generate, the front door **assembles a Comfy graph from your panel choices** and submits it to Comfy’s API.  
4. You only ever change: prompt, model (Illustrious/SDXL/…), aspect, steps if you want — never nodes.

**Optional:** SwarmUI Generate tab — same idea (Comfy backend, dial UI, auto workflows). Still never open Comfy’s own UI.

### Why this stack

| Need | Stability Matrix Inference | SwarmUI | Custom Imagine UI | Raw ComfyUI dashboard |
| --- | --- | --- | --- | --- |
| Auto-install Comfy backend | Yes | Via SM or own installer | We’d have to automate it | Manual / Desktop |
| Auto-build workflows | Yes (panel → graph) | Yes (Generate → graph) | Yes (if we ship baked JSON) | **You build them** |
| Hide Comfy dashboard | Yes | Yes | Yes | **No — that is the UI** |
| Drag-drop checkpoints | Yes | Yes | Build it | Folder only |
| SDXL / Illustrious | Yes | Yes | Yes | Yes |
| Video (Wan) | Yes | Yes | Later | Manual workflows |

**Decision:** Day‑1 product = **Stability Matrix + Inference**, ComfyUI as invisible auto-managed backend. SwarmUI optional. Custom chat shell only if you still want more “Imagine” after that.

---

## Hardware profile (your machine)

| Spec | Plan assumption |
| --- | --- |
| GPU | **RTX 4090 24 GB** — treat as “full pack” tier |
| OS | **Windows 11 Pro** — use official Stability Matrix `win-x64` release |
| System RAM | Prefer **64 GB** if available (video + big text encoders); **32 GB** workable |
| Disk | Fast NVMe; budget **≥500 GB–1 TB** free for models (Illustrious/SDXL packs add up fast) |
| Drivers | Current Game Ready / Studio NVIDIA driver before first launch |

On a 4090 you can comfortably run:

- SDXL / Illustrious at 1024–1536 native, high steps, batches of 2–4
- Flux fp8 / full-ish quality stills
- Wan 2.2 14B FP8 or strong GGUF; Wan 5B for faster I2V
- LTX-2.x FP8 for video+audio experiments

---

## What “as easy as Grok Imagine” means here

Still the same product jobs — but delivered through **Inference tabs / Swarm Generate**, not chat-on-xAI:

1. Open Stability Matrix → Inference → type prompt → Generate  
2. Modes as tabs: Text to Image · Image to Image · Wan Image to Video · Wan Text to Video · Upscale  
3. Pick an Illustrious/SDXL/Flux checkpoint from a **dropdown fed by your library**  
4. Drop new `.safetensors` into the Checkpoint Manager (or use Model Browser) → they appear in the list  
5. Never open the ComfyUI web dashboard; never paste workflow JSON; never wire nodes  

ComfyUI can (and should) be running in the background. Ease = **not looking at it**.

Close enough for daily use; true multi-turn “agent chat” remains a later nice-to-have, not a setup blocker.

---

## Model strategy (your library, not our workflows)

### How you add models (required UX)

1. **Drag-drop** into Stability Matrix Checkpoint / Model Manager (auto-sorts type when possible; CivitAI metadata fetch optional).  
2. **Model Browser** inside the app → CivitAI / HuggingFace → download into the shared `Models` tree.  
3. Or copy files into the shared folders (e.g. `Data\Models\StableDiffusion` for checkpoints); the UI refreshes the usable list.

No per-model Comfy graph. If a file is a standard SDXL/Illustrious checkpoint, select it and generate.

### Recommended starter pack (4090)

| Role | What to get | Notes |
| --- | --- | --- |
| **Illustrious (primary anime/illust)** | A current Illustrious XL / community fine-tune from CivitAI | Booru-style tags; CFG often ~3–6; 1024² or 1536-class |
| **SDXL general / realism** | One clean SDXL or popular realism checkpoint | Natural-language prompts work better than pure tags |
| **LoRAs** | Character / style LoRAs matching Illustrious or SDXL base | Drop into LoRA folder; enable from UI |
| **Optional Flux** | Flux fp8 (quality / prompt adherence) | Different “feel” from Illustrious; keep as second lane |
| **Video** | Wan 2.2 (I2V/T2V); optional LTX for A/V | Use Inference’s Wan tabs or SwarmUI video — still no nodes |
| **VAE / upscalers** | SDXL VAE if a ckpt needs it; 4× upscaler | Usually auto or one dropdown |

### Illustrious usage notes (UI only)

- Prompt with **comma-separated tags** (Danbooru-style), not long Flux-style prose.  
- Put subject/character tags first.  
- Keep CFG moderate (community often lands ~3–6).  
- Works as a normal **SDXL checkpoint** in Stability Matrix / SwarmUI — no special “Illustrious workflow.”

---

## Day-1 install playbook (you click; app installs backend)

Exact buttons may shift slightly by Stability Matrix version; intent is fixed.

1. Install current **NVIDIA driver** for the 4090.  
2. Download **Stability Matrix** Windows build from the official GitHub/releases / [docs](https://docs.lykos.ai/stability-matrix/getting-started/overview.html).  
3. Unzip to a path on a **large fast drive** (e.g. `D:\StabilityMatrix`). Prefer portable/data-dir on that drive.  
4. First-launch wizard → set Data Directory on that drive.  
5. **Packages → Add → ComfyUI** → install.  
   - This *is* the backend. You install it through the app once. You do **not** configure it.  
6. Open **Inference** → Launch backend when prompted → generate a test SDXL/Illustrious image.  
7. **Models:**  
   - Browser-download Illustrious + one SDXL ckpt, **or**  
   - Drag-drop existing `.safetensors` into Checkpoint Manager.  
8. Optional: Packages → Add → **SwarmUI** if you want that Generate UI; point it at the shared model root (SM usually shares automatically).  
9. Never open “ComfyUI” from the package list for daily work unless troubleshooting.

**Success =** prompt → image with Illustrious selected, after only Stability Matrix UI actions.

---

## Capability map vs Grok Imagine (with this stack)

| Imagine job | How you do it (no nodes) | 4090 fit |
| --- | --- | --- |
| Text → image | Inference Text to Image; pick Illustrious/SDXL/Flux | Excellent |
| Image edit / restyle | Inference Image to Image (+ later Kontext/Qwen if exposed in UI) | Good |
| Animate still | Inference Wan Image to Video | Good (minutes, not seconds) |
| Text → video | Inference Wan Text to Video | Good |
| Video + audio | LTX path via Swarm/Inference when available; else silent Wan | Partial |
| Add models | Drag-drop / Model Browser | First-class |
| Projects | `.smproj` + outputs gallery | Good enough |
| Chat agents / multi-agent | Not native; defer | Gap |

---

## What we explicitly will not do (per your constraints)

- No manual Python/venv/git Comfy installs as the supported path (SM installs Comfy for you).  
- No “download this workflow JSON and fix red nodes” user journey.  
- No requiring you to open or learn the Comfy dashboard/graph for Illustrious, SDXL, or Wan.  
- No treating “open ComfyUI in the browser” as a normal step in the guide.  
- No custom frontend as a blocker before you can generate (optional Phase N only).

**ComfyUI itself is in-scope** — as an automated backend, not as a UI you operate.

---

## Repo role going forward

This repository becomes a **Windows 4090 playbook + curated defaults**, not a DIY Comfy lab:

| Artifact | Purpose |
| --- | --- |
| `PLAN.md` (this file) | Architecture + constraints |
| `SETUP-WINDOWS.md` (next) | Click-by-click Stability Matrix guide |
| `MODELS.md` (next) | Starter Illustrious/SDXL/Flux/Wan list + where files go |
| Optional scripts | e.g. open known model folders; never required for core use |
| Optional later UI | Only if SM Inference still isn’t “Imagine-simple” enough |

Building a greenfield chat UI that re-implements model import + Wan tabs would duplicate Stability Matrix without buying ease.

---

## Phased plan (revised)

### Phase 0 — Prep (local machine)
- Confirm free disk on NVMe, NVIDIA driver current, 4090 visible in Task Manager / `nvidia-smi` if you have it.  
- Decide Data Directory drive (models live here long-term).

### Phase 1 — Zero-DIY studio (primary deliverable)
- Install Stability Matrix.  
- Install ComfyUI **only as the managed package**.  
- Use **Inference only**.  
- Import Illustrious + SDXL via drag-drop or Model Browser.  
- Smoke tests: Illustrious T2I, SDXL T2I, one Wan I2V.

### Phase 2 — Library hygiene
- Folders for Checkpoints / LoRA / VAE / video.  
- Naming conventions; CivitAI metadata on.  
- Short Illustrious vs Flux prompting cheat sheet in `MODELS.md`.

### Phase 3 — Optional SwarmUI
- Install via Package Manager if you want a second no-node Generate surface (grids, video models, power dials).  
- Still shared models; still no graph.

### Phase 4 — Only if needed: thinner “Imagine” shell
- If Inference still feels too dense, wrap **only** prompt + mode + model dropdown + gallery.  
- Backend remains Stability Matrix–managed Comfy — you still don’t set it up.

---

## Decision summary

| Decision | Choice |
| --- | --- |
| Front door | **Stability Matrix Inference** on Windows 11 |
| Engine | **ComfyUI** — auto-installed, API-only from your POV |
| Workflows | **Auto-built** by Inference/Swarm from UI settings |
| Comfy dashboard | **Never part of the user path** |
| Model intake | **Drag-drop + in-app Model Browser** |
| Anime/illust | **Illustrious XL checkpoints** (SDXL family) |
| General SDXL | At least one non-Illustrious SDXL ckpt |
| Video | Wan tabs in Inference; LTX optional |
| GPU tier | RTX 4090 full pack |
| Hand-authored Comfy graphs | **Out of scope for you** |
| Custom chat UI | Deferred; not required to start |

---

## Repo deliverables (done)

1. `SETUP-WINDOWS.md` — install Stability Matrix → Comfy package → Inference → first Illustrious image.  
2. `MODELS.md` — starter Illustrious/SDXL/video guidance + drag-drop destinations.  
3. `CONCEPTS.md` — plain-language Comfy / SM / SwarmUI.  
4. `scripts/windows/` — preflight + setup launcher + open model folders.

**Remaining work is on the Windows 4090 PC:** run `scripts/windows/00-start-setup.ps1` and complete SETUP-WINDOWS smoke tests.  

---

## Sources

- [Stability Matrix overview](https://docs.lykos.ai/stability-matrix/getting-started/overview.html)  
- [Inference overview](https://docs.lykos.ai/stability-matrix/inference/overview.html) (no node graph; Comfy under the hood)  
- [Inference guide (wiki)](https://github.com/LykosAI/StabilityMatrix/wiki/Inference-Guide)  
- [SwarmUI basic usage](https://github.com/mcmonkeyprojects/SwarmUI/blob/master/docs/Basic%20Usage.md)  
- Illustrious = SDXL checkpoint ecosystem (CivitAI / OnomaAI); tag-style prompting  
- Prior research: Flux / Qwen-Edit / Wan / LTX as optional quality lanes on 4090  
