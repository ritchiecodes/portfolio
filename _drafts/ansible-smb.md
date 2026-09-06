---
layout: post
title: "Automating SMB Share Mounting with Ansible"
tags: [system-admin, ansible, automation]
thumbnail: /assets/images/ansible-smb/banner.webp
---

In the [previous Ansible post](/2026/03/18/ansible-installs), we covered automating software installation on a fresh Linux system. Today we're tackling another time-consuming part of any reinstall: getting your network shares back up and running.

Manually mounting SMB shares every time you rebuild a machine (or worse, having to remember the exact `mount` command syntax) is exactly the kind of repetitive task Ansible was made for. This playbook will install the necessary dependencies, store your credentials securely, create mount points, and configure shares to auto-mount on boot.

<br>

## Prerequisites

This playbook assumes:

* A Debian-based system (Ubuntu, Parrot OS, etc.)
* An SMB/CIFS share accessible on your network (NAS, Windows share, etc.)
* Ansible installed and the previous playbook from this series already run (or `cifs-utils` installed manually)

<br>

## Storing Credentials Securely

Hardcoding credentials into a playbook is a bad idea, especially if you're committing your playbooks to version control. Instead, we'll create a credentials file with restricted permissions.

```yaml
- name: Create SMB credentials file
  copy:
    dest: /etc/samba/credentials
    content: |
      username={{ smb_user }}
      password={{ smb_password }}
    mode: '0600'
    owner: root
    group: root
```

The `0600` permission ensures only root can read the file. Pass the variables at runtime:

```bash
ansible-playbook setup.yml --ask-become-pass -e "smb_user=youruser smb_password=yourpassword"
```

Or store them in an encrypted Ansible Vault file if you prefer everything in source control.

<br>

## The Full Playbook

```yaml
# SMB SHARE MOUNTS
- name: Mount SMB shares on boot
  hosts: localhost
  connection: local
  become: true

  vars:
    smb_shares:
      - name: nas-media
        src: //192.168.1.x/Media
        path: /mnt/nas/media
      - name: nas-backup
        src: //192.168.1.x/Backup
        path: /mnt/nas/backup

  tasks:
    - name: Install cifs-utils
      apt:
        name: cifs-utils
        state: present

    - name: Create SMB credentials file
      copy:
        dest: /etc/samba/credentials
        content: |
          username={{ smb_user }}
          password={{ smb_password }}
        mode: '0600'
        owner: root
        group: root

    - name: Create mount point directories
      file:
        path: "{{ item.path }}"
        state: directory
        mode: '0755'
      loop: "{{ smb_shares }}"

    - name: Mount SMB shares and persist in fstab
      mount:
        path: "{{ item.path }}"
        src: "{{ item.src }}"
        fstype: cifs
        opts: credentials=/etc/samba/credentials,iocharset=utf8,uid=1000,gid=1000,_netdev,x-systemd.automount
        state: mounted
      loop: "{{ smb_shares }}"
```

<br>

## Key Options Explained

### `_netdev`

Tells the system this mount requires the network to be available before mounting. Without this, the mount may fail on boot before networking is initialised.

### `x-systemd.automount`

Creates a systemd automount unit, so the share is mounted on first access rather than at boot. This avoids delays during startup if the NAS takes a moment to come online.

### `uid=1000,gid=1000`

Maps share permissions to your primary user. Replace with your actual UID/GID if different (`id yourusername` will show you).

<br>

## Adding More Shares

The `smb_shares` variable makes it easy to extend. Simply add another entry to the list:

```yaml
smb_shares:
  - name: nas-media
    src: //192.168.1.x/Media
    path: /mnt/nas/media
  - name: nas-backup
    src: //192.168.1.x/Backup
    path: /mnt/nas/backup
  - name: nas-documents
    src: //192.168.1.x/Documents
    path: /mnt/nas/documents
```

Ansible will loop over all entries and handle each one, no need to duplicate tasks.

<br>

## Running the Playbook

```bash
ansible-playbook setup.yml --ask-become-pass -e "smb_user=youruser smb_password=yourpassword"
```

After it completes, your shares will be mounted immediately and will reconnect automatically on every boot.

<br>

## Final Thoughts

This is one of those setups that takes a frustrating amount of time to do manually but runs in under a minute once it's in a playbook. Combined with the software install playbook from the previous post, you're well on your way to a fully automated Linux setup that can be reproduced on any machine with a single command.

In the next Ansible post, we'll look at automating git configuration and SSH key setup, so you're ready to push code the moment a fresh install is done.
