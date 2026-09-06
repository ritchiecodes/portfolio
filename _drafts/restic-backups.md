---
layout: post
title: "Automated Backups with Restic"
tags: [system-admin, backup, linux, automation]
thumbnail: /assets/images/restic-backups/banner.webp
---

Backups are one of those things everyone knows they should have but few people actually set up properly. **Restic** is the tool that finally made me do it. It's fast, encrypted by default, cross-platform, and dead simple to automate.

This post walks through everything you need to get a solid backup setup running: initialising a repository, backing up locally and over SFTP, checking and restoring snapshots, pruning old data, and wiring it all together into an automated script.

<br>

## Installing Restic

On Debian/Ubuntu:

```bash
sudo apt install restic
```

Or grab the latest binary directly from GitHub for the most up-to-date version:

```bash
wget https://github.com/restic/restic/releases/latest/download/restic_linux_amd64.bz2
bunzip2 restic_linux_amd64.bz2
chmod +x restic_linux_amd64
sudo mv restic_linux_amd64 /usr/local/bin/restic
```

Verify the install:

```bash
restic version
```

<br>

## Initialising a Repository

A restic repository is where your backups are stored. It can live on a local disk, a network share, or a remote server. All repositories are encrypted. You'll set a password on initialisation that's required for every operation.

### Local Repository

```bash
restic init --repo /mnt/backup/myrepo
```

### SFTP Repository

To back up over SFTP, restic uses SSH under the hood. Make sure you have SSH key-based access to the remote server (password prompts will break automation).

```bash
restic init --repo sftp:user@hostname:/path/to/repo
```

Restic will prompt for a new repository password. Store this somewhere safe. **Without it, your backups cannot be restored.**

<br>

## Setting Environment Variables

Typing the repository path and password on every command gets old fast. Set them as environment variables instead:

```bash
export RESTIC_REPOSITORY="sftp:user@hostname:/path/to/repo"
export RESTIC_PASSWORD="your-repository-password"
```

With these set, you can drop the `--repo` and `--password` flags from every command. The automation script at the end of this post handles this properly.

<br>

## Backing Up Files

### Basic Backup

```bash
restic backup /home/user/documents
```

### Multiple Paths

```bash
restic backup /home/user/documents /home/user/projects /etc
```

### Excluding Paths

```bash
restic backup /home/user --exclude="/home/user/.cache" --exclude="*.tmp"
```

### Excluding Paths from a File

For more complex exclusions, put patterns in a file and reference it:

```bash
restic backup /home/user --exclude-file=/etc/restic/excludes.txt
```

Example `excludes.txt`:

```
.cache
node_modules
*.log
*.tmp
__pycache__
.DS_Store
```

Restic is **incremental**: only data that has changed since the last snapshot is uploaded. First backups take longest; subsequent ones are typically fast.

<br>

## Backing Up Over SFTP

SFTP backups work identically to local ones once the repository is initialised, just point the `RESTIC_REPOSITORY` variable at your SFTP path.

A few things that make SFTP backups reliable:

**Use SSH key authentication.** Password-based SSH will break automated backups. Generate a key if you haven't already and copy it to the remote host:

```bash
ssh-keygen -t ed25519 -C "restic-backup"
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@hostname
```

**Specify the SSH key in your config.** Add an entry to `~/.ssh/config` to ensure restic always uses the right key:

```
Host backup-server
    HostName hostname-or-ip
    User user
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
```

Then use the alias in your repository path:

```bash
export RESTIC_REPOSITORY="sftp:backup-server:/path/to/repo"
```

`ServerAliveInterval 60` keeps the connection alive during large transfers and prevents timeouts.

<br>

## Checking Snapshots

List all snapshots in the repository:

```bash
restic snapshots
```

Output looks like:

```
ID        Time                 Host        Tags        Paths
-----------------------------------------------------------------------
a1b2c3d4  2026-04-01 02:00:00  myhostname              /home/user/documents
e5f6g7h8  2026-04-02 02:00:00  myhostname              /home/user/documents
```

Each snapshot has a unique ID. You'll use these IDs when restoring.

### Browsing a Snapshot

To see what's inside a specific snapshot without restoring it:

```bash
restic ls a1b2c3d4
```

### Searching for a File Across Snapshots

```bash
restic find filename.txt
```

<br>

## Restoring Backups

### Restore an Entire Snapshot

```bash
restic restore a1b2c3d4 --target /tmp/restore
```

This restores the snapshot to `/tmp/restore`. Use `latest` to restore the most recent snapshot:

```bash
restic restore latest --target /tmp/restore
```

### Restore Specific Files or Folders

```bash
restic restore latest --target /tmp/restore --include /home/user/documents/important.pdf
```

### Restore to the Original Location

```bash
restic restore latest --target /
```

> ⚠️ Restoring to `/` will overwrite existing files with the versions from the snapshot. Test in a temporary directory first.

<br>

## Forget and Prune

Over time, snapshots accumulate. `forget` removes snapshot references according to a retention policy, and `prune` deletes the data that no longer belongs to any snapshot.

### Forget with a Retention Policy

```bash
restic forget \
  --keep-daily 7 \
  --keep-weekly 4 \
  --keep-monthly 12 \
  --keep-yearly 2
```

This keeps:
* One snapshot per day for the last 7 days
* One per week for the last 4 weeks
* One per month for the last 12 months
* One per year for the last 2 years

