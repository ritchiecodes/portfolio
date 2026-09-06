---
layout: post
title: "Automating Git and SSH Key Setup with Ansible"
tags: [system-admin, ansible, automation, git]
thumbnail: /assets/images/ansible-git/banner.webp
---

If you've been following this Ansible series, you've already automated [software installation](/2026/03/18/ansible-installs) and [SMB share mounting](/ansible-smb). Today we're covering something every developer needs sorted immediately after a fresh install: git configuration and SSH keys.

Setting up git and generating SSH keys is quick to do manually, but when you factor in copying keys to GitHub, configuring your SSH config file, and getting your global git settings right, it adds up. This playbook handles all of it in one run.

<br>

## What We're Automating

* Installing git
* Setting global git configuration (name, email, default branch)
* Generating an SSH key pair
* Writing an SSH config entry for GitHub
* Displaying the public key ready to paste into GitHub

<br>

## The Playbook

```yaml
# GIT AND SSH SETUP
- name: Configure Git and SSH keys
  hosts: localhost
  connection: local

  vars:
    git_user_name: "Your Name"
    git_user_email: "you@example.com"
    ssh_key_path: "{{ ansible_env.HOME }}/.ssh/id_ed25519"

  tasks:
    - name: Install git
      apt:
        name: git
        state: present
      become: true

    - name: Set git global username
      git_config:
        name: user.name
        scope: global
        value: "{{ git_user_name }}"

    - name: Set git global email
      git_config:
        name: user.email
        scope: global
        value: "{{ git_user_email }}"

    - name: Set default branch to main
      git_config:
        name: init.defaultBranch
        scope: global
        value: main

    - name: Generate SSH key (ed25519)
      openssh_keypair:
        path: "{{ ssh_key_path }}"
        type: ed25519
        comment: "{{ git_user_email }}"
        state: present

    - name: Ensure ~/.ssh/config exists
      file:
        path: "{{ ansible_env.HOME }}/.ssh/config"
        state: touch
        mode: '0600'

    - name: Add GitHub SSH config entry
      blockinfile:
        path: "{{ ansible_env.HOME }}/.ssh/config"
        marker: "# {mark} ANSIBLE MANAGED - GitHub"
        block: |
          Host github.com
            HostName github.com
            User git
            IdentityFile {{ ssh_key_path }}
            AddKeysToAgent yes

    - name: Display public key
      command: cat "{{ ssh_key_path }}.pub"
      register: public_key

    - name: Print public key
      debug:
        msg: "{{ public_key.stdout }}"
```

<br>

## Running the Playbook

Update the `vars` block with your name and email, then run:

```bash
ansible-playbook setup.yml --ask-become-pass
```

At the end of the run, Ansible will print your public key. Copy it and add it to your GitHub account under **Settings → SSH and GPG keys → New SSH key**.

<br>

## Why ed25519?

`ed25519` is the recommended key type for new SSH key generation. It's faster and more secure than the older RSA format, and produces a much shorter key. GitHub, GitLab, and most modern SSH servers support it.

<br>

## Verifying the Setup

Once the key is added to GitHub, test the connection:

```bash
ssh -T git@github.com
```

You should see:

```
Hi yourusername! You've successfully authenticated, but GitHub does not provide shell access.
```

<br>

## Extending the Playbook

If you use multiple Git hosting providers, you can add additional SSH config entries using the same `blockinfile` task:

```yaml
- name: Add GitLab SSH config entry
  blockinfile:
    path: "{{ ansible_env.HOME }}/.ssh/config"
    marker: "# {mark} ANSIBLE MANAGED - GitLab"
    block: |
      Host gitlab.com
        HostName gitlab.com
        User git
        IdentityFile {{ ssh_key_path }}
        AddKeysToAgent yes
```

<br>

## Final Thoughts

With this playbook added to your setup, a fresh Linux install goes from bare system to fully authenticated git environment in minutes. Combined with the software install and SMB mount playbooks from earlier in this series, you have a solid foundation for a fully automated workstation setup.
