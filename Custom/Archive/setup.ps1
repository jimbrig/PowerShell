### Set ExecutionPolicy
Set-ExecutionPolicy Unrestricted -Scope CurrentUser

### Update Help for Modules
Write-Host "Updating Help..." -ForegroundColor "Yellow"
Update-Help -Force

### Package Providers
Write-Host "Installing Package Providers..." -ForegroundColor "Yellow"
Get-PackageProvider NuGet -Force | Out-Null

# Chocolatey Provider is not ready yet. Use normal Chocolatey
#Get-PackageProvider Chocolatey -Force
#Set-PackageSource -Name chocolatey -Trusted

### Install PowerShell Modules
Write-Host "Installing PowerShell Modules..." -ForegroundColor "Yellow"
Install-Module Posh-Git -Scope CurrentUser -Force
Install-Module PSWindowsUpdate -Scope CurrentUser -Force
Install-Module oh-my-posh -Scope CurrentUser -Force
Install-Module Microsoft.PowerShell.Utility -Scope CurrentUser -Force
Install-Module ZLocation -Scope CurrentUser -Force

. .\install-helpers.ps1

# edge canary
Install-fromURL "https://go.microsoft.com/fwlink/?linkid=2084706&Channel=Canary&language=en" "EdgeCanary"

# obsidian
Install-Github "obsidianmd/obsidian-releases" "*.exe" "Obsidian"

# Import-WslCommand "apt", "awk", "emacs", "grep", "head", "less", "ls", "man", "sed", "seq", "ssh", "sudo", "tail", "vim"

### winget

### Chocolatey
Write-Host "Installing Desktop Utilities..." -ForegroundColor "Yellow"
if ((which cinst) -eq $null) {
    Invoke-Expression (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
}

# manual installations
. .\install-function-helpers.ps1






