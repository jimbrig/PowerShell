# dotnet CLI (see https://www.hanselman.com/blog/how-to-use-autocomplete-at-the-command-line-for-dotnet-git-winget-and-more)
If (Get-Command dotnet -ErrorAction SilentlyContinue) {
  Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
  }
}
