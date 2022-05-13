# Github-Label CLI autocompletion
If (Get-Command gh-label -ErrorAction SilentlyContinue) {
    Invoke-Expression -Command $(gh-label completion powershell | Out-String)
}