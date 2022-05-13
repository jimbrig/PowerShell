# -------------------------
# PowerShell Completion
# -------------------------

Import-Module Microsoft.PowerShell.Utility

$files = Get-ChildItem -Path $(Get-Location) -Filter '*.ps1'
ForEach ($file in $files) {
  . $file
}
