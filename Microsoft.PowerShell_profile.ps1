#Requires -Version 7

# Current User, Current Host Powershell Core v7 $PROFILE:

# trust PSGallery
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# import modules
Import-Module posh-git
Import-Module Terminal-Icons
Import-Module oh-my-posh
Import-Module Posh-Sysmon
Import-Module PSFzf
Import-Module WslInterop
Import-Module PSWindowsUpdate
Import-Module ZLocation

# enable
$env:POSH_GIT_ENABLED = $true

# arrows for PSReadLine
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# Shell Completion
Import-Module DockerCompletion
Import-Module Microsoft.PowerShell.Utility
Import-Module C:\Users\jimmy\scoop\modules\scoop-completion

# Github CLI autocompletion
# see issue for reference: https://github.com/cli/cli/issues/695#issuecomment-619247050
Invoke-Expression -Command $(gh completion -s powershell | Out-String)

# dotnet CLI (see https://www.hanselman.com/blog/how-to-use-autocomplete-at-the-command-line-for-dotnet-git-winget-and-more)
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($commandName, $wordToComplete, $cursorPosition)
  dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

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

# Keep Completion
# Invoke-Expression -Command '$(keep completion | Out-String)'

# WSL interop
Import-WslCommand "awk", "grep", "ls", "head", "less", "man", "sed", "seq", "ssh", "tail", "cal", "top", "wget", "tree", "vim", "curl", "gcalcli"
$WslDefaultParameterValues = @{}
$WslDefaultParameterValues["ls"] = "-AFh --group-directories-first"
$WslDefaultParameterValues["grep"] = "-E"
$WslDefaultParameterValues["less"] = "-i"
$WslDefaultParameterValues["tree"] = "-L 1"

# Load functions and aliases
$psdir = (Split-Path -parent $profile)

. "$psdir\profile_functions.ps1"
. "$psdir\profile_aliases.ps1"

# edit prompt
Set-PoshPrompt -Theme wopian
# try { $null = Get-Command pshazz -ea stop; pshazz init 'default' } catch { }

Write-Host “Custom PowerShell Environment Loaded”
Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"
Write-Host -ForegroundColor Blue `n"Calendar:`n"
gcalcli.exe calw
Write-Host -ForegroundColor Blue "📝 Note: clear console with 'cls'"


