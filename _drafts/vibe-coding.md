---
layout: post
title: "Vibe Coding: Building Software with AI in the Driver's Seat"
tags: [automation, ai, coding]
thumbnail: /assets/images/vibe-coding/banner.webp
---

There's a new way of writing software that's been gaining traction, and it goes by a name that sounds more like a music genre than a development methodology: **vibe coding**.

The idea is simple — instead of writing every line of code yourself, you describe what you want to an AI assistant and let it do the heavy lifting. You steer, review, and iterate. The AI writes. It sounds almost too casual to be taken seriously, but having tried it on a few projects, I think it's genuinely changing how people build software.

<br>

## What Is Vibe Coding?

The term was coined by Andrej Karpathy in early 2025 to describe a coding style where you lean heavily on AI — not just for autocomplete or the occasional Stack Overflow replacement, but for entire features, files, and sometimes whole projects.

You describe what you want in plain language. The AI produces code. You read it, test it, tweak the prompt, and go again. The focus shifts from *writing* code to *directing* it.

It's less about syntax and more about having a clear picture of what you're trying to build.

<br>

## Tools of the Trade

The most popular tools for vibe coding right now are:

* **Claude Code** — Anthropic's AI coding assistant that runs in the terminal and has full access to your codebase
* **Cursor** — An AI-first code editor built on VS Code
* **GitHub Copilot** — Microsoft's inline AI assistant integrated into most major editors
* **Windsurf** — Another AI-native editor gaining traction

I've been using Claude Code for most of my recent projects. Running in the terminal, it can read files, make edits, run commands, and work through multi-step tasks with minimal hand-holding.

<br>

## A Real Example

For the [password sync app](/2026/02/18/password-sync-app) I wrote about earlier, I used AI assistance throughout the build. Rather than starting from scratch or hunting through documentation, I described what I needed — a Python script that reads from one source and syncs credentials to another — and worked iteratively from there.

The AI doesn't always get it right on the first attempt. But the back-and-forth of refining a prompt and reviewing the output is often faster than writing the solution from scratch, especially for boilerplate-heavy tasks.

<br>

## Where It Works Well

Vibe coding shines in a few specific scenarios:

* **Boilerplate-heavy tasks** — Setting up project structure, config files, CRUD operations
* **Unfamiliar languages or frameworks** — You know *what* you want, just not the exact syntax
* **Scripting and automation** — Small scripts that do one thing well
* **Rapid prototyping** — Getting something working quickly to test an idea

The AI is particularly good at tasks that have clear requirements and well-established patterns. The more specific your prompt, the better the output.

<br>

## Where It Falls Short

It's not a silver bullet. There are situations where vibe coding slows you down more than it helps:

* **Novel or complex logic** — AI struggles with problems that don't have obvious precedent in its training data
* **Highly specific business logic** — If the context lives entirely in your head, the AI can't fill in the gaps
* **Large, interconnected codebases** — Without full context, AI suggestions can introduce subtle bugs
* **Security-sensitive code** — Always review AI-generated code that handles auth, user data, or external APIs carefully

The model is also confident even when it's wrong. You still need to understand what the code is doing — vibe coding rewards people who already know how to code, not necessarily those who are learning.

<br>

## A New Kind of Skill

What's interesting about vibe coding is that it's shifting what skills matter most. Writing clean, fast code from memory is less important than being able to:

* Break a problem into clear, concrete requirements
* Evaluate whether generated code actually solves the problem
* Know when to push back on a suggestion and try a different approach
* Understand the output well enough to debug it

In a lot of ways it rewards the engineering mindset more than any particular language fluency.

<br>

## Final Thoughts

Vibe coding isn't going to replace software engineers — but it's already changing what a solo developer or a small team can ship in a weekend. Projects that would have taken weeks are getting done in days. That's a meaningful shift.

If you haven't tried leaning into AI tooling for a real project, it's worth the experiment. Pick something small, describe what you want clearly, and see how far you get before you need to take the wheel yourself.
