# Grok Imagine–style Local Media Generator

Local, private AI **image + video** generation designed to feel as easy as [Grok Imagine](https://x.ai/api/imagine)—prompt, generate, refine—running on your own GPU machine via **ComfyUI**.

## Status

**Research & planning complete.** See **[PLAN.md](./PLAN.md)** for capability mapping, architecture options, model pack, UX targets, and phased build plan.

## Direction (short)

| Layer | Choice |
| --- | --- |
| Engine | ComfyUI (API + workflows) |
| Day-1 usability | SwarmUI via Stability Matrix |
| Target product UX | Thin Imagine-style UI (modes: Image · Edit · Video · Animate) |
| Default models | Flux (image), Qwen-Image-Edit (edit), Wan 2.2 + LTX-2.3 (video / A/V) |

## Next

1. Confirm local GPU VRAM / OS.
2. Phase 1: install Stability Matrix + SwarmUI + curated models (smoke-test image + video).
3. Phase 2–3: versioned Comfy workflows + Imagine UI in this repo.
