# -----------------------------
# Modules and Helper Functions
# -----------------------------

Import-Module posh-git
Import-Module oh-my-posh
Import-Module Terminal-Icons
Import-Module WslInterop
Import-Module PSWindowsUpdate
Import-Module PSWriteColor

# Enable Posh-Git
$env:POSH_GIT_ENABLED = $true

# --------
# Helpers
# --------

Function Backup-Modules {
  $savefile = "$env:OneDrive\Documents\PowerShell\modules.json"
  if (Test-Path $savefile) { Rename-Item -Path $savefile -NewName ($savefile + ".bak") }
  $mods = Get-ChildItem -Path $env:OneDrive\Documents\PowerShell\Modules -Directory
  $mods.Name | ConvertTo-Json > $savefile
}

Function Restore-Modules {
  $mods = Get-Content ~/.dotfiles/powershell/modules.json | ConvertFrom-Json

  foreach ($mod in $mods) {
    Write-Host "Installing PowerShell Module for Current User: $mod" -ForegroundColor Yellow
    Install-Module $mod -Scope CurrentUser -Force
  }
}

