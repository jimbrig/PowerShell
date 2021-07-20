#Requires -Version 7

# Current User, Current Host Powershell Core v7 $PROFILE:

# trust PSGallery
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# import modules
Import-Module posh-git
Import-Module Terminal-Icons
Import-Module oh-my-posh
oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh)\themes\wopian.omp.json" | Invoke-Expression


Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Tab -Function Complete

Import-Module DockerCompletion
Import-Module Microsoft.PowerShell.Utility
Import-Module PSWindowsUpdate
Import-Module ZLocation
Import-WslCommand "cal", "awk", "grep", "ls", "head", "less", "man", "sed", "seq", "ssh", "tail", "cal", "top", "wget"
Import-Module C:\Users\jimbr\scoop\modules\scoop-completion

$psdir = (Split-Path -parent $profile)

. "$psdir\profile_functions.ps1"
. "$psdir\profile_aliases.ps1"

# try { $null = Get-Command pshazz -ea stop; pshazz init 'default' } catch { }

# load functions then aliases
# $psdir = (Split-Path -parent $profile)
# Get-ChildItem "${psdir}\profile_functions.ps1" | ForEach-Object { .$_ }
# Get-ChildItem "${psdir}\profile_aliases.ps1" | ForEach-Object { .$_ }

# winget auto-completion
# Get-ChildItem "${psdir}\winget_autocompletion.ps1" | ForEach-Object { .$_ }

# Github CLI autocompletion
# see issue for reference: https://github.com/cli/cli/issues/695#issuecomment-619247050
# Invoke-Expression -Command $(gh completion -s powershell | Out-String)
# Get-ChildItem "${psdir}\ghcli_autocompletion.ps1" | ForEach-Object { .$_ }

# Chocolatey Completion
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Keep Completion -- UPDATE: BASH and ZSH ONLY :<
# Invoke-Expression -Command $(keep completion | Out-String)

# edit prompt
Write-Host “Custom PowerShell Environment Loaded”
Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"

