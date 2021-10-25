# Chocolatey Completion
If (Get-Command choco -ErrorAction SilentlyContinue) {
  $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
  }
}