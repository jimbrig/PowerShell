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
