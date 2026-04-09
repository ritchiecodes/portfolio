---
layout: post
title: "Upgrading My Home Network with TP-Link Omada"
tags: [networking, homelab, system-admin]
thumbnail: /assets/images/home-network/banner.webp
---

My home network had been running on consumer gear for years. It worked, but only just — dead spots in parts of the house, no real management visibility, and everything daisy-chained together in a way that made changes painful. When I started running more services on my homelab, it became clear the network needed a proper upgrade.

The plan: replace the existing gear with a **TP-Link Omada** setup, run ethernet to the rooms that needed it, and centralise everything through a managed switch.

<br>

## The New Hardware

| Device | Model |
|--------|-------|
| Router | TP-Link Omada ER605 (3-in-1) |
| Switch | TP-Link 16-port managed switch |
| Access Points | <!-- fill in AP model --> |

The Omada ecosystem is attractive for a home setup because everything is managed through a single controller — either a hardware controller, a software controller running on a server, or TP-Link's cloud option. I'm running the **software controller** on a VM in my Proxmox setup.

<br>

## Planning the Cable Runs

Before touching any hardware, I planned where ethernet needed to go:

<!-- Fill in your cable run details -->

* Living room — for the TV and homelab server
* Office — primary workstation and homelab switch
* [Add other rooms]

Running ethernet through the walls is the part most people put off, and honestly the most satisfying when it's done. A few things that made the job easier:

* A cable fish tape for getting through wall cavities
* A punch-down tool for keystone jacks
* Labelling both ends of every run before patching anything

> ⚠️ If you're not comfortable running cables through walls, a licensed cabler is worth the cost. It's a one-time job and done properly it's invisible.

<br>

## Installing the Hardware

### Router

The Omada ER605 handles routing, firewall, and can terminate a VPN if needed. Setup is straightforward — WAN goes to the ISP modem/ONT, LAN ports connect to the switch.

### Switch

The 16-port managed switch sits at the core of the network. All the wall ethernet runs terminate here, along with the router uplink and the access points.

Having a managed switch means I can:
* Configure VLANs to segment traffic (IoT devices, homelab, main network)
* Set port priorities
* Monitor traffic per port

### Access Points

<!-- Fill in AP placement and mounting details -->

<br>

## Omada Controller Setup

The Omada software controller runs as a service and is accessible through a browser. Once the hardware is adopted into the controller, everything is managed from one place.

Key things I configured:

* **SSIDs** — separate networks for main devices and IoT
* **VLANs** — isolating IoT traffic from the main network
* **DHCP reservations** — fixed IPs for homelab machines and key devices
* **QoS** — prioritising work traffic during the day

The controller also provides per-device traffic stats, which is useful for spotting anything behaving unexpectedly on the network.

<br>

## Before and After

<!-- Add a comparison here once the install is complete -->

The difference in reliability was noticeable immediately. Areas of the house that previously had poor Wi-Fi coverage are now solid, and having wired connections to the homelab means I'm no longer fighting wireless congestion when moving large files around.

<br>

## Final Thoughts

Upgrading a home network is one of those projects that's easy to put off because the old setup technically still works. But once it's done, it's hard to go back. Managed hardware, proper cable runs, and a centralised controller turn your home network from something you forget about into something you actually have visibility and control over.

If you're already running a homelab, pairing it with a managed network setup is a natural next step.
