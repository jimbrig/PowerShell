# PowerShell

My customized powershell (core) profile directory `~/Documents/PowerShell` (or `~/Documents/OneDrive/PowerShell`).

## Contents

- [$PROFILE](#profile)
- [Custom Functions](#custom-functions)
- [Custom Aliases](#custom-aliases)
- [Modules](#modules)
- [Scripts](#scripts)

## $PROFILE

- Trust `PSGallery`
- Import various modules
- Set some PSReadLine Handlers
- Shell completion for:
  - Docker
  - PowerShell
  - Scoop
  - Chocolatey
  - WinGet
  - Github-CLI
  - Keep
  - DotNet
- Import WSL Linux/BASH Interop Commands (ls, awk, tree, etc.)
- Load custom [profile_functions.ps1](./profile_functions.ps1)
- Load custom [profile_aliases.ps1](./profile_aliases.ps1)
- Edit Prompt and Shell Colors

```powershell
#Requires -Version 7

# Current User, Current Host Powershell Core v7 $PROFILE:

# trust PSGallery
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# import modules
Import-Module posh-git
Import-Module Terminal-Icons
Import-Module oh-my-posh
Import-Module Posh-Sysmon
Import-Module PSFzf
Import-Module WslInterop
Import-Module PSWindowsUpdate
Import-Module ZLocation

# arrows for PSReadLine
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# Shell Completion
Import-Module DockerCompletion
Import-Module Microsoft.PowerShell.Utility
Import-Module C:\Users\jimbr\scoop\modules\scoop-completion

# Github CLI autocompletion
# see issue for reference: https://github.com/cli/cli/issues/695#issuecomment-619247050
Invoke-Expression -Command $(gh completion -s powershell | Out-String)

# dotnet CLI (see https://www.hanselman.com/blog/how-to-use-autocomplete-at-the-command-line-for-dotnet-git-winget-and-more)
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($commandName, $wordToComplete, $cursorPosition)
  dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

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

# Keep Completion
Invoke-Expression -Command '$(keep completion | Out-String)'

# WSL interop
Import-WslCommand "awk", "grep", "ls", "head", "less", "man", "sed", "seq", "ssh", "tail", "cal", "top", "wget", "tree", "vim", "curl", "gcalcli"
$WslDefaultParameterValues = @{}
$WslDefaultParameterValues["ls"] = "-AFh --group-directories-first"
$WslDefaultParameterValues["grep"] = "-E"
$WslDefaultParameterValues["less"] = "-i"
$WslDefaultParameterValues["tree"] = "-L 1"

# Load functions and aliases
$psdir = (Split-Path -parent $profile)

. "$psdir\profile_functions.ps1"
. "$psdir\profile_aliases.ps1"

# edit prompt
oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh)\themes\wopian.omp.json" | Invoke-Expression
# try { $null = Get-Command pshazz -ea stop; pshazz init 'default' } catch { }
Write-Host “Custom PowerShell Environment Loaded”
Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"
```

## Custom Functions

```powershell
# Navigational Functions
${function:~} = { Set-Location ~ }
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

# System Directories
${function:programfiles} = { Set-Location 'C:\Program Files' }
${function:programfiles86} = { Set-Location 'C:\Program Files (x86)' }
${function:programdata} = { Set-Location C:\ProgramData }
${function:windows} = { Set-Location C:\Windows }

# Custom C: Directories
${function:tools} = { Set-Location C:\tools }
${function:env} = { Set-Location C:\env }
${function:setup} = { Set-Location C:\Setup }

# Specific to My User Profile Directories
${function:onedrive} = { Set-Location ~\OneDrive }
${function:desktop} = { Set-Location ~\Desktop }
${function:documents} = { Set-Location ~\Documents }
${function:downloads} = { Set-Location ~\Downloads }

# Important DotFiles and AppData Directories
${function:dotfiles} = { Set-Location ~\.dotfiles }
${function:rdotfiles} = { Set-Location ~\.config\R }
${function:config} = { Set-Location ~\.config }
${function:localappdata} = { Set-Location ~\Appdata\Local }
${function:appdata} = { Set-Location ~\AppData\Roaming }

# Start Docker:
${function:startdocker} = { Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" }

# R
${function:search_gh} = { Rscript -e "search_gh('$args')" }
${function:search_ghr} = { Rscript -e "search_ghr('$args')" }

# Dev Directory
${function:dev} = { Set-Location ~\Dev }
${function:jimbrig} = { Set-Location ~\Dev\jimbrig }
${function:docs} = { Set-Location ~\Dev\docs }
${function:sandbox} = { Set-Location ~\Dev\sandbox }
${function:mycode} = { Set-Location ~\Dev\code } # do not use code here due to `vscode`

# "Open" Functions
${function:openprofile} = { code-insiders $PROFILE }
${function:openprofilefolder} = { & $path = Get-ProDir && Set-Location $path && explorer.exe . }
${function:openaliases} = { & $path = Get-ProDir && Set-Location $path && code-insiders profile_aliases.ps1 }
${function:openfunctions} = { & $path = Get-ProDir && Set-Location $path && code-insiders profile_functions.ps1 }
${function:opendev} = { Set-Location ~\Dev && explorer.exe . }

# Online Openers
${function:opengh} = { open https://github.com }
${function:openghjim} = { open https://github.com/jimbrig }

# System Utilities and Maintanence
${function:checkdisk} = { & chkdsk C: /f /r /x }
${function:newfile} = { New-Item -Path @args }
${function:System-Update} = { & "C:\env\bin\topgrade.exe" } # NOTE must have topgrade installed and in %PATH%
${function:speedtest} = { & speed-test } # NOTE: must have speedtest installed

# store and appx packages
${function:saveappxpkgs} = { & powerhshell Get-AppXPackage | Out-File -FilePath appx-package-list.txt }
${function:resetstore} = { & wsreset.exe }
${function:resetstorepkgs} = {
  & powershell Get-AppXPackage | Foreach { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
}

# Update-Environment / Refresh Environment Variables
function Update-Environment() {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
  Write-Host -ForegroundColor Green "Sucessfully Refreshed Environment Variables For powershell.exe"
}

# Cleanup System
${function:cleanup} = {
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

# Powershell Utilities
${function:updatepowerhell} = { Invoke-Expression "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI" }
${function:psversion} = { $PSVersionTable }
${function:propath} = { Get-Variable $PROFILE }
${function:prodir} = { Split-Path -Path $PROFILE -Parent }
${function:listaliases} = { Get-Alias }
${function:getpublicip} = {
  $ip = Invoke-RestMethod -Uri 'https://api.ipify.org?format=json'
  "My public IP address is: $($ip.ip)"
} #getpublicip

# Chocolatey
${function:chocopkgs} = { & choco list --local-only }
${function:chococlean} = { & choco-cleaner }
${function:chocoupgrade} = { & choco upgrade all -y }
${function:backupchoco} = { & choco-package-list-backup }
${function:chocosearch} = { & choco search $args }

# Git and Github
${function:gitstatus} = { & git status $args }
${function:ghclone} = { & gh repo clone $args }
${function:ghissues} = { & gh issue list -R $PWD }

# Python and PIP
${function:pipupgradeall} = { { & pip freeze | ForEach-Object { $_.split('==')[0] } | ForEach-Object { pip install --upgrade $_ } } }
${function:upgradepip} = { & pip install --upgrade pip }
${function:upgradepip3} = { & pip3 install --upgrade pip3 }

# R Utilities
${function:rvanilla} = { R.exe --vanilla }
${function:openradian} = { & "C:\Users\Admin\AppData\Local\Programs\Python\Python39\Scripts\radian.exe" }
${function:openrproj} = { & C:\env\bat\openrproject.bat }
${function:launchrstudio} = { & "C:\Program Files\RStudio\bin\Rstudio.exe" }

# Open GitKraken in Current Repo
${function:krak} = {
  $curpath = (get-location).ProviderPath
  $lapd = $env:localappdata
  $logf = "$env:temp\krakstart.log"
  $newestExe = Get-Item "$lapd\gitkraken\app-*\gitkraken.exe"
  Select-Object -Last 1
  start-process -filepath $newestExe -ArgumentList "--path $curpath" -redirectstandardoutput $logf
}

# Open RStudio in Current Repo
${function:rs} = {
  $curpath = (get-location).ProviderPath
  $exepath = "$env:programfiles\RStudio\bin\rsudio.exe"
  start-process -filepath $exepath -ArgumentList "--path $curpath" -redirectstandardoutput $logf
}

${function:pakk} = {
  Rscript --vanilla "C:\bin\pakk.R" $args
}

${function:editfunctions} = {
  $prodir = Split-Path -Path $PROFILE -Parent
  $funcpath = "$prodir\profile_functions.ps1"
  notepad.exe $funcpath
}

${function:editaliases} = {
  $prodir = Split-Path -Path $PROFILE -Parent
  $funcpath = "$prodir\profile_aliases.ps1"
  notepad.exe $funcpath
}

function Take-Ownership ( $path ) {
  if ((Get-Item $path) -is [System.IO.DirectoryInfo]) {
    sudo takeown /r /d Y /f $path
  }
  else {
    sudo takeown /f $path
  }
}

function Force-Delete ( $path ) {
  Take-Ownership $path
  sudo remove-item -path $path -Force -Recurse -ErrorAction SilentlyContinue
  if (!(Test-Path $path)) {
    Write-Host "✔️ Successfully Removed $path" -ForegroundColor Green
  }
  else {
    Write-Host "❌ Failed to Remove $path" -ForegroundColor Red
  }
}

# Test-Install
# Example: Test-Install "Obsidian"
function Test-ProgramInstalled( $programName ) {

  $localmachine_x86_check = ((Get-ChildItem "HKLM:Software\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue('DisplayName') -like "*$programName*" } ).Length -gt 0;

  if (Test-Path 'HKLM:Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall') {
    $localmachine_x64_check = ((Get-ChildItem "HKLM:Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue('DisplayName') -like "*$programName*" } ).Length -gt 0;
  }

  $user_x86_check = ((Get-ChildItem "HKCU:Software\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue('DisplayName') -like "*$programName*" } ).Length -gt 0;

  if (Test-Path 'HKCU:Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall') {
    $user_x64_check = ((Get-ChildItem "HKCU:Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue('DisplayName') -like "*$programName*" } ).Length -gt 0;
  }

  $localmachine_check = $localmachine_x86_check -or $localmachine_x64_check;
  $user_check = $user_x86_check -or $user__x64_check;

  return $localmachine_check -or $user_check;
}

# Install-fromURL
# example: Install-fromURL "<url>" "program-name"
function Install-fromURL($uri, $name) {
  $out = "$env:USERPROFILE\Downloads\$name.exe"
  Invoke-WebRequest -Uri $uri -OutFile $out
  Start-Process $out
}

# Get Github Download URL
# example: Get-GHDownloadURL "user/repo" "*.exe"
function Get-GHDownloadURL($repo, $pattern) {
  $releasesUri = "https://api.github.com/repos/$repo/releases/latest"
  ((Invoke-RestMethod -Method GET -Uri $releasesUri).assets | Where-Object name -like $pattern ).browser_download_url
}

# Download from github
# example: Save-fromGH "user/repo" "*.exe" "program-name"
function Save-fromGH($repo, $pattern, $name) {
  $uri = Get-GHDownloadURL $repo $pattern
  $extension = $pattern.Replace("*", "")
  $out = $name + $extension
  Invoke-WebRequest -Uri $uri -OutFile "$env:USERPROFILE\Downloads\$out"
  explorer.exe "$env:USERPROFILE\Downloads"
}

# install from github
# example: Install-Github "user/repo" "*.exe" "program-name"
function Install-Github($repo, $pattern, $name) {
  Save-fromGH $repo $pattern $name
  $extension = $pattern.Replace("*", "")
  $installfile = $name + $extension
  $installpath = "$env:USERPROFILE\Downloads\" + $installfile
  Start-Process $installpath
}

# invoke remote script
# example: Invoke-RemoteScript
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

```

## Custom Aliases

```powershell
Set-Alias -Name irs -Value Invoke-RemoteScript
Set-Alias -Name ver -Value Get-MrPSVersion
Set-Alias -Name propath -Value Get-ProPath
Set-Alias -Name pro -Value openprofile
Set-Alias -Name proex -Value profilefolder
Set-Alias -Name aliases -Value listaliases
Set-Alias -Name lsalias -Value listaliases
Set-Alias -Name rvan -Value rvanilla
Set-Alias -Name rstudio -Value launchrstudio
Set-Alias -Name gstatus -Value gitstatus
Set-Alias -Name cpkgs -Value chocopkgs
Set-Alias -Name cclean -Value chococlean
Set-Alias -Name csearch -Value chocosearch
Set-Alias -Name cup -Value chocoupgrade
Set-Alias -Name cbackup -Value backupchoco
Set-Alias -Name cs -Value csearch
Set-Alias -Name clone -Value ghclone
Set-Alias -Name pipup -Value pipupgradeall
Set-Alias -Name sysclean -Value cleanup
Set-Alias -Name wifitest -Value speed-test
Set-Alias -Name refresh -Value refreshenv
Set-Alias -Name touch -Value newfile
Set-Alias -Name rproj -Value openrproj
Set-Alias -Name sysupdate -Value System-Update
Set-Alias -Name check -Value checkdisk
Set-Alias -Name mkd -Value CreateAndSet-Directory
Set-Alias -Name diskusage -Value Get-DiskUsage
Set-Alias -Name emptytrash -Value Empty-RecycleBin
Set-Alias -Name cleandisks -Value Clean-Disks
Set-Alias -Name reload -Value Reload-Powershell
Set-Alias -Name mute -Value Set-SoundMute
Set-Alias -Name unmute -Value Set-SoundUnmute
Set-Alias -Name update -Value System-Update
Set-Alias -Name o -Value open
Set-Alias -Name rad -Value Open-Radian
Set-Alias -Name codee -Value code-insiders
Set-Alias -Name rundocker -Value startdocker
Set-Alias -Name refreshenv -Value Update-Environment

# Ensure `R` is for launching an R Terminal:
if (Get-Command R.exe -ErrorAction SilentlyContinue | Test-Path) {
  Remove-Item Alias:r -ErrorAction SilentlyContinue
  ${function:r} = { R.exe @args }
}

### DEPRECATED ###

# Set-Alias -Name ver -Value Get-MrPSVersion
# Set-Alias -Name propath -Value Get-ProPath
# Set-Alias -Name pro -Value openprofile
# Set-Alias -Name proex -Value profilefolder
# Set-Alias -Name aliases -Value listaliases
# Set-Alias -Name lsalias -Value listaliases
# Set-Alias -Name rvan -Value rvanilla
# Set-Alias -Name rstudio -Value launchrstudio
# Set-Alias -Name gstatus -Value gitstatus
# Set-Alias -Name cpkgs -Value chocopkgs
# Set-Alias -Name cclean -Value chococlean
# Set-Alias -Name cup -Value chocoupgrade
# Set-Alias -Name cbackup -Value backupchoco
# Set-Alias -Name cs -Value csearch
# Set-Alias -Name clone -Value ghclone
# Set-Alias -Name pipup -Value pipupgradeall
# Set-Alias -Name sysclean -Value cleanup
# Set-Alias -Name wifitest -Value speed-test
# Set-Alias -Name refresh -Value refreshenv
# # Missing Bash aliases
# Set-Alias time Measure-Command
# # Correct PowerShell Aliases if tools are available (aliases win if set)
# # WGet: Use `wget.exe` if available
# if (Get-Command wget.exe -ErrorAction SilentlyContinue | Test-Path) {
#   rm alias:wget -ErrorAction SilentlyContinue
# }
# # Directory Listing: Use `ls.exe` if available
# if (Get-Command ls.exe -ErrorAction SilentlyContinue | Test-Path) {
#   rm alias:ls -ErrorAction SilentlyContinue
#   # Set `ls` to call `ls.exe` and always use --color
#   ${function:ls} = { ls.exe --color @args }
#   # List all files in long format
#   ${function:l} = { ls -lF @args }
#   # List all files in long format, including hidden files
#   ${function:la} = { ls -laF @args }
#   # List only directories
#   ${function:lsd} = { Get-ChildItem -Directory -Force @args }
# }
# else {
#   # List all files, including hidden files
#   ${function:la} = { ls -Force @args }
#   # List only directories
#   ${function:lsd} = { Get-ChildItem -Directory -Force @args }
# }
# # curl: Use `curl.exe` if available
# if (Get-Command curl.exe -ErrorAction SilentlyContinue | Test-Path) {
#   rm alias:curl -ErrorAction SilentlyContinue
#   # Set `curl` to call `curl.exe`
#   ${function:curl} = { curl.exe @args }
#   # Gzip-enabled `curl`
#   ${function:gurl} = { curl --compressed @args }
# }
# else {
#   # Gzip-enabled `curl`
#   ${function:gurl} = { curl -TransferEncoding GZip }
# }
# # remove R alias to enable R.exe from PATH
# # 'R' taken by PS Invoke-History
# if (Get-Command R.exe -ErrorAction SilentlyContinue | Test-Path) {
#   Remove-Item Alias:r -ErrorAction SilentlyContinue
#   ${function:r} = { R.exe @args }
# }
# # Create a new directory and enter it
# Set-Alias mkd CreateAndSet-Directory
# # Determine size of a file or total size of a directory
# Set-Alias fs Get-DiskUsage
# # Empty the Recycle Bin on all drives
# Set-Alias emptytrash Empty-RecycleBin
# # Cleanup old files all drives
# Set-Alias cleandisks Clean-Disks
# # Reload the shell
# Set-Alias reload Reload-Powershell
# # http://xkcd.com/530/
# Set-Alias mute Set-SoundMute
# Set-Alias unmute Set-SoundUnmute
# # Update installed Ruby Gems, NPM, and their installed packages.
# Set-Alias update System-Update
```

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

## Scripts

- Various powershell scripts for automation and configurations.

