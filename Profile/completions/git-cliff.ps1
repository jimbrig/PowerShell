
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName 'git-cliff' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'git-cliff'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-')) {
                break
        }
        $element.Value
    }) -join ';'

    $completions = @(switch ($command) {
        'git-cliff' {
            [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Sets the configuration file')
            [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Sets the configuration file')
            [CompletionResult]::new('-w', 'w', [CompletionResultType]::ParameterName, 'Sets the working directory')
            [CompletionResult]::new('--workdir', 'workdir', [CompletionResultType]::ParameterName, 'Sets the working directory')
            [CompletionResult]::new('-r', 'r', [CompletionResultType]::ParameterName, 'Sets the git repository')
            [CompletionResult]::new('--repository', 'repository', [CompletionResultType]::ParameterName, 'Sets the git repository')
            [CompletionResult]::new('--commit-path', 'commit-path', [CompletionResultType]::ParameterName, 'Sets the directory to parse commits from')
            [CompletionResult]::new('-p', 'p', [CompletionResultType]::ParameterName, 'Prepends entries to the given changelog file')
            [CompletionResult]::new('--prepend', 'prepend', [CompletionResultType]::ParameterName, 'Prepends entries to the given changelog file')
            [CompletionResult]::new('-o', 'o', [CompletionResultType]::ParameterName, 'Writes output to the given file')
            [CompletionResult]::new('--output', 'output', [CompletionResultType]::ParameterName, 'Writes output to the given file')
            [CompletionResult]::new('-t', 't', [CompletionResultType]::ParameterName, 'Sets the tag for the latest version')
            [CompletionResult]::new('--tag', 'tag', [CompletionResultType]::ParameterName, 'Sets the tag for the latest version')
            [CompletionResult]::new('-b', 'b', [CompletionResultType]::ParameterName, 'Sets the template for the changelog body')
            [CompletionResult]::new('--body', 'body', [CompletionResultType]::ParameterName, 'Sets the template for the changelog body')
            [CompletionResult]::new('-s', 's', [CompletionResultType]::ParameterName, 'Strips the given parts from the changelog')
            [CompletionResult]::new('--strip', 'strip', [CompletionResultType]::ParameterName, 'Strips the given parts from the changelog')
            [CompletionResult]::new('--sort', 'sort', [CompletionResultType]::ParameterName, 'Sets sorting of the commits inside sections')
            [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterName, 'Increases the logging verbosity')
            [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Increases the logging verbosity')
            [CompletionResult]::new('-i', 'i', [CompletionResultType]::ParameterName, 'Writes the default configuration file to cliff.toml')
            [CompletionResult]::new('--init', 'init', [CompletionResultType]::ParameterName, 'Writes the default configuration file to cliff.toml')
            [CompletionResult]::new('-l', 'l', [CompletionResultType]::ParameterName, 'Processes the commits starting from the latest tag')
            [CompletionResult]::new('--latest', 'latest', [CompletionResultType]::ParameterName, 'Processes the commits starting from the latest tag')
            [CompletionResult]::new('-u', 'u', [CompletionResultType]::ParameterName, 'Processes the commits that do not belong to a tag')
            [CompletionResult]::new('--unreleased', 'unreleased', [CompletionResultType]::ParameterName, 'Processes the commits that do not belong to a tag')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            break
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
