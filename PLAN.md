# Grok Imagine–style Local Media Generator — Research & Plan

**Goal:** A local system that feels as easy as Grok Imagine (prompt → media, iterate in plain language) while running on a powerful personal GPU machine.

**Repo intent:** `Grok-Imagine-ComfyUi-Local` — ComfyUI as the generation engine, with a deliberately simple front door.

---

## 1. What “as easy as Grok Imagine” actually means

Grok Imagine is not a node graph or a parameter panel. It is a **product UX** with these jobs:

| Job | Grok Imagine behavior |
| --- | --- |
| Text → image | One prompt, few or no knobs, multiple variants |
| Image edit | Natural-language instruction on 1–3 reference images |
| Text / image → video | Short clips; image-to-video is first-class |
| Video edit / extend / restyle | Keep iterating in the same session |
| Projects + library | Organize and find past work |
| Parallel agents | Queue multiple jobs without babysitting |
| Native audio (video) | Sound generated with the clip (Aurora / Video 1.5) |

**UX principles to copy (non-negotiable):**

1. **One text box + Generate** as the default path.
2. **Modes as tabs or chips**, not workflows: Image · Edit · Video · Animate.
3. **Click a result → refine** (“make it dusk”, “slow push-in”) without leaving the canvas.
4. **Hide samplers, CFG, steps, node graphs** behind an Advanced drawer.
5. **Sensible defaults** per mode so first output is usable.

Anything that forces the user into ComfyUI nodes fails the ease goal—even if ComfyUI remains the backend.

---

## 2. Local capability map (2026)

Open local stacks can cover most Imagine features. Exact parity with Aurora (speed, physics, native audio quality) on a single consumer GPU is **not** realistic; the product goal is **same workflow, good enough quality, private, free to run**.

| Imagine feature | Best local stand-ins | Notes |
| --- | --- | --- |
| Text → image | **FLUX.2 / FLUX.1**, Z-Image Turbo, Qwen-Image | Flux family ≈ Imagine’s Flux-based stills heritage |
| Image edit (NL) | **Qwen-Image-Edit** (Apache) or **FLUX.1 Kontext [dev]** | Qwen better for multi-ref + text-in-image + commercial-friendly license; Kontext strong on identity/photoreal |
| Multi-image edit (≤3) | Qwen-Image-Edit | Closest to Imagine’s multi-ref edit |
| Text → video | **Wan 2.2**, **LTX-2.3**, HunyuanVideo 1.5 | Wan = quality/control; LTX = native A/V |
| Image → video | Wan 2.2 TI2V / I2V, LTX I2V | Primary “animate this still” path |
| Native audio | **LTX-2.3** (synced A/V) | Closest open match to Imagine Video audio |
| Video edit / extend | ComfyUI Wan/LTX extend + edit workflows | More manual than Imagine API today |
| Chat-like iteration | Custom UI **or** SwarmUI + saved presets | Must be built or configured; not free with raw ComfyUI |

### Hardware reality check

Assume a **powerful local PC** means roughly:

| GPU VRAM | Practical sweet spot |
| --- | --- |
| **12–16 GB** | Fast images (Flux fp8 / GGUF); video via Wan 5B or quantized 14B / LTX GGUF |
| **24 GB** (4090 / 3090) | Comfortable Flux + Wan 14B FP8 / LTX FP8 — **recommended minimum for “Imagine-like” video** |
| **32–48 GB+** | Higher res, longer clips, less offloading, parallel jobs |

Also plan for: **≥64 GB system RAM** (T5 / VL encoders often CPU-offload), **fast NVMe** (models are tens–hundreds of GB), **CUDA NVIDIA** as the default path (AMD/Apple work but with more friction).

---

## 3. Architecture options

### Option A — Install-and-go (fastest)

**Stability Matrix** → install **SwarmUI** (and optionally ComfyUI) → download curated models.

- Pros: One installer, shared model store, SwarmUI Generate tab is dial-driven and beginner-friendly; video models (Wan, Hunyuan) supported; can drop into Comfy graph when needed.
- Cons: Not chat/project-identical to grok.com/imagine; still “AI art UI”, not a conversational product.

### Option B — ComfyUI-only + templates

ComfyUI Desktop / portable + Manager + official templates (Flux, Qwen Edit, Wan, LTX).

- Pros: Newest models first; best long-term engine; API for automation.
- Cons: Node UI fails the ease goal unless heavily templated and users never open the graph.

