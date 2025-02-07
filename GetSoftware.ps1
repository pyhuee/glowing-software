Write-Host "COOL STUFF GETTIN INSTALLED!!!"
$cwd = Get-Location

# Ensure TLS 1.2 for secure connection
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Define GitHub tools to download (Name, Repo, FilePattern)
$githubTools = @(
    @{
        Name = "Obsidian"
        Repo = "obsidianmd/obsidian-releases"
        FilePattern = "Obsidian-*.exe"
        InstallArgs = "/S"
    },
    @{
        Name = "yt-dlp" 
        Repo = "yt-dlp/yt-dlp"
        FilePattern = "yt-dlp.exe"
        InstallArgs = $null  # No installation needed
    }
)

# Download GitHub-hosted tools
foreach ($tool in $githubTools) {
    Write-Output "`n=== Processing $($tool.Name) ==="
    
    # Get latest release
    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$($tool.Repo)/releases/latest"
    
    # Find matching asset
    $asset = $release.assets | Where-Object { $_.name -like $tool.FilePattern }
    
    if (-not $asset) {
        Write-Warning "No $($tool.Name) installer found!"
        continue
    }

    # Download file
    $outputPath = "$cwd\$($asset.name)"
    Write-Output "Downloading $($asset.name)..."
    Start-BitsTransfer -Source $asset.browser_download_url -Destination $outputPath

    if (Test-Path $outputPath) {
        Write-Output "Download successful: $outputPath"
        
        # Run installer if needed
        if ($tool.InstallArgs) {
            Write-Output "Starting installation..."
            Start-Process $outputPath -ArgumentList $tool.InstallArgs -Wait
        }
    } else {
        Write-Warning "Failed to download $($tool.Name)"
    }
}

# Download GitHub Desktop (non-GitHub API)
Write-Output "`n=== Downloading GitHub Desktop ==="
$ghdPath = "$cwd\GithubDesktop.exe"
Start-BitsTransfer -Source "https://central.github.com/deployments/desktop/desktop/latest/win32" -Destination $ghdPath
if (Test-Path $ghdPath) {
    Write-Output "Starting GitHub Desktop installer..."
    Start-Process $ghdPath
}

# Download VS Code
Write-Output "`n=== Downloading VS Code ===" 
$vscodePath = "$cwd\VSCode.exe"
$vscodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
Start-BitsTransfer -Source $vscodeUrl -Destination $vscodePath
if (Test-Path $vscodePath) {
    Write-Output "Installing VS Code silently..."
    Start-Process $vscodePath -ArgumentList "/SILENT","/CURRENTUSER" -Wait
}

Write-Host "`nALL AWESOME TOOLS ACQUIRED! "