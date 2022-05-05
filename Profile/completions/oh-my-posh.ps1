# Invoke s-search's completion function for powershell
If (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    Invoke-Expression -Command $(oh-my-posh completion powershell | Out-String)
}