### Option C — Custom “Imagine” frontend on ComfyUI API (**best match to repo + goal**)

Thin web app (prompt, modes, gallery, projects) that POSTs **pre-baked ComfyUI workflow JSON** with only prompt/images/duration/aspect swapped.

```
┌─────────────────────────────────────────┐
│  Imagine UI (chat / modes / gallery)    │
│  - Image | Edit | Video | Animate       │
│  - Projects, history, parallel queue    │
└─────────────────┬───────────────────────┘
                  │ HTTP + WebSocket
┌─────────────────▼───────────────────────┐
│  ComfyUI server (engine)                │
│  workflows/: t2i, edit, i2v, t2v, extend│
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│  Models on disk (Flux / Qwen / Wan / LTX)│
└─────────────────────────────────────────┘
```

- Pros: Closest to Grok Imagine ease; full control of UX; ComfyUI stays the power tool underneath.
- Cons: Requires building/maintaining the UI and workflow pack; model downloads still manual or scripted.

### Option D — Hybrid (**recommended**)

1. **Day 0–1:** Stability Matrix + SwarmUI + models → usable immediately.
2. **Week 1:** Lock a small set of ComfyUI workflows that map 1:1 to Imagine modes.
3. **Week 2+:** Ship a minimal Imagine-style UI that only exposes those modes (this repo’s product surface).
4. Keep SwarmUI/ComfyUI available for power users.

This maximizes “easy now” without blocking “as easy as Imagine” later.

---

## 4. Recommended model pack

Curate a **small** default set so the UI never asks “which checkpoint?”.

### Images

| Role | Model | Why |
| --- | --- | --- |
| Default T2I | FLUX.1 / FLUX.2 (fp8 or GGUF) | Quality + prompt adherence; Imagine heritage |
| Fast / draft | Z-Image Turbo or Flux Schnell-class | Seconds, not minutes |
| Edit | **Qwen-Image-Edit** (fp8/GGUF) | NL edit + multi-image; Apache-friendly |
| Optional photoreal edit | FLUX.1 Kontext [dev] | Character consistency; check BFL license for commercial use |

### Video

| Role | Model | Why |
| --- | --- | --- |
| Default I2V / T2V | **Wan 2.2** (5B for speed, 14B for quality) | Strong open motion quality |
| Audio-capable | **LTX-2.3** | Closest to Imagine’s native sound |
| Low-VRAM fallback | Wan 1.3B / aggressive GGUF | Keep the machine usable under load |

### Defaults the UI should set (user never sees)

- Aspect: 1:1 image, 16:9 / 9:16 video
- Duration: 5–6 s default (offer 10–15 s if VRAM allows)
- Resolution: 1024-class images; 480p draft / 720p final video
- Steps / CFG / sampler: baked into workflow JSON

---

## 5. Product UX sketch (target)

Mirror grok.com/imagine, not Automatic1111.

**First screen**

- Brand / product name
- Big prompt box
- Mode chips: `Image` · `Edit` · `Video` · `Animate`
- One primary CTA: **Generate**
- Aspect + (for video) duration only

**After generate**

- Grid of results
- On select: `Animate` · `Edit` · `Vary` · `Extend` · `Download`
- Thread of refinements (chat-style history attached to the asset)

**Left rail**

- Projects
- Library (searchable)
- Queue (parallel jobs)

**Never on the main path**

- Node graphs, LoRA stacks, ControlNet wiring, sampler menus

Advanced users open “Open in ComfyUI” to break glass.

---

## 6. Phased implementation plan

### Phase 0 — Hardware & baseline (short)

- Confirm GPU (NVIDIA + VRAM), RAM, disk free space (≥500 GB recommended for image+video pack).
- Install latest NVIDIA drivers + CUDA-capable stack.
- Decide primary OS path: **Windows** (easiest installers) or **Linux** (best long-term for headless/API).

**Exit criteria:** `nvidia-smi` healthy; ≥200 GB free on model drive.

### Phase 1 — Working local studio (no custom code)

