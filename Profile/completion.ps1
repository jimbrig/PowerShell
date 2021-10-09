# -------------------------
# PowerShell Completion
# -------------------------

Import-Module Microsoft.PowerShell.Utility

$currpath = (Get-Location).ProviderPath
$files = Get-ChildItem -Path "$currpath\completions" -Filter "*.ps1"
ForEach ($file in $files) {
  . $file
}
