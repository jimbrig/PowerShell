# ---------------------------------
# PowerShell Core Profile Functions
# ---------------------------------

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

# Get's
# Function Get-ProDir { Split-Path -Path $PROFILE -Parent }
# Function Get-DevDir { "$HOME\Dev" }

# # "Open" Functions
# ${function:Open-Profile} = { code-insiders $PROFILE }
# ${function:Open-ProDir} = { & $path = Get-ProDir && Set-Location $path && explorer.exe . }
# ${function:Open-Aliases} = { & $path = Get-ProDir && Set-Location $path && code-insiders profile_aliases.ps1 }
# ${function:Open-Functions} = { & $path = Get-ProDir && Set-Location $path && code-insiders profile_functions.ps1 }

# # System Directories
# ${function:cdprogramfiles} = { Set-Location 'C:\Program Files' }
# ${function:cdprogramfiles86} = { Set-Location 'C:\Program Files (x86)' }
# ${function:cdprogramdata} = { Set-Location C:\ProgramData }
# ${function:cdwindows} = { Set-Location C:\Windows }

# # Change Directory Functions for Common Places (can remove and utilize `z`)
# ${function:cddev} = { Set-Location ~\Dev } # && explorer.exe . }
# ${function:cdsetup} = { Set-Location C:\Setup }
# ${function:cdtools} = { Set-Location C:\tools }
# ${function:cdenv} = { Set-Location C:\env }
# ${function:cdonedrive} = { Set-Location ~\OneDrive }
# ${function:cddesktop} = { Set-Location ~\Desktop }
# ${function:cddocuments} = { Set-Location ~\Documents }
# ${function:cddownloads} = { Set-Location ~\Downloads }
# ${function:cddots} = { Set-Location ~\.dotfiles }
# ${function:cdrdots} = { Set-Location ~\.config\R }
# ${function:cdconfig} = { Set-Location ~\.config }
# ${function:cdprodir} = { Set-Location ~\Documents\PowerShell }

# # R
#  # { Rscript -e "search_gh('$args')" }
# #${function:Search-GitHubR} = { $out = $args + Rscript -e "search_ghr('$args')" } https://github.com/search?q=language%3AR+%s

# # Dev Directory
# ${function:dev} = { Set-Location ~\Dev }
# ${function:jimbrig} = { Set-Location ~\Dev\jimbrig }
# ${function:docs} = { Set-Location ~\Dev\docs }
# ${function:sandbox} = { Set-Location ~\Dev\sandbox }
# ${function:mycode} = { Set-Location ~\Dev\code } # do not use code here due to `vscode`



# # Online Openers
# ${function:opengh} = { open https://github.com }
# ${function:openghjim} = { open https://github.com/jimbrig }

# # System Utilities and Maintanence

#
# ${function:System-Update} = { & "C:\env\bin\topgrade.exe" } # NOTE must have topgrade installed and in %PATH%


# # store and appx packages
# ${function:saveappxpkgs} = { & powerhshell Get-AppXPackage | Out-File -FilePath appx-package-list.txt }
# ${function:resetstore} = { & wsreset.exe }
# ${function:resetstorepkgs} = {
#   & powershell Get-AppXPackage | Foreach { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
# }

# # Update-Environment / Refresh Environment Variables


# # Cleanup System


# # Powershell Utilities
# ${function:updatepowerhell} = { Invoke-Expression "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI" }
# ${function:psversion} = { $PSVersionTable }
# ${function:propath} = { Get-Variable $PROFILE }
# ${function:prodir} = { Split-Path -Path $PROFILE -Parent }
# ${function:listaliases} = { Get-Alias }
#  #getpublicip



# # Git and Github
# ${function:gitstatus} = { & git status $args }
# ${function:ghclone} = { & gh repo clone $args }
# ${function:ghissues} = { & gh issue list -R $PWD }

# # Python and PIP
# ${function:pipupgradeall} = { { & pip freeze | ForEach-Object { $_.split('==')[0] } | ForEach-Object { pip install --upgrade $_ } } }
# ${function:upgradepip} = { & pip install --upgrade pip }
# ${function:upgradepip3} = { & pip3 install --upgrade pip3 }

# Navigational Functions
# ${function:~} = { Set-Location ~ }
# ${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
# ${function:...} = { Set-Location ..\.. }
# ${function:....} = { Set-Location ..\..\.. }
# ${function:.....} = { Set-Location ..\..\..\.. }
# ${function:......} = { Set-Location ..\..\..\..\.. }
