# PowerShell

My customized powershell (core) profile directory `~/Documents/PowerShell` (or `~/Documents/OneDrive/PowerShell`).

See the [Changelog](CHANGELOG.md) for details on this repository's development over time.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Overview](#overview)
- [Core `$PROFILE`](#core-profile)
- [The Profile Directory](#the-profile-directory)
  - [Options](#options)
  - [Prompt](#prompt)
  - [Functions](#functions)
  - [Aliases](#aliases)
  - [Shell Completions](#shell-completions)
  - [Modules](#modules)
- [Scripts](#scripts)
- [Functions](#functions-1)
  - [Appendix: Modules](#appendix-modules)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Overview

In this repository there are the following profile files:[^1]

- [profile.ps1](profile.ps1) - *CurrentUserAllHosts* Profile
- [Microsoft.PowerShell_profile.ps1](Microsoft.PowerShell_profile.ps1) - *CurrentUserCurrentHost* Profile - The Default `$PROFILE`
- [Microsoft.VSCode_profile.ps1](Microsoft.VSCode_profile.ps1) - VSCode Specific Host Profile

Notes:

- For [Microsoft.PowerShell_profile.ps1](Microsoft.PowerShell_profile.ps1) and [Microsoft.VSCode_profile.ps1](Microsoft.VSCode_profile.ps1):
- I currently do not separate User specific configs from system wide/VSCode specific configs, so nothing here; included for reference.

## Core `$PROFILE`

For [profile.ps1](profile.ps1) (main `profile`):

Simply dot sources each top-level `*.ps1` file from the [Profile](Profile) directory:

- [aliases.ps1](Profile/aliases.ps1)
- [completion.ps1](Profile/completion.ps1)
- [functions.ps1](Profile/functions.ps1)
- [modules.ps1](Profile/modules.ps1)
- [options.ps1](Profile/options.ps1)
- [prompt.ps1](Profile/prompt.ps1)

<details><summary>🔎 View Code</summary>
 <p>


<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=./profile.ps1) -->
<!-- The below code snippet is automatically added from ./profile.ps1 -->
```ps1
#Requires -Version 7

# ----------------------------------------------------
# Current User, All Hosts Powershell Core v7 $PROFILE:
# ----------------------------------------------------

$psfiles = Join-Path (Split-Path -Parent $profile) "Profile" | Get-ChildItem -Filter "*.ps1"
ForEach ($file in $psfiles) { . $file }
```
<!-- MARKDOWN-AUTO-DOCS:END -->
 </p>
</details>

## The [Profile](Profile) Directory

All features of the `$PROFILE` come from the [Profile](Profile) directory:

```powershell
➜ ~\OneDrive\Documents\PowerShell :: git(main)                        01:39:05  
➜ tree /F /A Profile
Folder PATH listing
Volume serial number is 4879-37CA
C:\USERS\JIMMY\ONEDRIVE\DOCUMENTS\POWERSHELL\PROFILE
|   aliases.ps1
|   completion.ps1
|   functions.ps1
|   modules.ps1
|   options.ps1
|   prompt.ps1
|   
+---aliases
|       aliases-export.ps1
|       
+---completions
|       aws.ps1
|       choco.ps1
|       docker.ps1
|       dotnet.ps1
|       gh-cli.ps1
|       git-cliff.ps1
|       s-search.ps1
|       scoop.ps1
|       spotify.ps1
|       winget.ps1
|       yq.ps1
|       
\---functions
        Get-AdminRights.ps1
        Get-NetAccelerators.ps1
        Get-NetFramework.ps1
        Get-RandomAbout.ps1
        Get-RandomHelp.ps1
        Launch-AzurePortal.ps1
        Module-Helpers.ps1
        System-Functions.ps1
        Test-WiFi.ps1
```

### Options

See *[options.ps1](Profile/options.ps1)*.

- Trust `PSGallery`
- Setup some `$PSDefaultParameterValues`
- Set some PSReadLine Handlers

<details><summary>🔎 View Code</summary>
 <p>


<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=./Profile/options.ps1) -->
<!-- The below code snippet is automatically added from ./Profile/options.ps1 -->
```ps1
# Trust PSGallery
$galleryinfo = Get-PSRepository | Where-Object { $_.Name -eq "PSGallery" }
if (-not($galleryinfo.InstallationPolicy.Equals("Trusted"))) { Set-PSRepository -Name PSGallery -InstallationPolicy Trusted }

# Default Parameters
$PSDefaultParameterValues = @{
	"Update-Module:Confirm"     = $False;
	"Update-Module:Force"       = $True;
	"Update-Module:Scope"       = "CurrentUser";
	"Update-Module:ErrorAction" = "SilentlyContinue";
	"Update-Help:Force"         = $True;
	"Update-Help:ErrorAction"   = "SilentlyContinue";
}

# Set PSReadLineOptions's (Beta Version Required):
Set-PSReadLineOption -PredictionSource History -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -EditMode Windows
```
<!-- MARKDOWN-AUTO-DOCS:END -->
 </p>
</details>

### Prompt

- Set `prompt` theme via `oh-my-posh`
- Output useful startup information

From *[prompt.ps1](Profile/prompt.ps1):*

<details><summary>🔎 View Code</summary>
 <p>

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=./Profile/prompt.ps1) -->
<!-- The below code snippet is automatically added from ./Profile/prompt.ps1 -->
```ps1
# Prompt
If (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config $ENV:POSH_THEMES_PATH\wopian.omp.json | Invoke-Expression
}

# Write Current Version and Execution Policy Details:
Write-Host "PowerShell Version: $($psversiontable.psversion) - ExecutionPolicy: $(Get-ExecutionPolicy)" -ForegroundColor yellow

# ZLocation must be after all prompt changes:
Import-Module ZLocation
Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"
```
<!-- MARKDOWN-AUTO-DOCS:END -->
 </p>
</details>

### Functions

My suite of custom functions to be loaded for every PowerShell session:
  - Search functions via [zquestz/s](https://github.com/zquestz/s)
  - Google Calendar functions via [gcalcli](https://github.com/insanum/gcalcli)
  - Directory listing functions for `lsd`
  - System Utility Functions
  - Symlinking Functions
  - Network Utilities
  - Programs
  - PowerShell helpers
  - Remoting
  - Chocolatey
  - R and RStudio
  - GitKraken

- See [functions.ps1](Profile/functions.ps1):

<details><summary>🔎 View Code</summary>
 <p>

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=./Profile/functions.ps1) -->
<!-- The below code snippet is automatically added from ./Profile/functions.ps1 -->
```ps1
# ----------
# Launchers
# ----------

Function Open-Todoist { Start-Process -PassThru 'C:\Users\jimmy\AppData\Local\Programs\todoist\Todoist.exe' }

Function Open-GitHub { Start-Process -PassThru 'https://github.com/' }

Function Open-Docker { Start-Process -PassThru 'C:\Program Files\Docker\Docker\frontend\Docker Desktop.exe' }

Function Open-RProject { Rscript -e 'jimstools::open_project()' }

# ---------------------------------
# PowerShell Core Profile Functions
# ---------------------------------

Function Remove-OldModules {

  Write-Host 'this will remove all old versions of installed modules'
  Write-Host 'be sure to run this as an admin' -ForegroundColor yellow
  Write-Host '(You can update all your Azure RM modules with update-module Azurerm -force)'

  $mods = Get-InstalledModule

  foreach ($mod in $mods) {
    Write-Host "Checking $($mod.name)"
    $latest = Get-InstalledModule $mod.name
    $specificmods = Get-InstalledModule $mod.name -AllVersions
    Write-Host "$($specificmods.count) versions of this module found [ $($mod.name) ]"
  
    foreach ($sm in $specificmods) {
      if ($sm.version -ne $latest.version) {
        Write-Host "uninstalling $($sm.name) - $($sm.version) [latest is $($latest.version)]"
        $sm | Uninstall-Module -Force
        Write-Host "done uninstalling $($sm.name) - $($sm.version)"
        Write-Host '    --------'
      }
	
    }
    Write-Host '------------------------'
  }
  Write-Host 'done'

}

Function Update-ProfileModules {

  $modpath = ($env:PSModulePath -split ";")[0]
  $ymlpath = "$modpath\modules.yml"
  $mods = (Get-ChildItem $modpath -Directory).Name
  ConvertTo-Yaml -Data $mods -OutFile $ymlpath -Force

  # Set-Location "$HOME\Documents"
  # git pull
  # git add PowerShell/Modules/**
  # git commit -m "config: Updated modules configurations"
  # git-cliff -o "$HOME\Documents\CHANGELOG.md"
  # git add CHANGELOG.md
  # git commit -m "doc: update CHANGELOG.md for added modules"
  # git push

}

# ----------------------
# System Utilities
# ----------------------

# Troubleshooters

# Hardware Troubleshooter (unavailable in settings)
${function:Invoke-HardwareDiagnostic} = { & msdt.exe -id DeviceDiagnostic }
${function:Invoke-NetworkDiagnostic} = { & msdt.exe -id NetworkDiagnosticsNetworkAdapter }
${function:Invoke-SearchDiagnostic} = { & msdt.exe -id SearchDiagnostic }
${function:Invoke-WindowsUpdateDiagnostic} = { & msdt.exe -id WindowsUpdateDiagnostic }
${function:Invoke-MaintenanceDiagnostic} = { & msdt.exe -id MaintenanceDiagnostic }

# Check Disk
${function:Check-Disk} = { & chkdsk C: /f /r /x }

# Update Environment
${function:Update-Environment} = {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
  Write-Host -ForegroundColor Green "Sucessfully Refreshed Environment Variables For powershell.exe"
}

# Clean System
${function:Clean-System} = {
  Write-Host -Message 'Emptying Recycle Bin' -ForegroundColor Yellow
  (New-Object -ComObject Shell.Application).Namespace(0xA).items() | ForEach-Object { Remove-Item $_.path -Recurse -Confirm:$false }
  Write-Host 'Removing Windows %TEMP% files' -ForegroundColor Yellow
  Remove-Item c:\Windows\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host 'Removing User %TEMP% files' -ForegroundColor Yellow
  Remove-Item “C:\Users\*\Appdata\Local\Temp\*” -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host 'Removing Custome %TEMP% files (C:/Temp and C:/tmp)' -ForegroundColor Yellow
  Remove-Item c:\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item c:\Tmp\* -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host 'Launchin cleanmgr' -ForegroundColor Yellow
  cleanmgr /sagerun:1 | Out-Null
  Write-Host '✔️ Done.' -ForegroundColor Green
}

# New File
${function:New-File} = { New-Item -Path $args -ItemType File -Force }

# New Directory
${function:New-Dir} = { New-Item -Path $args -ItemType Directory -Force }

# Net Directory and cd into
${function:CreateAndSet-Directory} = {
  New-Item -Path $args -ItemType Directory -Force
  Set-Location -Path "$args"
}

# Create Symlink
Function New-Link ($target, $link) {
  New-Item -Path $link -ItemType SymbolicLink -Value $target
}

# Take Ownership
Function Invoke-TakeOwnership ( $path ) {
  if ((Get-Item $path) -is [System.IO.DirectoryInfo]) {
    sudo TAKEOWN /F $path /R /D Y
  } else {
    sudo TAKEOWN /F $path
  }
}

# Force Delete
Function Invoke-ForceDelete ( $path ) {
  Take-Ownership $path
  sudo remove-item -path $path -Force -Recurse -ErrorAction SilentlyContinue
  if (!(Test-Path $path)) {
    Write-Host "✔️ Successfully Removed $path" -ForegroundColor Green
  } else {
    Write-Host "❌ Failed to Remove $path" -ForegroundColor Red
  }
}

# ------------------
# Network Utilities
# ------------------

${function:Reset-Network} = {
  Write-Host "Resetting Windows Sockets.." -ForegroundColor Yellow
  netsh winsock reset
  Write-Host "Resetting Internal IP Addresses.." -ForegroundColor Yellow
  netsh int ip reset all
  Write-Host "Resetting Windows HTTP Proxy.." -ForegroundColor Yellow
  netsh winhttp reset proxy
  Write-Host "Flushing DNS.." -ForegroundColor Yellow
  ipconfig /flushdns
  Write-Host "✔️ Done." -ForegroundColor Green
  $restart = Read-Host "To apply changes a restart is required, restart now? (y/n)"
  If ($restart -eq "y") { Restart-Computer }
}

${function:Get-IP} = {
  ((ipconfig | findstr [0-9].\.)[0]).Split()[-1]
}

# Get Public IP
${function:Get-PublicIP} = {
  $ip = Invoke-RestMethod -Uri 'https://api.ipify.org?format=json'
  "My public IP address is: $($ip.ip)"
}

# --------------------------
# PowerShell Functions
# --------------------------

# Edit `profile.ps1`
${function:Edit-Profile} = { code $PROFILE.CurrentUserAllHosts }

# Edit profile_functions.ps1
${function:Edit-Functions} = {
  $prodir = Split-Path -Path $PROFILE -Parent
  $funcpath = "$prodir\Profile\functions.ps1"
  code $funcpath
}

# Edit profile_aliases.ps1
${function:Edit-Aliases} = {
  $prodir = Split-Path -Path $PROFILE -Parent
  $funcpath = "$prodir\Profile\aliases.ps1"
  code $funcpath
}

# Edit profile_completion.ps1
${function:Edit-Completion} = {
  $prodir = Split-Path -Path $PROFILE -Parent
  $funcpath = "$prodir\Profile\completion.ps1"
  code $funcpath
}

# Open Profile Directory in VSCode:
${function:Edit-ProfileDirectory} = {
  $prodir = Split-Path -Path $PROFILE -Parent
  code $prodir
}

${function:Get-HistPath} = { (Get-PSReadlineoption).HistorySavePath }

# ----------
# Secrets
# ----------

Function Get-MySecret($name) {
  $secrets = (Get-SecretInfo).Name
  If (!($secrets -contains $name)) { throw "No secret named $name found in vault." }
  Get-Secret -Name $name -AsPlainText
}

Function Get-GitCryptStatus {
  git-crypt status -e
}

Function Invoke-GitCryptStatus {
  git-crypt status -f
}

# ------------------
# Remoting
# ------------------

# Invoke Remote Script - Example: Invoke-RemoteScript <url>
Function Invoke-RemoteScript {
  [CmdletBinding()]
  param(
    [Parameter(Position = 0)]
    [string]$address,
    [Parameter(ValueFromRemainingArguments = $true)]
    $remainingArgs
  )
  Invoke-Expression "& { $(Invoke-RestMethod $address) } $remainingArgs"
}

# ------
# Docker
# ------

# Docker
${function:Start-Docker} = { Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" }
${function:Stop-Docker} = { foreach ($dock in (Get-Process *docker*).ProcessName) { sudo stop-process -name $dock } }


# Open RStudio in Current Repo
${function:rstudio} = {
  $curpath = (Get-Location).ProviderPath
  $logf = "$env:temp\rstudiostart.log"
  $exepath = "$env:programfiles\RStudio\bin\rstudio.exe"
  Start-Process -FilePath $exepath -ArgumentList "--path $curpath" -RedirectStandardOutput $logf
}

# -----------
# Chocolatey
# -----------

${function:chocopkgs} = { & choco list --local-only }
${function:chococlean} = { & choco-cleaner }
${function:chocoupgrade} = { & choco upgrade all -y }
${function:chocobackup} = { & choco-package-list-backup }
${function:chocosearch} = { & choco search $args }

# ---------------
# R and RStudio
# ---------------

${function:rvanilla} = { & "C:\Program Files\R\R-4.1.1\bin\R.exe" --vanilla }
${function:radianvanilla} = { & "C:\Python39\Scripts\radian.exe" --vanilla }
${function:openrproj} = { & C:\bin\openrproject.bat }
${function:pakk} = { Rscript.exe "C:\bin\pakk.R" $args }

# ---------
# GitKraken
# ---------

# Open GitKraken in Current Repo
${function:krak} = {
  $curpath = (Get-Location).ProviderPath
  If (!(Test-Path "$curpath\.git")) { Write-Error "Not a git repository. Run 'git init' or select a git tracked directory to open. Exiting.."; return }
  $logf = "$env:temp\krakstart.log"
  $newestExe = Resolve-Path "$env:localappdata\gitkraken\app-*\gitkraken.exe"
  If ($newestExe.Length -gt 1) { $newestExe = $newestExe[1] }
  Start-Process -FilePath $newestExe -ArgumentList "--path $curpath" -RedirectStandardOutput $logf
}

# ---------------------
# Search via `s-cli`
# ---------------------

If (Get-Command s -ErrorAction SilentlyContinue) {

  ${function:Search-GitHub} = { s -p github $args }
  ${function:Search-GitHubPwsh} = { s -p ghpwsh $args }
  ${function:Search-GitHubR} = { s -p ghr $args }
  ${function:Search-MyRepos} = { s -p myrepos $args }

}

# --------
# GCalCLI
# --------

If (Get-Command gcalcli -ErrorAction SilentlyContinue) {
  ${function:Get-Agenda} = { & gcalcli agenda }
  ${function:Get-CalendarMonth} = { & gcalcli calm }
  ${function:Get-CalendarWeek} = { & gcalcli calw }
  ${function:New-CalendarEvent} = { & gcalcli add }
  ${function:Remove-CalendarEvent} = { & gcalcli delete $args }
}

# -----
# LSD
# -----

If (Get-Command lsd -ErrorAction SilentlyContinue) {
  ${function:lsa} = { & lsd -a }
}
```
<!-- MARKDOWN-AUTO-DOCS:END -->
 </p>
</details>

### Aliases

- See [aliases.ps1](Profile/aliases.ps1): 
*(and the exported [aliases-export.ps1](Profile/aliases/aliases-export.ps1))*

<details><summary>🔎 View Code</summary>
 <p>

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=./Profile/aliases.ps1) -->
<!-- The below code snippet is automatically added from ./Profile/aliases.ps1 -->
```ps1
# -------------------------
# PowerShell Aliases
# -------------------------

Set-Alias -Name pro -Value Edit-Profile
Set-Alias -Name aliases -Value Get-Alias
Set-Alias -Name refresh -Value refreshenv
Set-Alias -Name touch -Value New-File
Set-Alias -Name rproj -Value openrproj
Set-Alias -Name chkdisk -Value Check-Disk
Set-Alias -Name cdd -Value CreateAndSet-Directory
Set-Alias -Name emptytrash -Value Clear-RecycleBin
Set-Alias -Name checkdisk -Value Invoke-Checkdisk
Set-Alias -Name sfc -Value Invoke-SFCScan
Set-Alias -Name expl -Value explorer.exe
Set-Alias -Name np -Value 'C:\Program Files\WindowsApps\Microsoft.WindowsNotepad_11.2111.0.0_x64__8wekyb3d8bbwe\Notepad\Notepad.exe'

# Set-Alias -Name files -Value 'C:\Program Files\WindowsApps\49306atecsolution.FilesUWP_2.0.34.0_x64__et10x9a9vyk8t\Files.exe'

# Remove stupid 'touch' alias for 'set-filetime'
Remove-Alias -Name touch

# Ensure `R` is for launching an R Terminal:
if (Get-Command R.exe -ErrorAction SilentlyContinue | Test-Path) {
	Remove-Item Alias:r -ErrorAction SilentlyContinue
	${function:r} = { R.exe @args }
}

# VSCode / VSCode Insiders
If (!(Get-Command code -ErrorAction SilentlyContinue)) {
	Set-Alias -Name code -Value code-insiders
}

# Ensure gpg points to correct program
# Set-Alias -Name gpg -Value 'C:\Program Files (x86)\GnuPG\bin\gpg.exe'

# Chocolatey
If (Get-Command choco -ErrorAction SilentlyContinue) {
	Set-Alias -Name cpkgs -Value chocopkgs
	Set-Alias -Name csearch -Value chocosearch
	Set-Alias -Name cup -Value chocoupgrade

	If (Get-Command choco-cleaner -ErrorAction SilentlyContinue) {
		Set-Alias -Name cclean -Value chococlean
	}
	If (Get-Command choco-package-list-backup -ErrorAction SilentlyContinue) {
		Set-Alias -Name cbackup -Value chocobackup
	}
}

# gcalcli
If (Get-Command gcalcli -ErrorAction SilentlyContinue) {
	Set-Alias -Name gcal -Value gcalcli
	Set-Alias -Name agenda -Value Get-Agenda
	Set-Alias -Name gcalm -Value Get-CalendarMonth
	Set-Alias -Name gcalw -Value Get-CalendarWeek
	Set-Alias -Name calm -Value Get-CalendarMonth
	Set-Alias -Name calw -Value Get-CalendarWeek
	Set-Alias -Name gcaladd -Value New-CalendarEvent
	Set-Alias -Name caladd -Value New-CalendarEvent
}

# git-crypt
If (Get-Command git-crypt -ErrorAction SilentlyContinue) {
	Set-Alias -Name gcrypts -Value Get-GitCryptStatus
	Set-Alias -Name gcrypt -Value git-crypt
	Set-Alias -Name gcryptf Invoke-GitCryptStatus
}

# If using code-insiders
If (Get-Command code-insiders -ErrorAction SilentlyContinue) {
	Set-Alias -Name codee -Value code-insiders
}

# lsd
If (Get-Command lsd -ErrorAction SilentlyContinue) {
	${function:lsa} = { & lsd -a }
}
```
<!-- MARKDOWN-AUTO-DOCS:END -->
 </p>
</details>


### Shell Completions

All custom shell completion scripts and invokations are housed in the [Profile/completions](./Profile/completions) directory and dot sourced in via [Profile/completion.ps1](Profile/completion.ps1).

Included are shell completions for the following tools:

- PowerShell: Imported with `Microsoft.PowerShell.Utility` Module (see code below)

plus,

- AWS-CLI: [aws.ps1](Profile/completions/aws.ps1)
- Chocolatey: [choco.ps1](Profile/completions/choco.ps1)
- Docker: [docker.ps1](Profile/completions/docker.ps1) *(via `DockerCompletion` Module)*
- DotNet: [dotnet.ps1](Profile/completions/dotnet.ps1)
- GitHub-CLI: [gh-cli.ps1](Profile/completions/gh-cli.ps1)
- Git-Cliff: [git-cliff.ps1](Profile/completions/git-cliff.ps1)
- S (search): [s-search.ps1](Profile/completions/s-search.ps1)
- Scoop: [scoop.ps1](Profile/completions/scoop.ps1) *(via `scoop-completion` Module)*
- Spotify: [spotify.ps1](Profile/completions/spotify.ps1)
- WinGet: [winget.ps1](Profile/completions/winget.ps1) 
- ffsend: [ffsend.ps1](Profile/completions/ffsend.ps1)

*See [Profile/completion.ps1](Profile/completion.ps1):*

<details><summary>🔎 View Code</summary>
 <p>

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=./Profile/completion.ps1) -->
<!-- The below code snippet is automatically added from ./Profile/completion.ps1 -->
```ps1
# -------------------------
# PowerShell Completion
# -------------------------

Import-Module Microsoft.PowerShell.Utility

$files = Get-ChildItem -Path $(Get-Location) -Filter '*.ps1'
ForEach ($file in $files) {
  . $file
}
```
<!-- MARKDOWN-AUTO-DOCS:END -->
 </p>
</details>

### Modules

See the [Appendix: Modules](#appendix-modules) for an idea of what modules I interact with regularly.

- See [Profile/modules.ps1](Profile/modules.ps1) and the functions `Backup-Modules`, `Sync-Modules` and `Restore-Modules` that interact with [Modules/modules.yml](Modules/modules.yml).

<details><summary>🔎 View Code</summary>
 <p>

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=./Profile/modules.ps1) -->
<!-- The below code snippet is automatically added from ./Profile/modules.ps1 -->
```ps1
# -----------------------------
# Modules and Helper Functions
# -----------------------------

# Required PSReadLine Beta Version
If (!(!((Get-Module -Name PSReadLine).Version.Major -ge 2)) -and (!(Get-Module -Name PSReadLine).Version.Minor -ge 2)) {
    Install-Module -Name PSReadLine -AllowPrerelease -Force -AllowClobber -Scope CurrentUser
}

Import-Module -Name posh-git
Import-Module -Name Terminal-Icons

# Enable Posh-Git
$env:POSH_GIT_ENABLED = $true
```
<!-- MARKDOWN-AUTO-DOCS:END -->
 </p>
</details>

## Scripts

- Various powershell scripts for automation and configurations.

## Functions

Custom folder outside the scope of profile for housing snippets and past-work.

***

### Appendix: Modules

Varies with time but common modules I utilize are:

- 7Zip4PowerShell
- AU
- BurntToast
- ChocolateyGet
- ChocolateyProfile
- DockerCompletion
- Evergreen
- Foil
- InvokeBuild
- ModuleBuild
- oh-my-posh
- PackageManagement
- posh-git
- Posh-SSH
- Posh-Sysmon
- powershell-yaml
- PowerShellGet
- psake
- PSDepend
- PSEverything
- PSGithub
- PSKubectlCompletion
- PSFzf
- PSProfiler
- PSReadLine
- PSScriptTools
- PSTodoist
- PSWindowsUpdate
- scoop-completion
- Terminal-Icons
- WslInterop
- ZLocation

[^1]: About PowerShell Profiles: Here are the `$PROFILE` path's to various PowerShell 7 Profile Locations on Windows 11 (note that I am currently using OneDrive).
