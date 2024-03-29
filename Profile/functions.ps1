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
