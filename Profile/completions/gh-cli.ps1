# Github CLI autocompletion - see issue for reference: https://github.com/cli/cli/issues/695#issuecomment-619247050
If (Get-Command gh -ErrorAction SilentlyContinue) {
    Invoke-Expression -Command $(gh completion -s powershell | Out-String)
}