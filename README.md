# PowerShell

My customized powershell (core) profile directory `~/Documents/PowerShell` (or `~/Documents/OneDrive/PowerShell`).

See the [Changelog](CHANGELOG.md) for details on this repository's development over time.

## Contents

- [PowerShell](#powershell)
  - [Contents](#contents)
  - [$PROFILE](#profile)
    - [Profile Features](#profile-features)
  - [Custom Functions](#custom-functions)
  - [Custom Aliases](#custom-aliases)
  - [Custom Shell Completions](#custom-shell-completions)
  - [Modules](#modules)
  - [Scripts](#scripts)
  - [Functions](#functions)

## $PROFILE

Here are the `$PROFILE` path's to various PowerShell 7 Profile Locations on Windows 11 (note that I am currently using OneDrive):

```powershell
➜ $PROFILE
C:\Users\jimmy\OneDrive\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
➜ $PROFILE.CurrentUserCurrentHost
C:\Users\jimmy\OneDrive\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
➜ $PROFILE.CurrentUserAllHosts
C:\Users\jimmy\OneDrive\Documents\PowerShell\profile.ps1
➜ $PROFILE.AllUsersCurrentHost
C:\Program Files\PowerShell\7\Microsoft.PowerShell_profile.ps1
➜ $PROFILE.AllUsersAllHosts
C:\Program Files\PowerShell\7\profile.ps1
```

In this repository there are the following profile files:

- [profile.ps1](profile.ps1) - *CurrentUserAllHosts* Profile
- [Microsoft.PowerShell_profile.ps1](Microsoft.PowerShell_profile.ps1) - *CurrentUserCurrentHost* Profile - The Default `$PROFILE`
- [Microsoft.VSCode_profile.ps1](Microsoft.VSCode_profile.ps1) - VSCode Specific Host Profile

### Profile Features

For [profile.ps1](profile.ps1):

- Trust `PSGallery`
- Import necessary modules in specific order
- Enable `posh-git`
- Set `prompt` theme via `oh-my-posh`
- Set some PSReadLine Handlers

<details><summary>🔎 View Code</summary>
 <p>

```powershell
#Requires -Version 7

# ----------------------------------------------------
# Current User, All Hosts Powershell Core v7 $PROFILE:
# ----------------------------------------------------

# Trust PSGallery
$galleryinfo = Get-PSRepository | Where-Object { $_.Name -eq "PSGallery" }
if (-not($galleryinfo.InstallationPolicy.Equals("Trusted"))) { Set-PSRepository -Name PSGallery -InstallationPolicy Trusted }

# Import Modules
Import-Module posh-git
Import-Module oh-my-posh
Import-Module Terminal-Icons
Import-Module WslInterop
Import-Module PSWindowsUpdate
Import-Module PSWriteColor

# Enable Posh-Git
$env:POSH_GIT_ENABLED = $true

# Prompt
Set-PoshPrompt -Theme wopian

# ZLocation must be after all prompt changes:
Import-Module ZLocation
Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"
```

Optional:

- Import WSL Linux/BASH Interop Commands (ls, awk, tree, etc.)
- Set `PSReadLine` options
- Start custom log
- Map custom `PSDrive`'s to common folders

Here are my mapped custom drives:

```powershell
# ---------
# PSDrives
# ---------

# Create drive shortcut for '~/Dev':
if ((Test-Path "$env:USERPROFILE\Dev") -and (-not (Get-PSDrive -Name "Dev" -ErrorAction SilentlyContinue))) {
  New-PSDrive -Name Dev -PSProvider FileSystem -Root "$env:USERPROFILE\Dev" -Description "Development Folder"
  function Dev: { Set-Location Dev: }
}

# Creates drive shortcut for OneDrive, if current user account is using it
if ((Test-Path HKCU:\SOFTWARE\Microsoft\OneDrive) -and (-not (Get-PSDrive -Name "OneDrive" -ErrorAction SilentlyContinue))) {
    $onedrive = Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\OneDrive
    if (Test-Path $onedrive.UserFolder) {
        New-PSDrive -Name OneDrive -PSProvider FileSystem -Root $onedrive.UserFolder -Description "OneDrive"
        function OneDrive: { Set-Location OneDrive: }
    }
    Remove-Variable onedrive
}

# Dotfiles
if ((Test-Path "$HOME\.dotfiles") -and (-not (Get-PSDrive -Name "dotfiles" -ErrorAction SilentlyContinue))) {
  New-PSDrive -Name dotfiles -PSProvider FileSystem -Root "$HOME\.dotfiles" -Description "Dotfiles"
      function dotfiles: { Set-Location dotfiles: }
}
```

</p>
</details>

For [Microsoft.PowerShell_profile.ps1](Microsoft.PowerShell_profile.ps1):

- Load custom [profile_completion.ps1](profile_completion.ps1)
- Load custom [profile_functions.ps1](./profile_functions.ps1)
- Load custom [profile_aliases.ps1](./profile_aliases.ps1)

<details><summary>🔎 View Code</summary>
 <p>

```powershell
# #Requires -Version 7

# -------------------------------------------------------
# Current User, Current Host Powershell Core v7 $PROFILE:
# -------------------------------------------------------

# Load Functions, Aliases, and Completion
$psdir = (Split-Path -parent $profile)

. "$psdir\profile_functions.ps1"
. "$psdir\profile_aliases.ps1"
. "$psdir\profile_completion.ps1"
```

</p>
</details>

## Custom Functions

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

- See [profile_functions.ps1]:

<details><summary>🔎 View Code</summary>
 <p>

 ```powershell
# ---------------------------------
# PowerShell Core Profile Functions
# ---------------------------------

# ---------------------
# Search via `s-cli`
# ---------------------

${function:Search-GitHub} = { s -p github $args }
${function:Search-GitHubPwsh} = { s -p ghpwsh $args }
${function:Search-GitHubR} = { s -p ghr $args }
${function:Search-MyRepos} = { s -p myrepos $args }

# --------
# GCalCLI
# --------
${function:Get-Agenda} = { & gcalcli agenda }
${function:Get-CalendarMonth} = { & gcalcli calm }
${function:Get-CalendarWeek} = { & gcalcli calw }
${function:New-CalendarEvent} = { & gcalcli add }

# -----
# LSD
# -----
${function:lsa} = { & lsd -a }

# ----------------------
# System Utilities
# ----------------------

# Check Disk
${function:Check-Disk} = { & chkdsk C: /f /r /x }

# Update Environment
${function:Update-Environment} = {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
  Write-Host -ForegroundColor Green "Sucessfully Refreshed Environment Variables For powershell.exe"
}

# Clean System
${function:Clean-System} = {
  Write-Verbose -Message 'Emptying Recycle Bin'
  (New-Object -ComObject Shell.Application).Namespace(0xA).items() | % { rm $_.path -Recurse -Confirm:$false }
  Write-Verbose 'Removing Windows %TEMP% files'
  Remove-Item c:\Windows\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
  Write-Verbose 'Removing User %TEMP% files'
  Remove-Item “C:\Users\*\Appdata\Local\Temp\*” -Recurse -Force -ErrorAction SilentlyContinue
  Write-Verbose 'Removing Custome %TEMP% files (C:/Temp and C:/tmp)'
  Remove-Item c:\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item c:\Tmp\* -Recurse -Force -ErrorAction SilentlyContinue
  Write-Verbose 'Launchin cleanmgr'
  cleanmgr /sagerun:1 | out-Null
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
  }
  else {
    sudo TAKEOWN /F $path
  }
}

# Force Delete
Function Invoke-ForceDelete ( $path ) {
  Take-Ownership $path
  sudo remove-item -path $path -Force -Recurse -ErrorAction SilentlyContinue
  if (!(Test-Path $path)) {
    Write-Host "✔️ Successfully Removed $path" -ForegroundColor Green
  }
  else {
    Write-Host "❌ Failed to Remove $path" -ForegroundColor Red
  }
}

# ------------------
# Network Utilities
# ------------------

# Speed Test
${function:Speed-Test} = { & speed-test } # NOTE: must have speedtest installed

# Get Public IP
${function:Get-PublicIP} = {
  $ip = Invoke-RestMethod -Uri 'https://api.ipify.org?format=json'
  "My public IP address is: $($ip.ip)"
}

# -----------------------
# Launch Programs
# -----------------------

# Start Docker


# Open GitKraken in Current Repo
${function:krak} = {
  $curpath = (get-location).ProviderPath
  $lapd = $env:localappdata
  $logf = "$env:temp\krakstart.log"
  $newestExe = Get-Item "$lapd\gitkraken\app-*\gitkraken.exe"
  start-process -filepath $newestExe -ArgumentList "--path $curpath" -redirectstandardoutput $logf
}

# Open RStudio in Current Repo
${function:rstudio} = {
  $curpath = (get-location).ProviderPath
  $exepath = "$env:programfiles\RStudio\bin\rsudio.exe"
  start-process -filepath $exepath -ArgumentList "--path $curpath" -redirectstandardoutput $logf
}

# Start Docker:
${function:Start-Docker} = { Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" }

# --------------------------
# PowerShell Functions
# --------------------------

# Edit `profile.ps1`
${function:Edit-Profile} = { notepad.exe $PROFILE.CurrentUserAllHosts }

# Edit profile_functions.ps1
${function:Edit-Functions} = {
  $prodir = Split-Path -Path $PROFILE -Parent
  $funcpath = "$prodir\profile_functions.ps1"
  notepad.exe $funcpath
}

# Edit profile_aliases.ps1
${function:Edit-Aliases} = {
  $prodir = Split-Path -Path $PROFILE -Parent
  $funcpath = "$prodir\profile_aliases.ps1"
  notepad.exe $funcpath
}

# Edit profile_completion.ps1
${function:Edit-Aliases} = {
  $prodir = Split-Path -Path $PROFILE -Parent
  $funcpath = "$prodir\profile_completion.ps1"
  notepad.exe $funcpath
}

# Open Profile Directory in VSCode:
${function:Edit-ProfileDirectory} = {
  $prodir = Split-Path -Path $PROFILE -Parent
  code-insiders $prodir
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
 ```
 </p>
</details>

## Custom Aliases

- See [profile_aliases.ps1](profile_aliases.ps1):

<details><summary>🔎 View Code</summary>
 <p>

```powershell
Set-Alias -Name irs -Value Invoke-RemoteScript
Set-Alias -Name pro -Value Edit-Profile
Set-Alias -Name aliases -Value Get-Alias
Set-Alias -Name cpkgs -Value chocopkgs
Set-Alias -Name cclean -Value chococlean
Set-Alias -Name csearch -Value chocosearch
Set-Alias -Name cup -Value chocoupgrade
Set-Alias -Name cbackup -Value chocobackup
Set-Alias -Name refresh -Value refreshenv
Set-Alias -Name touch -Value New-File
Set-Alias -Name rproj -Value openrproj
Set-Alias -Name chkdisk -Value Check-Disk
Set-Alias -Name cdd -Value CreateAndSet-Directory
Set-Alias -Name emptytrash -Value Clear-RecycleBin
Set-Alias -Name codee -Value code-insiders
Set-Alias -Name cpkgs -Value chocopkgs
Set-Alias -Name cup -Value chocoupgrade
Set-Alias -Name gcal -Value gcalcli
Set-Alias -Name agenda -Value Get-Agenda
Set-Alias -Name gcalm -Value Get-CalendarMonth
Set-Alias -Name gcalw -Value Get-CalendarWeek
Set-Alias -Name gcalnew -Value New-CalendarEvent

# Ensure `R` is for launching an R Terminal:
if (Get-Command R.exe -ErrorAction SilentlyContinue | Test-Path) {
  Remove-Item Alias:r -ErrorAction SilentlyContinue
  ${function:r} = { R.exe @args }
}
```

 </p>
</details>

## Custom Shell Completions

- Shell completion for:
  - Docker
  - PowerShell
  - Scoop
  - Chocolatey
  - WinGet
  - Github-CLI
  - Git Cliff (changelog generator)
  - Keep
  - DotNet

- See [profile_completion.ps1](profile_completion.ps1):

<details><summary>🔎 View Code</summary>
 <p>

```powershell
# Completion

# Shell Completion Modules
Import-Module DockerCompletion
Import-Module Microsoft.PowerShell.Utility
Import-Module C:\Users\jimmy\scoop\modules\scoop-completion

# Github CLI autocompletion - see issue for reference: https://github.com/cli/cli/issues/695#issuecomment-619247050
Invoke-Expression -Command $(gh completion -s powershell | Out-String)

# winget (see https://github.com/microsoft/winget-cli/blob/master/doc/Completion.md#powershell)
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  $Local:word = $wordToComplete.Replace('"', '""')
  $Local:ast = $commandAst.ToString().Replace('"', '""')
  winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

# Chocolatey Completion
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

```

 </p>
</details>

## Modules

![image](https://user-images.githubusercontent.com/32652297/128624682-4f1483c2-98b4-4b61-84e0-735580607a79.png)

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

- See [modules.json](modules.json) and [modules.ps1](modules.ps1):

## Scripts

- Various powershell scripts for automation and configurations.

## Functions

Custom folder outside the scope of profile for housing snippets and past-work.

