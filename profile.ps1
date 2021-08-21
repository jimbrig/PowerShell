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
Import-Module PSFzf
Import-Module PSEverything
Import-Module WslInterop
Import-Module PSWindowsUpdate
Import-Module ZLocation
Import-Module PSWriteColor

# Enable Posh-Git
$env:POSH_GIT_ENABLED = $true

# WSL Interop
Import-WslCommand "awk", "head", "less", "man", "sed", "seq", "tail", "cal", "top", "vim"
$WslDefaultParameterValues = @{}
$WslDefaultParameterValues["grep"] = "-E"
$WslDefaultParameterValues["less"] = "-i"

# Prompt
Set-PoshPrompt -Theme wopian
Write-Color "Custom PowerShell Environment Loaded", "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n", "Calendar:`n" -Color "Blue", "Green", "Yellow"
gcalcli.exe calw

# ----------
# DEPRECATED
# ----------

# PSReadLine

# unecessary
# Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
# Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# do not use this - will make tab list instead of toggle (CTRL + SPACE)
# Set-PSReadlineKeyHandler -Key Tab -Function Complete

# WSLInterop

# "ls", "grep", "tree", "gcalcli", "ssh", "wget, "curl" - Use powershell now
# $WslDefaultParameterValues["ls"] = "-AFh --group-directories-first"
# $WslDefaultParameterValues["tree"] = "-L 1"

# try { $null = Get-Command pshazz -ea stop; pshazz init 'default' } catch { }



