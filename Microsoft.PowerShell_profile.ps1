# #Requires -Version 7

# -------------------------------------------------------
# Current User, Current Host Powershell Core v7 $PROFILE:
# -------------------------------------------------------

$psdir = (Split-Path -Parent $profile)

# Load Functions, Aliases, Completions, and Modules
If (Test-Path "$psdir\Profile\functions.ps1") { . "$psdir\Profile\functions.ps1" }
If (Test-Path "$psdir\Profile\aliases.ps1") { . "$psdir\Profile\aliases.ps1" }
If (Test-Path "$psdir\Profile\completion.ps1") { . "$psdir\Profile\completion.ps1" }
If (Test-Path "$psdir\Profile\modules.ps1") { . "$psdir\Profile\modules.ps1" }

# Set PSReadLineOptions's (Beta Version Required):
If (!(!((Get-Module -Name PSReadLine).Version.Major -ge 2)) -and (!(Get-Module -Name PSReadLine).Version.Minor -ge 2)) {
    Install-Module -Name PSReadLine -AllowPrerelease -Force -AllowClobber -Scope CurrentUser
}
Set-PSReadLineOption -PredictionSource History -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue -ErrorAction SilentlyContinue