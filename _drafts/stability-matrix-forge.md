---
layout: post
title: "Getting Started with AI Image Generation Using Stability Matrix and Forge UI"
tags: [ai, stable-diffusion, self-hosted, image-generation]
thumbnail: /assets/images/stability-matrix-forge/banner.webp
---

AI image generation has become remarkably accessible. What used to require cloud credits and API keys can now run entirely on your own hardware — and the results are impressive. The barrier to getting started has dropped significantly, largely thanks to tools like **Stability Matrix**, which takes care of the complicated setup so you can focus on generating images.

This post walks through getting Stability Matrix installed, setting up **Forge UI**, and running your first Stable Diffusion image. There's a huge ecosystem of models and interfaces to explore beyond this — but this is a great place to start.

<br>

## What Is Stable Diffusion?

**Stable Diffusion** is an open-source AI image generation model. You describe what you want in a text prompt and it generates an image. It runs locally on your own hardware — no cloud, no subscriptions, no usage limits.

The model itself has gone through several generations and variants (more on that later), but the core idea is the same: text in, image out.

<br>

## What Is Stability Matrix?

**Stability Matrix** is a cross-platform package manager and launcher for AI image generation tools. Instead of manually cloning repositories, installing Python dependencies, and managing virtual environments, Stability Matrix handles everything through a clean UI.

It supports multiple interfaces and lets you switch between them easily — all sharing the same model library so you're not duplicating large files on disk.

Download it from the [Stability Matrix GitHub releases page](https://github.com/LykosAI/StabilityMatrix/releases) for Windows, macOS, or Linux.

<br>

## Installing Stability Matrix

1. Download the installer for your platform from the releases page
2. Run the installer and choose an install location — this is where your models, outputs, and packages will live, so pick somewhere with plenty of disk space
3. Launch Stability Matrix

On first launch it will prompt you to set a **data directory**. This is where everything gets stored. An SSD with at least 20GB free is recommended — models alone can be several gigabytes each.

<figure>
  <img src="/assets/images/stability-matrix-forge/stability-matrix.webp" alt="Stability Matrix home screen" width="600">
  <figcaption>Stability Matrix home screen</figcaption>
</figure>

<br>

## Installing Forge UI

**Forge UI** (officially *Stable Diffusion WebUI Forge*) is a fork of the original AUTOMATIC1111 WebUI, optimised for performance and lower VRAM usage. It's faster than the original, handles larger models more efficiently, and is actively maintained.

To install it through Stability Matrix:

1. Click **Add Package** from the Packages tab
2. Select **Stable Diffusion WebUI Forge** from the list
3. Click **Install** and wait for the install to complete

Stability Matrix will handle the Python environment, dependencies, and everything else automatically.

<figure>
  <img src="/assets/images/stability-matrix-forge/install-forge.webp" alt="Installing Forge UI in Stability Matrix" width="600">
  <figcaption>Installing Forge UI through Stability Matrix</figcaption>
</figure>

<br>

## Downloading a Model

Stable Diffusion needs a model (also called a checkpoint) to generate images. Without one, the interface launches but can't produce anything.

The **Models** tab in Stability Matrix connects directly to **CivitAI** and **Hugging Face**, the two main model repositories. You can browse and download from within the app.

> ⚠️ **Australian users:** CivitAI is no longer accessible in Australia. Use the **Hugging Face** browser instead, or download models directly from Hugging Face and import them manually into Stability Matrix.

A good starting point for beginners is **Realistic Vision** or **DreamShaper** — both are versatile, well-documented, and available on Hugging Face.

To download a model:

1. Go to the **Model Browser** tab
2. Search for a model by name
3. Select a version and click **Import**

Models are saved to the shared model directory, so they're available across all installed interfaces.

<br>

## Launching Forge UI and Generating Your First Image

1. From the **Packages** tab, click **Launch** next to Forge UI
2. Stability Matrix will open the Forge web interface in your browser (typically at `http://localhost:7860`)

From the Forge UI:

1. Select your downloaded model from the **Checkpoint** dropdown at the top
2. Type a prompt in the text box — describe what you want to generate
3. Add a **negative prompt** to exclude things you don't want (e.g. `blurry, low quality, distorted`)
4. Click **Generate**

<figure>
  <img src="/assets/images/stability-matrix-forge/forge-ui.webp" alt="Forge UI interface" width="700">
  <figcaption>Forge UI interface</figcaption>
</figure>

A few settings worth knowing:

* **Steps** — how many refinement passes the model makes. 20–30 is a good starting range
* **CFG Scale** — how closely the model follows your prompt. 7 is a sensible default
* **Sampler** — the algorithm used to generate the image. `DPM++ 2M Karras` is a reliable default

<br>

## A Note on Models

One of the most powerful aspects of Stable Diffusion is the sheer number of models available. Different models are trained for different styles and outputs:

* **Photorealistic models** — designed to produce images that look like photographs
* **Anime and illustration models** — trained on stylised artwork
* **SDXL models** — a newer, higher resolution generation of models with improved quality
* **FLUX models** — a more recent architecture with particularly strong prompt adherence

This post uses Stable Diffusion 1.5-based models as a starting point because they're lightweight, well-supported, and have the largest library of community resources. But swapping to a different model in Forge UI is as simple as changing the checkpoint dropdown — the interface stays exactly the same.

As you get more comfortable, experimenting with different models is one of the best ways to find a style that suits what you're trying to create.

<br>

## What About ComfyUI?

**ComfyUI** is another interface available through Stability Matrix and is worth knowing about. Where Forge UI gives you a straightforward form-based interface, ComfyUI uses a **node-based workflow** — you visually connect inputs, models, samplers, and outputs together like a flowchart.

This makes ComfyUI significantly more powerful and flexible. You can build complex multi-step pipelines, chain models together, and fine-tune exactly how an image is generated at each stage. It's the preferred tool for more advanced users and is widely used for video generation workflows.

The trade-off is the learning curve. ComfyUI requires understanding how the image generation pipeline actually works, rather than just filling in fields. If you're just getting started, Forge UI is the better choice — but once you're comfortable with the basics, ComfyUI is worth exploring.

Both can be installed side by side through Stability Matrix and share the same model library.

<br>

## Final Thoughts

Getting a local image generation setup running used to take a frustrating amount of time. Stability Matrix has changed that — from download to generating your first image takes less than an hour, most of which is waiting for models to download.

Start with Forge UI, try a few different models, and get a feel for how prompting works. There's a large and active community built around Stable Diffusion with a huge amount of shared knowledge, model recommendations, and prompt guides. Once the basics are comfortable, ComfyUI opens the door to a lot more.
