# Starter models (RTX 4090)

Add these through Stability Matrix **Model Browser** or **drag-and-drop** into the Checkpoint manager. Exact filenames/versions change often — search by the names below on CivitAI / HuggingFace and pick a recent, well-rated `.safetensors`.

You do **not** install separate “Illustrious workflows.” Illustrious-family files are **SDXL checkpoints**.

---

## Minimum pack (do this first)

| Role | What to search | Why |
| --- | --- | --- |
| **Illustrious (daily anime/illust)** | `WAI-illustrious` / `WAI-NSFW-illustrious-SDXL` or another popular **Illustrious** merge | “Just works” with normal SDXL settings; huge LoRA ecosystem |
| **Illustrious base (optional)** | `Illustrious XL` (OnomaAI / official) | Cleaner base for merging / LoRA training |
| **General SDXL** | A current SDXL realism or general checkpoint (e.g. community “Juggernaut XL”, “RealVisXL”, or similar) | Non-anime / photoreal lane |

### Suggested first settings (Illustrious-family)

| Setting | Start here |
| --- | --- |
| Size | 1024×1024 (try 832×1216 / 1216×832 for portraits) |
| Steps | 24–30 |
| CFG | 3.5–6 (lower if blown-out / overcooked) |
| Sampler | Euler a / Euler (follow the model card if it disagrees) |
| Prompt style | **Tags**, comma-separated — not long Flux prose |

Example positive (structure only):

```text
masterpiece, best quality, 1girl, green hair, jacket, city street, night, neon lights
```

Example negative (trim to taste):

```text
worst quality, low quality, bad anatomy, blurry, watermark, text
```

---

## Quality / other lanes (add when curious)

| Role | Search / family | Notes |
| --- | --- | --- |
| Strong tag anime (advanced) | `NoobAI-XL` (incl. V-Pred variants) | Often needs **v-prediction** settings — only if Inference/Swarm exposes them; otherwise prefer WAI-Illustrious first |
| Prompt-adherent stills | `FLUX` fp8 / GGUF | Different prompting (natural language); separate from Illustrious |
| Fast drafts | Flux Schnell-class / turbo SDXL | Quick iteration |

---

## Video (after image pack works)

Use Inference’s **Wan** tabs (or SwarmUI video) — still no Comfy dashboard.

| Role | Search | Notes |
| --- | --- | --- |
| Animate a still | Wan 2.2 I2V / TI2V | 4090 can run strong FP8/GGUF builds |
| Text → video | Wan 2.2 T2V | Longer than cloud Imagine; watch VRAM |
| Video + audio (optional) | LTX 2.x | Closer to “native sound”; larger downloads |

Download video weights via Model Browser into the folders SM expects (often under diffusion/video-related model dirs). If a download lands wrong, move it in the Models manager rather than editing Comfy paths by hand.

---

## LoRAs

1. Download Illustrious- or SDXL-compatible LoRAs from CivitAI.  
2. Drag-drop into the **LoRA** library in Stability Matrix.  
3. Enable from Inference / SwarmUI (syntax or picker — follow the UI).  
4. Match LoRA base to the checkpoint family (Illustrious LoRA on Illustrious ckpt).

---

## Where files go

Under your Stability Matrix **Data Directory** (Portable Mode keeps this next to the app):

```text
Data/Models/StableDiffusion/   ← checkpoints (.safetensors)
Data/Models/Lora/              ← LoRAs
Data/Models/VAE/               ← VAE if a card requires one
```

Exact subfolder names can vary slightly by SM version; the in-app manager is authoritative — prefer drag-drop over guessing paths.

---

## Disk budget (rough)

| Item | Size order |
| --- | --- |
| Each SDXL/Illustrious ckpt | ~6–7 GB |
| Flux-class | ~10–20+ GB depending on quant |
| Wan / LTX video | tens of GB each |
| ComfyUI package + deps | several GB |

Plan **hundreds of GB** if you collect Illustrious merges + video.

---

## License note

Check each model card (CivitAI / HuggingFace) for license and commercial use. Illustrious / community merges vary. This repo does not redistribute weights.
