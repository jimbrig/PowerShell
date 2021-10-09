# -------------------------
# PowerShell Completion
# -------------------------

Import-Module Microsoft.PowerShell.Utility

$path = "$PSScriptRoot\completions"
$files = Get-ChildItem -Path $path -Filter "*.ps1"
ForEach ($file in $files) {
  . $file
}
