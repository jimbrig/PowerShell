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

# Git Cliff (Changelog Generator):

# using namespace System.Management.Automation
# using namespace System.Management.Automation.Language

# Register-ArgumentCompleter -Native -CommandName 'git-cliff' -ScriptBlock {
#     param($wordToComplete, $commandAst, $cursorPosition)

#     $commandElements = $commandAst.CommandElements
#     $command = @(
#         'git-cliff'
#         for ($i = 1; $i -lt $commandElements.Count; $i++) {
#             $element = $commandElements[$i]
#             if ($element -isnot [StringConstantExpressionAst] -or
#                 $element.StringConstantType -ne [StringConstantType]::BareWord -or
#                 $element.Value.StartsWith('-')) {
#                 break
#         }
#         $element.Value
#     }) -join ';'

#     $completions = @(switch ($command) {
#         'git-cliff' {
#             [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Sets the configuration file')
#             [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Sets the configuration file')
#             [CompletionResult]::new('-w', 'w', [CompletionResultType]::ParameterName, 'Sets the working directory')
#             [CompletionResult]::new('--workdir', 'workdir', [CompletionResultType]::ParameterName, 'Sets the working directory')
#             [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Sets the repository to parse commits from')
#             [CompletionResult]::new('--repository', 'repository', [CompletionResultType]::ParameterName, 'Sets the repository to parse commits from')
#             [CompletionResult]::new('-p', 'p', [CompletionResultType]::ParameterName, 'Prepends entries to the given changelog file')
#             [CompletionResult]::new('--prepend', 'prepend', [CompletionResultType]::ParameterName, 'Prepends entries to the given changelog file')
#             [CompletionResult]::new('-o', 'o', [CompletionResultType]::ParameterName, 'Writes output to the given file')
#             [CompletionResult]::new('--output', 'output', [CompletionResultType]::ParameterName, 'Writes output to the given file')
#             [CompletionResult]::new('-t', 't', [CompletionResultType]::ParameterName, 'Sets the tag for the latest version')
#             [CompletionResult]::new('--tag', 'tag', [CompletionResultType]::ParameterName, 'Sets the tag for the latest version')
#             [CompletionResult]::new('-b', 'b', [CompletionResultType]::ParameterName, 'Sets the template for the changelog body')
#             [CompletionResult]::new('--body', 'body', [CompletionResultType]::ParameterName, 'Sets the template for the changelog body')
#             [CompletionResult]::new('-s', 's', [CompletionResultType]::ParameterName, 'Strips the given parts from the changelog')
#             [CompletionResult]::new('--strip', 'strip', [CompletionResultType]::ParameterName, 'Strips the given parts from the changelog')
#             [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterName, 'Increases the logging verbosity')
#             [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Increases the logging verbosity')
#             [CompletionResult]::new('-i', 'i', [CompletionResultType]::ParameterName, 'Writes the default configuration file to cliff.toml')
#             [CompletionResult]::new('--init', 'init', [CompletionResultType]::ParameterName, 'Writes the default configuration file to cliff.toml')
#             [CompletionResult]::new('-l', 'l', [CompletionResultType]::ParameterName, 'Processes the commits starting from the latest tag')
#             [CompletionResult]::new('--latest', 'latest', [CompletionResultType]::ParameterName, 'Processes the commits starting from the latest tag')
#             [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterName, 'Processes the commits that do not belong to a tag')
#             [CompletionResult]::new('--unreleased', 'unreleased', [CompletionResultType]::ParameterName, 'Processes the commits that do not belong to a tag')
#             [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
#             [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
#             [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
#             [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
#             break
#         }
#     })

#     $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
#         Sort-Object -Property ListItemText
# }


# dotnet CLI (see https://www.hanselman.com/blog/how-to-use-autocomplete-at-the-command-line-for-dotnet-git-winget-and-more)
# Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
#   param($commandName, $wordToComplete, $cursorPosition)
#   dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
#     [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
#   }
# }

# Keep Completion
# Invoke-Expression -Command '$(keep completion | Out-String)'
