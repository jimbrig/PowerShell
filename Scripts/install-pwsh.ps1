<#
Run this with:
Invoke-Expression (invoke-webrequest -uri 'https://raw.githubusercontent.com/jimbrig/jimsdots/main/powershell/install-pwsh.ps1' -UseBasicParsing)
# Include IDE
Invoke-Expression (invoke-webrequest -uri 'https://raw.githubusercontent.com/jimbrig/jimsdots/main/powershell/install-pwsh.ps1' -UseBasicParsing -OutFile ./install-pwsh.ps1) ; . ./install-pwsh.ps1 -includeide
#>

Function install-pwsh {

  Param (
    [Switch]$includeide
  )

  If (!(Test-Path env:chocolateyinstall)) {
    write-host "Installing Chocolatey..."
    Invoke-WebRequestoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
  }
  If ($includeide) {
    choco upgrade -y powershell-core vscode-insiders.install
    code-insiders --install-extension ms-vscode.PowerShell

    Write-Host "*********************************************************************"
    Write-Host " How to setup core as the default PowerShell for visual studio code: "
    Write-Host "  https://github.com/PowerShell/PowerShell/blob/master/docs/learning-powershell/using-vscode.md"
    Write-Host
  }
}
