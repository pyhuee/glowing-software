# Glowing Software Installation

This script will install the applications I want on my computer at school when they wipe it weekly.

## Software Installed

- **Obsidian**
- **yt-dlp**
- **GitHub Desktop**
- **Visual Studio Code**

## How to Run

To set the execution policy, download the script, and execute it, use the following PowerShell command:

```powershell
Set-ExecutionPolicy Bypass -Scope CurrentUser; Invoke-WebRequest -Uri "https://github.com/pyhuee/glowing-software/raw/main/GetSoftware.ps1" -OutFile "GetSoftware.ps1"; ./GetSoftware.ps1
