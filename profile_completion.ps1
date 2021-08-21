# Completion

# Shell Completion Modules
Import-Module DockerCompletion
Import-Module Microsoft.PowerShell.Utility
Import-Module C:\Users\jimmy\scoop\modules\scoop-completion

# Github CLI autocompletion - see issue for reference: https://github.com/cli/cli/issues/695#issuecomment-619247050
Invoke-Expression -Command $(gh completion -s powershell | Out-String)

# winget (see https://github.com/microsoft/winget-cli/blob/master/doc/Completion.md#powershell)
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  $Local:word = $wordToComplete.Replace('"', '""')
  $Local:ast = $commandAst.ToString().Replace('"', '""')
  winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

# Chocolatey Completion
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# dotnet CLI (see https://www.hanselman.com/blog/how-to-use-autocomplete-at-the-command-line-for-dotnet-git-winget-and-more)
# Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
#   param($commandName, $wordToComplete, $cursorPosition)
#   dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
#     [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
#   }
# }

# Keep Completion
# Invoke-Expression -Command '$(keep completion | Out-String)'
