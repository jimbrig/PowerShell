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
