---
layout: post
title: "Building a Home Lab with Proxmox and Spare Parts"
tags: [homelab, proxmox, system-admin, virtualisation]
thumbnail: /assets/images/homelab-build/banner.webp
---

Running services at home, whether it's a media server, network tools, or a place to test things without touching production, is a lot more useful with dedicated hardware. For a while I'd been making do with a spare PC sitting in the corner, but moving to a proper hypervisor opened up a lot more possibilities.

I built this lab using older components I already had, which kept the cost down to nearly nothing. The result is a machine running **Proxmox VE** that hosts several virtual machines and containers.

<br>

## Hardware

<!-- Fill in your specs here -->

| Component | Spec |
|-----------|------|
| CPU | |
| Motherboard | |
| RAM | |
| Storage | |
| Case | |
| PSU | |
| NIC | |

The hardware is modest but more than adequate for running a handful of VMs and LXC containers simultaneously. Using parts I had on hand meant I wasn't constrained by a budget, whatever was available is what went in.

<br>

## Why Proxmox?

**Proxmox VE** is a free, open-source hypervisor built on Debian. It supports both **KVM virtual machines** and **LXC containers**, has a clean web UI, and is widely used in the homelab community.

The main alternatives are:
* **VMware ESXi**: feature-rich but licensing has become increasingly restrictive
* **Unraid**: great for NAS-primary builds; less flexible for VMs
* **TrueNAS Scale**: better if storage is the primary use case

For a general-purpose homelab, Proxmox is hard to beat. The community is large, documentation is good, and it's genuinely free.

<br>

## Installing Proxmox

Installation is straightforward. Download the ISO from the Proxmox website, flash it to a USB drive using Balena Etcher or Raspberry Pi Imager, and boot from it.

The installer walks you through:
* Setting the target disk
* Configuring the network (IP, gateway, DNS)
* Setting a root password and admin email

After reboot, the web UI is accessible at:
```
https://[your-ip]:8006
```

> ⚠️ Proxmox uses a self-signed certificate by default. Your browser will warn you, this is expected. Accept the exception to proceed.

<br>

## Post-Install Configuration

A few things worth doing immediately after install:

### Disable the Subscription Nag

Proxmox shows a "no valid subscription" popup on login. This can be removed with a one-line edit:

```bash
sed -i.bak "s/data.status !== 'Active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
systemctl restart pveproxy
```

### Switch to the Free Repository

By default Proxmox points to the enterprise update repository. For a home lab without a subscription, switch to the no-subscription repo:

```bash
# Disable enterprise repo
echo "# deb https://enterprise.proxmox.com/debian/pve bookworm pve-enterprise" > /etc/apt/sources.list.d/pve-enterprise.list

# Add no-subscription repo
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list

apt update && apt dist-upgrade -y
```

<br>

## What's Running

<!-- Fill in your VMs/containers here -->

| VM / Container | Purpose |
|----------------|---------|
| | |
| | |
| | |

<br>

## Storage Layout

<!-- Describe your disk/pool setup -->

<br>

## Final Thoughts

Repurposing older hardware into a Proxmox box is one of the most practical homelab setups you can put together. The flexibility of running both full VMs and lightweight containers on the same host makes it easy to try new things without committing to dedicated hardware for every service.

If you have an old PC gathering dust and want a proper place to run home services, Proxmox is absolutely worth exploring.
