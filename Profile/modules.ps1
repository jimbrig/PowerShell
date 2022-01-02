# -----------------------------
# Modules and Helper Functions
# -----------------------------

Import-Module -Name posh-git
Import-Module -Name oh-my-posh
Import-Module -Name Terminal-Icons
Import-Module -Name PSReadLine

# Enable Posh-Git
$env:POSH_GIT_ENABLED = $true

# --------
# Helpers
# --------

Function Backup-Modules {
  $modpath = ($env:PSModulePath -split ";")[0]
  $ymlpath = "$modpath\modules.yml"
  $jsonpath = "$modpath\modules.json"
  $mods = (Get-ChildItem $modpath -Directory).Name
  If (!(Get-Module -Name powershell-yaml -ErrorAction SilentlyContinue)) {
    ConvertTo-Json $mods > $jsonpath
  } else {
    ConvertTo-Yaml -Data $mods -OutFile $ymlpath -Force  
  }
  
}

Function Sync-Modules {
  $psdir = (Split-Path -Parent $profile)
  Set-Location $psdir
  git pull
  git add PowerShell/Modules/**
  git commit -m "config: Updated modules configurations"
  git-cliff -o "$HOME\Documents\CHANGELOG.md"
  git add CHANGELOG.md
  git commit -m "doc: update CHANGELOG.md for added modules"
  git push
}

Function Restore-Modules {
  $mods = Get-Content ~/.dotfiles/powershell/modules.json | ConvertFrom-Json

  foreach ($mod in $mods) {
    Write-Host "Installing PowerShell Module for Current User: $mod" -ForegroundColor Yellow
    Install-Module $mod -Scope CurrentUser -Force
  }
}

