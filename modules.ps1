Function Backup-Modules {
  $savefile = "$env:OneDrive\Documents\PowerShell\modules.json"
  if (test-path $savefile) { Rename-Item -Path $savefile -NewName ($savefile + ".bak") }
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
