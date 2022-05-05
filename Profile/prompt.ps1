# Prompt
If (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config $ENV:POSH_THEMES_PATH\wopian.omp.json | Invoke-Expression
}

# Write Current Version and Execution Policy Details:
Write-Host "PowerShell Version: $($psversiontable.psversion) - ExecutionPolicy: $(Get-ExecutionPolicy)" -ForegroundColor yellow

# ZLocation must be after all prompt changes:
Import-Module ZLocation
Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"
