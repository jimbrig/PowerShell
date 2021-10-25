# Invoke s-search's completion function for powershell
If (Get-Command s -ErrorAction SilentlyContinue) {
    Invoke-Expression -Command $(s --completion powershell | Out-String)
}