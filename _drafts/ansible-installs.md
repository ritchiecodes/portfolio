Nice example 👍 — I’ll turn this into a clear, beginner-friendly **tech blog post** that explains *what Ansible playbooks are*, *how they work*, and *how this specific playbook installs apps on Linux*.

---

# Installing Applications on Linux with Ansible Playbooks

Managing software on Linux machines can get repetitive fast — especially when you’re reinstalling an OS, setting up a new laptop, or configuring multiple systems. **Ansible** solves this problem by letting you describe your system setup *once* and re-apply it anytime.

In this post, we’ll walk through how to use **Ansible playbooks** to install applications on a Linux system using:

* `apt` (Debian/Ubuntu/Parrot OS)
* `snap`
* a custom APT repository (Google Chrome)

All examples are taken from a real-world playbook.

---

## What Is an Ansible Playbook?

An Ansible playbook is a **YAML file** that describes:

* *Which machines* to configure
* *What tasks* to run
* *In what order*

Instead of manually running `apt install`, `snap install`, and repository commands, Ansible automates everything in a **repeatable and idempotent** way (running it twice won’t break anything).

---

## Basic Playbook Structure

Every playbook has a few core components:

```yaml
- name: Descriptive name of the play
  hosts: target machines
  become: true
  tasks:
    - name: Task description
      module:
        options: values
```

Let’s break down the example step by step.

---

## Installing Packages with APT

This first play installs development and desktop tools on **Parrot OS** (or any Debian-based distro).

```yaml
# APT INSTALLS
- name: Install development & desktop tools on Parrot OS
  hosts: localhost
  connection: local
  become: true
```

### Key Points

* `hosts: localhost` → run locally
* `connection: local` → no SSH needed
* `become: true` → run with sudo

---

### Updating the APT Cache

```yaml
    - name: Update apt cache
      apt:
        update_cache: yes
        cache_valid_time: 3600
```

This ensures package lists are up to date.
`cache_valid_time` avoids unnecessary updates if the cache is still fresh.

---

### Installing Multiple APT Packages

```yaml
    - name: Install apt packages
      apt:
        name:
          - snapd
          - freecad
          - mbpfan
          - rsync
          - docker.io
          - git
          - timeshift
          - ruby-full
          - build-essential
          - vlc
          - cifs-utils
        state: present
```

Why this is powerful:

* You install **many packages at once**
* Ansible only installs what’s missing
* No need to worry about already-installed software

---

## Installing Applications with Snap

Snap packages are distro-agnostic and great for desktop apps.

```yaml
# SNAP INSTALLS
    - name: Install snap packages
      snap:
        name:
          - discord
          - drawio
          - arduino
          - pycharm-community
        state: present
        classic: yes
```

### Notes

* `classic: yes` is required for apps like PyCharm
* Ansible automatically handles `snap install` for you
* Works as long as `snapd` is installed (handled earlier)

---

## Installing Software from a Custom APT Repository (Google Chrome)

Some applications aren’t available in default repositories. This second play installs **Google Chrome** properly and securely.

```yaml
- name: Install Google Chrome on Debian-based systems (Parrot OS)
  hosts: localhost
  become: true
  connection: local
```

---

### Create the Keyrings Directory

```yaml
    - name: Ensure keyrings directory exists
      file:
        path: /usr/share/keyrings
        state: directory
        mode: '0755'
```

Modern Debian systems use keyrings instead of the old `apt-key` command.

---

### Download the Google Signing Key

```yaml
    - name: Download Google Linux signing key
      get_url:
        url: https://dl.google.com/linux/linux_signing_key.pub
        dest: /usr/share/keyrings/google-linux-signing-key.gpg
        mode: '0644'
```

This ensures packages from Google can be verified.

---

### Add the Chrome Repository

```yaml
    - name: Add Google Chrome APT repository
      apt_repository:
        repo: >
          deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux-signing-key.gpg]
          http://dl.google.com/linux/chrome/deb/ stable main
        state: present
        filename: google-chrome
```

This tells APT *where* to fetch Chrome from and *which key* to trust.

---

### Install Google Chrome

```yaml
    - name: Install Google Chrome
      apt:
        name: google-chrome-stable
        state: present
        update_cache: true
```

Once the repository exists, Chrome installs like any other package.

---

## Running the Playbook

Save everything into a file, for example:

```bash
setup.yml
```

Run it with:

```bash
ansible-playbook setup.yml
```

That’s it. Ansible handles the rest.

---

## Why Use Ansible for App Installation?

✅ Repeatable setups
✅ Perfect for fresh OS installs
✅ Version-controlled configuration
✅ No manual clicking or remembering commands
✅ Scales from one laptop to hundreds of machines

---

## Final Thoughts

This playbook is a great foundation for a **personal workstation setup** or **dev environment bootstrap**. You can easily extend it by adding:

* Flatpak installs
* Conditional OS checks
* Roles for cleaner organization

Once you start using Ansible for installs, going back to manual setup feels… painful 😄