1. Install [Stability Matrix](https://lykos.ai/stability-matrix) (or ComfyUI Desktop if preferred).
2. Install packages: **ComfyUI** + **SwarmUI**.
3. Download the curated model pack (scripted checklist in-repo later).
4. Verify four smoke tests:
   - Text → image (Flux)
   - Image → edit (Qwen-Image-Edit)
   - Image → video (Wan I2V)
   - Text → video with audio (LTX-2.3), if VRAM allows

**Exit criteria:** Non-technical user can produce an image and an animated clip from SwarmUI without touching nodes.

### Phase 2 — Imagine mode workflows (ComfyUI JSON)

Create and version-control a workflow pack:

| File | Maps to Imagine |
| --- | --- |
| `workflows/t2i_flux.json` | Image generation |
| `workflows/edit_qwen.json` | NL image edit (+ multi-ref) |
| `workflows/i2v_wan.json` | Animate still |
| `workflows/t2v_wan.json` | Text → video |
| `workflows/t2v_ltx_av.json` | Video + audio |
| `workflows/extend_video.json` | Continue clip |

Expose only: `prompt`, `seed`, `aspect_ratio`, `duration`, `input_images[]`.

Document one-command launch: start ComfyUI with API, load defaults.

**Exit criteria:** Each mode runnable via ComfyUI API with a single JSON body.

### Phase 3 — Imagine-style web UI (this repo’s main product)

Minimal stack suggestion:

- **Frontend:** Next.js or Vite + React (gallery, modes, chat refine)
- **Backend:** thin Node/Python proxy → ComfyUI HTTP/WS (queue, progress, history)
- **Storage:** local `outputs/` + SQLite/JSON for projects & metadata
- **Optional:** local LLM (Ollama) only for prompt expansion—not required for v1

v1 scope (keep narrow):

1. Image generate + history  
2. Edit with upload / last image  
3. Animate (I2V)  
4. Projects + download  

Defer: video edit parity, multi-agent parallelism UI polish, mobile app.

**Exit criteria:** Someone who uses Grok Imagine can generate and refine without reading a manual.

### Phase 4 — Polish for “daily driver”

- One-click start script / systemd / Windows service
- Model auto-download + disk budget warnings
- Queue + multi-job (SwarmUI “swarm” or custom queue)
- Optional LAN access (auth!) for phone/tablet on home network
- Backup/export of project library

---

## 7. What we will not match (honest gaps)

| Gap | Mitigation |
| --- | --- |
| Aurora speed (~25s for 6s 720p on their infra) | Local often minutes; show progress + draft-first (480p) |
| Video physics / audio polish | Prefer LTX for A/V; Wan for silent quality; don’t oversell |
| True multi-turn agent “just chat” | UI can feel chatty; full LLM agent is optional Phase 4+ |
| Zero setup | Local always needs GPU drivers + large downloads once |
| Cloud convenience | Privacy and cost are the trade |

---

## 8. Decision summary

| Decision | Choice | Rationale |
| --- | --- | --- |
| Engine | **ComfyUI** | Matches repo; newest models; real API |
| Day-1 UI | **SwarmUI via Stability Matrix** | Easy without building first |
| Target UX | **Custom Imagine UI** over Comfy workflows | Only path that feels like Grok Imagine |
| Default image | Flux family | Quality + Imagine lineage |
| Default edit | Qwen-Image-Edit | Multi-ref NL edit, friendlier license |
| Default video | Wan 2.2 + LTX-2.3 | Quality + native audio respectively |
| Strategy | **Hybrid phases 0→4** | Easy now, Imagine-like soon |

---

## 9. Immediate next actions (when leaving research)

1. Confirm GPU model / VRAM / OS (sizes the model pack).
2. Run Phase 1 on the local machine (Stability Matrix + SwarmUI + smoke tests).
3. In this repo: add `workflows/`, `scripts/download-models.sh`, and a minimal UI scaffold for Phase 3.
4. Freeze a “default pack” so the UI never exposes model hunting.

---

## 10. Sources (research snapshot)

- xAI Imagine capabilities: [docs.x.ai Imagine](https://docs.x.ai/developers/model-capabilities/imagine), [Imagine API](https://x.ai/api/imagine), [Video 1.5](https://x.ai/news/grok-imagine-video-1-5)
- Local UIs: [SwarmUI](https://github.com/mcmonkeyprojects/SwarmUI), [Stability Matrix](https://docs.lykos.ai/stability-matrix/getting-started/overview.html), [InvokeAI](https://github.com/invoke-ai/InvokeAI), ComfyUI
- Edit models: ComfyUI Flux Kontext / Qwen-Image-Edit tutorials
- Video models: Wan 2.2, LTX-2.3, HunyuanVideo community VRAM guides (2026)
