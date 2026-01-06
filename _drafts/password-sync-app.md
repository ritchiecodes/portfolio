# Verifying Password Sync Between Two Active Directory Domains with PowerShell

In multi-domain or hybrid Active Directory environments, one common operational question comes up again and again:

> **“Are passwords actually syncing between these two domains?”**

Whether you’re using trust relationships, synchronization tools, or identity management solutions, a quick and reliable way to validate password synchronization is by comparing the **`PasswordLastSet`** timestamp for the same user across domains.

This post walks through how to write a **PowerShell script** that checks the password last set date and time between two domains and determines whether they are in sync.

---

## Why `PasswordLastSet`?

Active Directory stores the time a user’s password was last changed in the attribute:

```powershell
PasswordLastSet
```

If passwords are syncing correctly:

* The timestamps should be **identical** or
* Within an **acceptable time window** (seconds or minutes, depending on your sync process)

If they differ significantly, it’s a strong indicator of a sync issue.

---

## Prerequisites

Before you begin, ensure:

* You have the **ActiveDirectory PowerShell module** installed
* You have **read access** to both domains
* DNS and trust relationships are correctly configured
* You know the **domain controllers** or domain names for both environments

Import the module:

```powershell
Import-Module ActiveDirectory
```

---

## Defining the Domains

For clarity, explicitly define the two domains you’re comparing.

```powershell
$DomainA = "corp.domainA.local"
$DomainB = "corp.domainB.local"
```

You can also specify particular domain controllers if needed:

```powershell
$DC_A = "dc1.domainA.local"
$DC_B = "dc1.domainB.local"
```

---

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
$Username = "jdoe"

$PwdSetA = Get-PasswordLastSet -Username $Username -Server $DomainA
$PwdSetB = Get-PasswordLastSet -Username $Username -Server $DomainB

Write-Host "Domain A PasswordLastSet: $PwdSetA"
Write-Host "Domain B PasswordLastSet: $PwdSetB"
```

---

## Handling Time Differences Gracefully

Exact timestamp matches aren’t always realistic. A small delay may be expected.

Here’s how to calculate the difference:

```powershell
$TimeDifference = ($PwdSetA - $PwdSetB).Duration()

if ($TimeDifference.TotalMinutes -le 5) {
    Write-Host "✅ Passwords appear to be in sync"
} else {
    Write-Host "❌ Passwords are NOT in sync"
}
```

You can adjust the threshold based on your environment’s sync behavior.

---

## Checking Multiple Users at Once

To scale this check, you can loop through a list of users:

```powershell
$Users = @("jdoe", "asmith", "mbrown")

foreach ($User in $Users) {
    $A = Get-PasswordLastSet -Username $User -Server $DomainA
    $B = Get-PasswordLastSet -Username $User -Server $DomainB

    $Diff = ($A - $B).Duration()

    [PSCustomObject]@{
        User              = $User
        DomainA_LastSet   = $A
        DomainB_LastSet   = $B
        DifferenceMinutes = [math]::Round($Diff.TotalMinutes, 2)
        InSync            = ($Diff.TotalMinutes -le 5)
    }
}
```

This produces clean, report-ready output.

---

## Common Gotchas

### Time Synchronization

If domain controllers aren’t time-synced (NTP issues), your results may be misleading.

### Password Writeback Delays

Some sync solutions update attributes asynchronously—short mismatches may be normal.

### Replication Latency

If you query different DCs, replication delays can cause temporary differences.

---

## When This Approach Works Best

This method is ideal for:

* Troubleshooting password sync issues
* Validating migrations
* Spot-checking identity synchronization
* Operational monitoring scripts

It’s not a replacement for full identity monitoring—but it’s an excellent **first diagnostic step**.

---

## Final Thoughts

PowerShell makes it easy to validate password synchronization using native Active Directory attributes. By comparing `PasswordLastSet` across domains, you gain a quick, reliable signal that helps confirm whether your identity infrastructure is behaving as expected.

Sometimes the simplest checks uncover the biggest problems.

---