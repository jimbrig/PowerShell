# -----------------------------------------------------------------------------
# PowerShell Profile - Prompt
# -----------------------------------------------------------------------------

Class OMPThemes : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        $OMPThemes = ((Get-ChildItem -Path "$Env:POSH_THEMES_PATH" -Filter "*.omp.json").Name -replace ".omp.json", "")
        return [String[]]$OMPThemes
    }
}

Function Set-OMPTheme {
  [CmdletBinding()]
  Param(
    [ValidateSet([OMPThemes])]
    [String]$Theme
  )

  try {
    $ConfigPath = Join-Path "$Env:POSH_THEMES_PATH" "$Theme.omp.json"
    (& oh-my-posh init pwsh --config=$ConfigPath --print) -join "`n" | Invoke-Expression
  } catch [CommandNotFoundException] {
    Write-Warning "Failed to set oh-my-posh theme"
    return
  } finally {
    if ($?) {
      Write-Verbose "oh-my-posh theme set to '$Theme'"
      $Global:POSH_THEME = $Theme
    }
  }

}

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    Write-Verbose "Setting oh-my-posh theme..."
    Set-OMPTheme -Theme space
}
