---
layout: post
title: "Running Local AI with Gemma 4 and OpenClaw on Linux"
tags: [ai, homelab, self-hosted, linux]
thumbnail: /assets/images/gemma4-openclaw/banner.webp
---

Local AI has come a long way. A year ago, running a capable language model on your own hardware meant accepting significant compromises in quality. With the release of **Gemma 4**, that's no longer the case, and pairing it with **OpenClaw** gives you a genuinely useful AI assistant running entirely on your own infrastructure.

This post covers why Gemma 4 is worth your attention and how to get it running with Ollama and OpenClaw on Linux.

<br>

## Why Gemma 4?

Google DeepMind released Gemma 4 in April 2026 under the **Apache 2.0 license** (meaning no usage caps, no restrictions, and full commercial freedom). It comes in four sizes:

| Variant | Parameters | Best for |
|---------|-----------|---------|
| E2B | ~2B effective | Low-end hardware, fast responses |
| E4B | ~4B effective | Recommended starting point |
| 26B MoE | 3.8B active | High quality, GPU recommended |
| 31B Dense | 31B | Maximum capability |

What makes Gemma 4 different isn't just the raw numbers, it's the efficiency. The 26B Mixture of Experts model activates only **3.8B parameters at a time**, giving you quality that competes with much larger models at a fraction of the compute cost.

The benchmark improvements over Gemma 3 are significant:

* **AIME 2026** (maths): 20.8% → 89.2%
* **LiveCodeBench** (coding): 29.1% → 80.0%
* **GPQA Diamond** (science): 42.4% → 84.3%

The 31B model currently sits at **#3 on the open model leaderboard**, and the 26B at #6. For a model you can run locally, that's remarkable.

Other notable features:
* **256K context window**: handles long documents and conversations without losing track
* **Multimodal**: supports image input alongside text
* **Native function calling and structured JSON output**: well suited for agentic workflows

For most people running on a homelab or a decent desktop, the **E4B** variant is the sweet spot: capable enough to be genuinely useful, lightweight enough to run without a dedicated GPU.

<br>

## What Is OpenClaw?

**OpenClaw** (formerly ClawdBot) is an open-source personal AI assistant that runs on your own machine. Unlike a simple chat UI, it's designed to act as a persistent, autonomous assistant:

* Full access to your file system, shell, and scripts
* Browser automation for web tasks
* **Persistent memory**: remembers context and preferences across sessions
* Accessible through messaging apps including WhatsApp, Telegram, Discord, Slack, Signal, and iMessage
* 50+ pre-built integrations (GitHub, Gmail, Spotify, Obsidian, and more)
* Extensible through a community skill library (ClawHub)

The key differentiator from something like Open WebUI is that OpenClaw is built for autonomous, ongoing use, not just chatting. It runs in the background, handles scheduled tasks, and can reach out to you rather than waiting to be asked.

It supports local models via Ollama, which is where Gemma 4 comes in.

<br>

## Step 1: Install Ollama

Ollama handles downloading and running local models. Install it with the official one-liner:

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Once installed, Ollama runs as a background service accessible at `http://localhost:11434`.

Verify it's running:

```bash
ollama list
```

<br>

## Step 2: Pull Gemma 4

Pull the E4B variant (recommended for most setups):

```bash
ollama pull gemma4:e4b
```

For a higher-quality experience if your hardware can handle it:

```bash
ollama pull gemma4:26b
```

Confirm the model downloaded successfully:

```bash
ollama list
```

Test it quickly from the terminal:

```bash
ollama run gemma4:e4b
```

<br>

## Step 3: Install OpenClaw

OpenClaw can be installed via npm:

```bash
npm install -g openclaw
```

Or via the git-based install for a more customisable setup:

```bash
git clone https://github.com/openclaw-ai/openclaw.git
cd openclaw
npm install
```

<br>

## Step 4: Configure OpenClaw to Use Ollama

On first run, OpenClaw walks you through configuration. When prompted for a model provider, select **Ollama** and point it at your local instance:

```
Provider: Ollama
Base URL: http://localhost:11434
Model: gemma4:e4b
```

This can also be set directly in the OpenClaw config file:

```json
{
  "provider": "ollama",
  "model": "gemma4:e4b",
  "ollamaBaseUrl": "http://localhost:11434"
}
```

<br>

## Step 5: Start OpenClaw

```bash
openclaw start
```

OpenClaw will start in the background. You can interact with it via the CLI:

```bash
openclaw chat
```

Or connect it to a messaging app of your choice through the integrations setup, useful if you want to reach your assistant from your phone without running a separate app.

<br>

## Hardware Expectations

What you can realistically run depends on your hardware:

| Setup | Recommended variant |
|-------|-------------------|
| CPU only (8GB RAM) | E2B |
| CPU only (16GB RAM) | E4B |
| GPU (8GB VRAM) | E4B or 26B MoE |
| GPU (16GB+ VRAM) | 26B MoE or 31B |

Response speed on CPU is slower than GPU, but for a background assistant handling non-time-critical tasks it's perfectly usable.

<br>

## Final Thoughts

Running a capable local AI assistant used to require either expensive cloud bills or painful compromises in model quality. Gemma 4 with Ollama and OpenClaw changes that. You get a genuinely capable model, a persistent assistant that integrates into the tools you already use, and full control over your data: no API keys, no subscriptions, nothing leaving your machine.

If you're already running a homelab, this is a natural addition to the stack.
