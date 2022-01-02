#Requires -Version 7

# ----------------------------------------------------
# Current User, All Hosts Powershell Core v7 $PROFILE:
# ----------------------------------------------------

$psfiles = Join-Path (Split-Path -Parent $profile) "Profile" | Get-ChildItem -Filter "*.ps1"
ForEach ($file in $psfiles) { . $file }
