---
layout: post
title: "Automating Legacy Workflows Without API Access"
tags: [automation, python]
thumbnail: /assets/images/account-automation/automation-with-python.webp
---

Anyone who has ever had to manually create dozens—or hundreds—of accounts in a legacy system knows how painful the process can be:

* Open the application
* Click the same fields
* Copy values from a spreadsheet
* Paste, submit, repeat

When there’s **no API**, no bulk import feature, and no automation hooks, this kind of work quickly turns into a massive time sink.

I encountered this exact challenge in a previous role at a large organisation. While we had strong automation around Active Directory provisioning, many third-party applications offered no programmatic way to create or manage user accounts. Each request required manual intervention through a GUI.

I wasn’t willing to spend hours every week performing repetitive clicks when a more efficient solution was possible.

Enter **Python**.

Python’s reputation for automation and data handling is well earned, and in this post I’ll walk through how to automate a UI-driven task—**account creation in software without API access**—using `pyautogui` and a few supporting libraries.

> ⚠️ **Important**
> Only automate systems you are authorised to use in this way. Always follow company policies, vendor license agreements, and local laws.

<br>

## Why UI Automation?

UI automation is rarely the *ideal* solution—but sometimes it’s the **only** viable one.

Common scenarios include:

* Internal tools built years ago with no integration options
* Vendor software that exposes no APIs
* Temporary migrations or backfill operations
* One-off or low-frequency bulk tasks

When rewriting the application or negotiating API access isn’t realistic, UI automation can save hours of repetitive work and significantly reduce human error.

<br>

## High-Level Approach

At a high level, the automation workflow looks like this:

1. Read account data from a spreadsheet
2. Copy values to the clipboard
3. Click predefined screen locations
4. Paste data into form fields
5. Submit the form and move to the next account

To achieve this, we’ll use:

* **`pyautogui`** – Mouse and keyboard automation
* **`pyperclip`** – Reliable clipboard interaction
* **`pandas`** – Spreadsheet parsing

<br>

## Installing Dependencies

```bash
pip install pyautogui pyperclip pandas openpyxl
```

> Note: You may need to grant accessibility or input permissions for automation to work—particularly on macOS. These examples were developed and tested on Windows.

<br>

## Preparing the Spreadsheet

Assume a simple Excel file (`accounts.xlsx`) with the following structure:

| username | email                                           | role  |
| -------- | ----------------------------------------------- | ----- |
| jdoe     | [jdoe@example.com](mailto:jdoe@example.com)     | admin |
| asmith   | [asmith@example.com](mailto:asmith@example.com) | user  |

This file acts as the source of truth for the automation.

<br>

## Capturing Screen Coordinates

Before writing any automation code, you need to identify **where the script should click**.

Run the following snippet and hover your mouse over each input field:

```python
import pyautogui
print(pyautogui.position())
```

Record the screen coordinates for each interaction. This step typically involves some trial and error.

> ⚠️ Screen resolution matters. Coordinates captured at 1920×1080 will not align correctly on a 4K display.

### Example Coordinates

```python
USERNAME_FIELD = (420, 310)
EMAIL_FIELD    = (420, 360)
ROLE_FIELD     = (420, 410)
SUBMIT_BUTTON  = (500, 480)
```

<br>

## The Automation Script

Below is a simplified example based on a real script I used in production:

```python
import pyautogui
import pyperclip
import pandas as pd

# Emergency stop: move mouse to top-left corner
pyautogui.FAILSAFE = True

# Load spreadsheet
file_path = 'bulkaccount.xlsx'
sheet_name = 'Sheet1'
df = pd.read_excel(file_path, sheet_name=sheet_name)

# Loop through non-empty usernames
for username in df['username'].dropna():

    pyperclip.copy(str(username))

    # ---- UI AUTOMATION ----
    # Open "New Account"
    pyautogui.click(750, 300)
    pyautogui.moveTo(1700, 280, duration=1)
    pyautogui.click(1700, 280)

    pyautogui.sleep(0.5)

    # Paste username
    pyautogui.hotkey('ctrl', 'v')

    pyautogui.moveTo(1250, 430)
    pyautogui.click(1250, 430)

    pyautogui.sleep(10)

    # Submit account creation
    pyautogui.moveTo(1050, 150, duration=1)
    pyautogui.doubleClick(1050, 150)

    pyautogui.sleep(2)

print("✅ Finished all usernames")
```

While my production script included additional logic for error handling and multiple fields, this example demonstrates the core mechanics required to automate most UI-based workflows.

<br>

## Making UI Automation More Robust

UI automation can be fragile if not handled carefully. The following practices help improve reliability:

### Add Delays

UI response times vary. Always assume the application is slower than your code—especially with web-based interfaces.

### Use Failsafes

Setting `pyautogui.FAILSAFE = True` allows you to abort the script instantly by moving the mouse to the top-left corner of the screen.

### Test With Dummy Data

Never start with production accounts. Validate the entire workflow using test or non-existent accounts first.

### Lock Down Your Environment

Consistency is critical:

* Same screen resolution
* Same window position
* Same zoom level

Any deviation can break coordinate-based automation.

<br>

## Limitations of UI Automation

While powerful, UI automation has clear drawbacks:

* Breaks if the UI layout changes
* Highly sensitive to screen resolution and scaling
* More difficult to debug than API-based solutions
* Unsuitable for high-frequency or real-time automation

Treat it as a **practical workaround**, not a long-term architectural solution.

<br>

## Final Thoughts

When APIs aren’t available, UI automation can transform hours of repetitive work into a one-time scripting effort that runs in minutes.

Tools like `pyautogui` allow engineers to:

* Reduce human error
* Eliminate repetitive tasks
* Extend automation into legacy or closed systems

Used carefully, ethically, and as a last resort, UI automation can deliver significant productivity gains—even in environments that were never designed to be automated.