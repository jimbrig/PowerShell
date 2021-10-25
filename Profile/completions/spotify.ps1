# Spotify TUI
If (Get-Command spt -ErrorAction SilentlyContinue) {
    Invoke-Expression -Command $(spt --completions power-shell | Out-String)
}