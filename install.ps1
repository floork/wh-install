#!/usr/bin/env powershell

# Define the path to the script directory
$ScriptDirectory = $PSScriptRoot

# Define the path to the configs directory
$ConfigsDirectory = Join-Path -Path $ScriptDirectory -ChildPath "configs"

# Get the installed PowerShell version
$psVersion = $PSVersionTable.PSVersion

# Define the minimum required version (required for PSTiml)
$minVersion = [version]'7.2'

# Check if the installed version is equal to or greater than the minimum required version
if ($psVersion -ge $minVersion) {
  Write-Host "✓ PowerShell version $($psVersion.ToString()) is equal to or newer than 7.2."
}
else {
  Write-Host "✘ PowerShell version $($psVersion.ToString()) is older than 7.2. Please update PowerShell."
  exit 1  # Exit the script with a non-zero exit code to indicate an error.
}

# Function to check if PSToml module is installed and install it if necessary
function Ensure-PSTomlModule {
  $moduleName = "PSToml"
  if (-not (Get-Module -Name $moduleName -ListAvailable)) {
    Write-Host "Installing $moduleName module..."
    Install-Module -Name $moduleName -Scope CurrentUser -Force
  }
}

# Call the function to ensure PSToml module is installed
Ensure-PSTomlModule

try {
  # Attempt to import the "tomli" module
  Import-Module -Name PSToml

  # Attempt to parse TOML content
  $dependencies = Get-Content -Path (Join-Path -Path $ConfigsDirectory -ChildPath "progs.toml") | ConvertFrom-Toml
}
catch {
  Write-Error "An error occurred: $($_.Exception.Message)"
  exit 1
}

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

# Install Chocolatey (if not already installed)
Install-Chocolatey

# Check if winget is available
Check-WingetAvailability

# Install Chocolatey packages
Install-ChocolateyPackages -packages $dependencies.choco.progs

# Install winget packages
Install-WingetPackages -packages $dependencies.winget.progs

Copy-Item (Join-Path -Path $ConfigsDirectory -ChildPath "profile.ps1") $PROFILE.AllUsersAllHosts -Force

# move ahk script
$sourceFile = (Join-Path -Path $ConfigsDirectory -ChildPath "shortcuts.ahk")
$autostartDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

# Copy the file to the Autostart directory
Copy-Item -Path $sourceFile -Destination $autostartDir

$url = "https://gist.githubusercontent.com/floork/363314e2b1263bacc826c53439c280ec/raw/b5b55d0893c02366b71ca78e05a58f8ce536f16f/starship.toml"
$outputPath = "~/.config/starship.toml"
Invoke-WebRequest -Uri $url -OutFile $outputPath

Add-Content -Path "$env:LocalAppData\clink\starship.lua" -Value "load(io.popen('starship init cmd'):read("*a"))()"
