# yq YAML CLI shell completion for PowerShell - https://mikefarah.gitbook.io/yq/commands/shell-completion#powershell
If (Get-Command yq -ErrorAction SilentlyContinue) {
    Invoke-Expression -Command $(yq shell-completion powershell | Out-String)
}
