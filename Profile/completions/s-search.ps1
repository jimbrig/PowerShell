# Invoke s-search's completion function for powershell
Invoke-Expression -Command $(s --completion powershell | Out-String)
