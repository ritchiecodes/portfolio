---
layout: post
title: "Domain Migration Password Tool"
tags: [active-directory, system-admin]
thumbnail: /assets/images/password-sync-app/password-sync-app.png
date: 2026-02-18
---

Many of us have experienced it before, a branch or company needs to be migrated into your domain or maybe even seperating a bunch of companies under one domain into their own. Whatever the reason may be, it comes with a large set of challenges that can be difficult to navigate.

In my case, the company I worked for were under an AD forest that was shared between multiple organisations. Despite having control of our domain, at times we were still at the mercy of any policies or changes made by the host organisation.

So, it was time for us to migrate everyone and everything onto our own servers, completely segregated from the other domains. This had a number of benefits, we would have more control over our own resources and not have to worry about someone external wreaking havoc due to a change we were not notified about.

The issue, our organisation managed over 10,000 users, 6,000 computers (not including servers) and runs 24 hours a day, 7 days a week. This process wasn't something that could be done over a weekend. The migration was set to be done over a period of at least 12 months.

I'm not going to go over the entire migration process today, as that would probably be the length of a Harry Potter book. Instead, I will show you a neat little tool I created with Powershell to assist our Help Desk team as they navigated user login issues throughout the year long migration.

During an Active Directory domain migration or even a Multi-Domain setup, one common operational question comes up again and again:

> **“Are passwords actually syncing between these two domains?”**

Whether you’re using trust relationships, synchronization tools, or identity management solutions, I found that a quick and reliable way to validate password synchronization is by comparing the **`PasswordLastSet`** timestamp for the same user across domains.

Today, I will walk through a simple **PowerShell script** I created that checks the password last set date and time between two domains to determine whether they are in sync.

<br>

## Why `PasswordLastSet`?

Active Directory stores the time a user’s password was last changed in the attribute:

```powershell
PasswordLastSet
```

If passwords are syncing correctly:

* The timestamps should be **identical** or
* Within an **acceptable time window** (dependent on your enivronments sync process)

If they differ significantly, it’s a strong indicator of a sync issue.

<br>

## Prerequisites

Before you begin, ensure:

* You have the **ActiveDirectory PowerShell module** installed
* You have **read access** to both domains
* You know the **domain controllers** or domain names for both environments

Import the module:

```powershell
Import-Module ActiveDirectory
```

<br>

## Defining the Domains

For clarity, explicitly define the two domains you’re comparing.

```powershell
$DomainA = "corp.domainA.local"
$DomainB = "corp.domainB.local"
```

<br>

## Fetching the PasswordLastSet Value

The following function retrieves the password last set timestamp for a given user in a specific domain:

```powershell
function Get-PasswordLastSet {
    param (
        [string]$Username,
        [string]$Server
    )

    Get-ADUser -Identity $Username `
               -Server $Server `
               -Properties PasswordLastSet |
    Select-Object -ExpandProperty PasswordLastSet
}
```

---

## Comparing Password Timestamps Between Domains

Now let’s put it together.

```powershell
$Username = Read-Host "Enter Username"

$PwdSetA = Get-PasswordLastSet -Username $Username -Server $DomainA
$PwdSetB = Get-PasswordLastSet -Username $Username -Server $DomainB

Write-Host "Domain A PasswordLastSet: $PwdSetA"
Write-Host "Domain B PasswordLastSet: $PwdSetB"
```

---

## Checking Multiple Users at Once

To scale this check, you can loop through a list of users:

```powershell
$Users = @("jdoe", "asmith", "mbrown")

foreach ($User in $Users) {
    $A = Get-PasswordLastSet -Username $User -Server $DomainA
    $B = Get-PasswordLastSet -Username $User -Server $DomainB

    [PSCustomObject]@{
        User              = $User
        DomainA_LastSet   = $A
        DomainB_LastSet   = $B
    }
}
```

This produces a clean, report-ready output.


## Final Thoughts

PowerShell makes it easy to validate password synchronization using native Active Directory attributes. By comparing `PasswordLastSet` across domains, you gain a quick, reliable signal that can confirm the potential reason for login issues.