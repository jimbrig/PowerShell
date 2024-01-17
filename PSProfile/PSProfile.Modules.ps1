# Alternate PSModulesPath (User)
if ($isWindows) {
    $LocalAppDataModulePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath 'PowerShell\Modules'
    if (-not(Test-Path -Path $LocalAppDataModulePath)) {
        New-Item -Path $LocalAppDataModulePath -ItemType Directory -Force
    }
    # Add to Start of PSModulePath
    $env:PSModulePath = $LocalAppDataModulePath + [IO.Path]::PathSeparator + $env:PSModulePath
}

$ProfileModulesToImport = @(
    'PSReadLine'
    'posh-git'
    'Terminal-Icons'
    'PSFzf'
    'PSEverything'
    'CompletionPredictor'
    'Microsoft.PowerShell.ConsoleGuiTools'
    'F7History'
)

ForEach ($Mod in $ProfileModulesToImport) {
    try {
        Write-Verbose "Importing Module: $Mod"
        Import-Module $Mod -ErrorAction Stop
    } catch {
        Write-Warning "Failed to install module: $Mod"
        try {
            Install-PSResource $Mod -Scope CurrentUser -Force -ErrorAction Stop
        } catch {
            Write-Warning "Failed to install module: $Mod"
            Continue
        }
    } finally {
        Import-Module -Name $Mod -ErrorAction SilentlyContinue
    }
}

if (Get-PSResource -Name ZLocation) {
    Import-Module ZLocation
    Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"
}
