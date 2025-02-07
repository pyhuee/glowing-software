Write-Host "COOL STUFF GETTIN INSTALLED!!!"
# can you fetch the current working directory, and set the output path to the current working directory?
$cwd = Get-Location

# Ensure TLS 1.2 for secure connection
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Fetch the latest release JSON from GitHub API
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest"

# Find the Windows .exe installer in the assets
$exeAsset = $release.assets | Where-Object { $_.name -like "Obsidian-*.exe" }

if (-not $exeAsset) {
    Write-Error "No Windows installer found in the latest release."
    exit 1
}

# Define the output path for the downloaded file
$outputPath = "$cwd\$($exeAsset.name)"

# Use BITS to download the file
Start-BitsTransfer -Source $exeAsset.browser_download_url -Destination $outputPath

# Check if the download was successful
if (Test-Path $outputPath) {
    Write-Output "Success! Downloaded latest Obsidian installer to: $outputPath"
} else {
    Write-Error "Download failed. Please check your network connection or try again."
}

# Start the installer process (for obsidian)
Start-Process $outputPath -ArgumentList "/S" #installs silently 😃


# Getting Github
Write-Output "Downloading Github Desktop"
Start-BitsTransfer -Source https://central.github.com/deployments/desktop/desktop/latest/win32 -Destination $cwd\GithubDesktop.exe
Write-Output "Starting Installer for Github!"
Start-Process $cwd\GithubDesktop.exe

# Getting VS Code https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user
Write-Output "Fetching VS Code"
Start-BitsTransfer -Source https://code.visualstudio.com/sha/download?build=stable"&"os=win32-x64-user -Destination $cwd\VSCode.exe
Start-Process $cwd\VSCode.exe -ArgumentList "/silent","/currentuser"