`forget` on its own only removes snapshot references. The actual data remains in the repository until you run `prune`.

### Prune Unreferenced Data

```bash
restic prune
```

### Forget and Prune in One Step

```bash
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 2 --prune
```

### Check Repository Integrity

After pruning, it's good practice to verify the repository is intact:

```bash
restic check
```

<br>

## Automation Script

The following script ties everything together. It runs a backup, applies the retention policy, prunes old data, and logs output with timestamps. It's designed to run unattended via cron on Linux or Task Scheduler on Windows.

```bash
#!/bin/bash

# ─── Configuration ────────────────────────────────────────────────────────────
export RESTIC_REPOSITORY="sftp:backup-server:/path/to/repo"
export RESTIC_PASSWORD="your-repository-password"

BACKUP_PATHS="/home/user/documents /home/user/projects /etc"
EXCLUDE_FILE="/etc/restic/excludes.txt"
LOG_FILE="/var/log/restic-backup.log"

# Retention policy
KEEP_DAILY=7
KEEP_WEEKLY=4
KEEP_MONTHLY=12
KEEP_YEARLY=2
# ──────────────────────────────────────────────────────────────────────────────

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting backup"

# Run backup
restic backup $BACKUP_PATHS --exclude-file="$EXCLUDE_FILE" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    log "Backup completed successfully"
else
    log "ERROR: Backup failed"
    exit 1
fi

# Forget old snapshots and prune
log "Applying retention policy and pruning"
restic forget \
    --keep-daily $KEEP_DAILY \
    --keep-weekly $KEEP_WEEKLY \
    --keep-monthly $KEEP_MONTHLY \
    --keep-yearly $KEEP_YEARLY \
    --prune >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    log "Forget and prune completed"
else
    log "ERROR: Forget/prune failed"
    exit 1
fi

log "Backup job finished"
```

Save it to `/usr/local/bin/restic-backup.sh` and make it executable:

```bash
chmod +x /usr/local/bin/restic-backup.sh
```

### Scheduling with Cron (Linux)

Run at 2am every day:

```bash
crontab -e
```

Add:

```
0 2 * * * /usr/local/bin/restic-backup.sh
```

### Scheduling with Task Scheduler (Windows)

1. Open Task Scheduler
2. Create a new Basic Task
3. Set the trigger to **Daily** at your preferred time
4. Set the action to run the script (use a `.bat` wrapper if needed)

<br>

## A Foolproof Solution: Combining Restic with Rsync

Restic handles versioned, encrypted snapshots well, but for a truly belt-and-braces setup, it's worth also mirroring your restic repository to a second remote location using **rsync**. This gives you two independent copies: one on your primary backup target and one offsite, without needing to run a full restic backup twice.

The idea is simple: restic writes its encrypted repository to a local or primary remote location, then rsync copies that entire repository directory to a second destination. Because restic's repository is just a directory of files, rsync can sync it efficiently, only transferring what has changed since the last sync.

### Rsync to a Remote Server Over SSH

```bash
rsync -avz --delete /mnt/backup/myrepo/ user@offsite-server:/backup/myrepo/
```

Key flags:
* `-a`: archive mode, preserves permissions, timestamps, and symlinks
* `-v`: verbose output
* `-z`: compress data during transfer
* `--delete`: removes files from the destination that no longer exist in the source, keeping the mirror in sync

> ⚠️ The trailing slash on the source path (`myrepo/`) is important, it tells rsync to sync the *contents* of the directory rather than the directory itself.

### Rsync Automation Script

Rather than bolting this onto the restic script, keeping it separate makes both scripts easier to maintain and lets you schedule them independently:

```bash
#!/bin/bash

# ─── Configuration ────────────────────────────────────────────────────────────
RESTIC_REPO_PATH="/mnt/backup/myrepo"
OFFSITE_USER="user"
OFFSITE_HOST="offsite-server"
OFFSITE_PATH="/backup/myrepo"
LOG_FILE="/var/log/rsync-backup.log"
# ──────────────────────────────────────────────────────────────────────────────

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting rsync to offsite"

rsync -az --delete "$RESTIC_REPO_PATH/" "$OFFSITE_USER@$OFFSITE_HOST:$OFFSITE_PATH/" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    log "Rsync completed successfully"
else
    log "ERROR: Rsync failed"
    exit 1
fi
```

Save it to `/usr/local/bin/rsync-backup.sh` and make it executable:

```bash
chmod +x /usr/local/bin/rsync-backup.sh
```

Schedule it shortly after the restic script, for example if restic runs at 2am, run rsync at 3am to give the backup time to complete:

```
0 2 * * * /usr/local/bin/restic-backup.sh
0 3 * * * /usr/local/bin/rsync-backup.sh
```

### Why This Works

The result is a **3-2-1 backup strategy**, the gold standard for data protection:

* **3** copies of your data
* **2** different storage media or locations
* **1** offsite copy

Restic provides the versioning, encryption, and deduplication. Rsync provides the offsite redundancy. If your primary backup target fails, the rsync mirror is an intact restic repository that can be used for restoration immediately.

<br>

## Final Thoughts

Restic removes most of the friction that comes with setting up backups. Encryption is automatic, deduplication means you're not storing redundant data, and the retention policy system gives you fine-grained control over how long snapshots are kept without the repository growing unbounded.

Pair it with rsync to an offsite location and you have a resilient, automated backup setup that follows best practices, all without paying for a managed backup service.
