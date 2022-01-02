# Prompt
Set-PoshPrompt -Theme wopian -ErrorAction SilentlyContinue

# Write Current Version and Execution Policy Details:
Write-Host "PowerShell Version: $($psversiontable.psversion) - ExecutionPolicy: $(Get-ExecutionPolicy)" -ForegroundColor yellow

# ZLocation must be after all prompt changes:
Import-Module ZLocation
Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"
