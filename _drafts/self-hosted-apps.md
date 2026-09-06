---
layout: post
title: "My Favourite Self-Hosted Apps"
tags: [homelab, self-hosted, system-admin]
thumbnail: /assets/images/self-hosted-apps/banner.webp
---

One of the best things about running a homelab is the ability to replace cloud services with self-hosted alternatives: apps you control, running on your own hardware, with no subscriptions or privacy trade-offs.

Over time I've settled on a core set of apps that I genuinely use every day. This post covers my favourites, what they do, and why I keep coming back to them.

<br>

## Immich

**Immich** is a self-hosted photo and video backup solution: think Google Photos, but on your own server. It has a polished mobile app that automatically backs up your camera roll in the background, and a clean web interface for browsing your library.

Features I like:

* Facial recognition and object tagging
* Map view based on photo location data
* Album sharing with other users
* Timeline view that mirrors what you'd expect from a cloud photo app

The mobile app is genuinely good. It's the closest thing to a proper Google Photos replacement I've come across. If protecting your photo library from cloud price increases or privacy concerns is a priority, Immich is the first app I'd recommend.

<br>

## Memos

**Memos** is a lightweight, open-source note-taking app inspired by the simplicity of Twitter-style short notes. It's not trying to be Notion. It's fast, minimal, and focused on capturing thoughts quickly.

I use it for:

* Quick notes and reminders that don't belong in a task manager
* Storing code snippets and references
* Daily journaling

Everything is stored as plain text with Markdown support, and there's a public/private toggle per note. It's self-contained, low-resource, and has a mobile-friendly web interface that works well enough that I don't need a dedicated app.

<br>

## Vikunja

**Vikunja** is a self-hosted task and project management tool. It covers the basics (tasks, due dates, assignees, labels) and organises everything into projects and lists.

What I like about it:

* Clean, fast interface with no bloat
* Kanban and list views
* CalDAV support for syncing tasks to external apps
* No per-seat pricing or feature gating

It's not as feature-heavy as something like Jira, but for personal project tracking and to-do lists it hits the right balance between capable and simple.

<br>

## Plex

**Plex** is the most well-known app on this list. It's a media server that organises your local movie, TV show, and music library and streams it to virtually any device: TV apps, phones, browsers, game consoles.

It handles:

* Automatic metadata fetching (posters, descriptions, ratings)
* Transcoding for devices that can't play the original format
* Remote access so you can stream away from home
* Sharing your library with friends and family

Plex has a free tier and a Plex Pass subscription for additional features like hardware transcoding and offline sync. Even on the free tier it's one of the most polished self-hosted apps available.

<br>

## BookStack

**BookStack** is a self-hosted wiki and documentation platform. It organises content into a hierarchy of **Shelves → Books → Chapters → Pages**, which maps well to how documentation naturally grows over time.

I use it as a personal knowledge base for:

* Homelab documentation and network diagrams
* Runbooks for recurring tasks
* Notes on projects that are too long for Memos

The editor is WYSIWYG with a Markdown mode option, search works well, and it supports image uploads and attachments. If you've ever lost important notes because a free Notion or Confluence account got wiped, having your own BookStack instance is a good answer to that problem.

<br>

## Cloudflared

**Cloudflared** is the odd one out on this list. It's not an app you interact with directly, but it's what makes everything else accessible from outside the home network without opening ports on your router.

It works by creating an outbound tunnel from your server to Cloudflare's edge. Traffic hits your domain, Cloudflare routes it through the tunnel, and your app responds, all without exposing your home IP or punching holes in your firewall.

The benefits:

* No port forwarding required
* Your home IP stays hidden
* Free SSL certificates handled automatically by Cloudflare
* Access controls can be layered on top via Cloudflare Access

It takes a bit of setup the first time, but once it's running it's largely invisible. I'll cover the setup in detail in a future post.

<br>

## Final Thoughts

Self-hosting isn't for everyone. It takes time to set up and you're responsible for keeping things running. But for the apps above, the trade-off is worth it. You get better privacy, no ongoing costs for the core functionality, and the satisfaction of owning your own data.

If you're already running a homelab and haven't explored self-hosted alternatives to the cloud apps you use daily, any of the apps on this list are a good place to start.
