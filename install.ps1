#!/usr/bin/env powershell

# Import the tomli module
Import-Module tomli

# Function to install Chocolatey
function Install-Chocolatey {
  if (-not (Test-Path -Path "$env:SystemDrive\ProgramData\chocolatey" -PathType Container)) {
    # Check if Chocolatey is installed
    if (-not (Test-Path -Path "$env:SystemRoot\System32\choco.exe" -PathType Leaf)) {
      # Install Chocolatey if it's not already installed
      Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
  }
}

# Function to check if winget is available
function Check-WingetAvailability {
  if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Windows Package Manager (winget) is not available on this system."
    exit 1
  }
}

# Function to install packages using Chocolatey
function Install-ChocolateyPackages {
  param (
    [array]$packages
  )

  foreach ($package in $packages) {
    choco install $package -y
  }
}

# Function to install packages using Windows Package Manager (winget)
function Install-WingetPackages {
  param (
    [array]$packages
  )

  foreach ($package in $packages) {
    winget install $package
  }
}

# set script dir
$ScriptDirectory = $PSScriptRoot

# set configs dir
$ConfigsDirectory = "$ScriptDirectory\configs"

# Read the TOML file
$dependencies = Get-Content -Path $ConfigsDirectory\progs.toml | ConvertFrom-Toml

# Install Chocolatey (if not already installed)
Install-Chocolatey

# Check if winget is available
Check-WingetAvailability

# Install Chocolatey packages
Install-ChocolateyPackages -packages $dependencies.choco.progs

# Install winget packages
Install-WingetPackages -packages $dependencies.winget.progs

Copy-Item "$ConfigsDirectory\profile.ps1" $PROFILE.AllUsersAllHosts -Force

# move ahk script
$sourceFile = "$ConfigsDirectory/shortcuts.ahk"
$autostartDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

# Copy the file to the Autostart directory
Copy-Item -Path $sourceFile -Destination $autostartDir
