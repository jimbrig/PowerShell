# create modules.json
$mods = Get-ChildItem
Write-Color "Removing previous ", "modules.json", " file." -Color "green", "red", "green"
if (test-path modules.json) { remove-item -Path modules.json }
$mods.Name | ConvertTo-Json >> modules.json
Write-Color "✔️ Successfully updated ", "modules.json ", "." -Color "green", "red", "green"
$push = Read-Host -Prompt "Push to github? (y/n)"
if ($push) {
  Set-Location ..
  git add Modules/**
  git commit -m "Updated modules."
  git push
}
Write-Color "✔️ Successfully pushed to github."
