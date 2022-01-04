# we are also using the Logging Part from here: https://github.com/Seidlm/PowerShell-Templates/blob/main/Logging%20Function.ps1

#region Parameters
[string]$LogPath = "C:\Users\MichaelSeidlau2mator\OneDrive - Seidl Michael\2-au2mator\1 - TECHGUY\GitHub\PowerShell-Templates" #Path to store the Lofgile, only local or Hybrid
[string]$LogfileName = "InstallModule" #FileName of the Logfile, only local or Hybrid
[int]$DeleteAfterDays = 10 #Time Period in Days when older Files will be deleted, only local or Hybrid

#endregion Parameters

#region Function
function Write-TechguyLog {
    [CmdletBinding()]
    param
    (
        [ValidateSet('DEBUG', 'INFO', 'WARNING', 'ERROR')]
        [string]$Type,
        [string]$Text
    )

    #Decide Platform
    $environment = "local"
    if ($env:AZUREPS_HOST_ENVIRONMENT) { $environment = "AAnoHybrid" }
    if ($env:AUTOMATION_WORKER_CERTIFICATE) { $environment = "AAHybrid" }
    
    if ($environment -eq "AAHybrid" -or $environment -eq "local") {
        # Set logging path
        if (!(Test-Path -Path $logPath)) {
            try {
                $null = New-Item -Path $logPath -ItemType Directory
                Write-Verbose ("Path: ""{0}"" was created." -f $logPath)
            }
            catch {
                Write-Verbose ("Path: ""{0}"" couldn't be created." -f $logPath)
            }
        }
        else {
            Write-Verbose ("Path: ""{0}"" already exists." -f $logPath)
        }
        [string]$logFile = '{0}\{1}_{2}.log' -f $logPath, $(Get-Date -Format 'yyyyMMdd'), $LogfileName
        $logEntry = '{0}: <{1}> {2}' -f $(Get-Date -Format yyyyMMdd_HHMMss), $Type, $Text
        Add-Content -Path $logFile -Value $logEntry
    }
    elseif ($environment -eq "AAHybrid" -or $environment -eq "AAnoHybrid") {
        $logEntry = '{0}: <{1}> {2}' -f $(Get-Date -Format yyyyMMdd_HHMMss), $Type, $Text

        switch ($Type) {
            INFO { Write-Output $logEntry }
            WARNING { Write-Warning $logEntry }
            ERROR { Write-Error $logEntry }
            DEBUG { Write-Output $logEntry }
            Default { Write-Output $logEntry }
        }
    }
}
#endregion Function
Write-TechguyLog -Type INFO -Text "START Script"




$Modules = @("sqlServer", "dbatools") 

foreach ($Module in $Modules) {
    if (Get-Module -ListAvailable -Name $Module) {
        Write-TechguyLog -Type INFO -Text "Module is already installed:  $Module"        
    }
    else {
        Write-TechguyLog -Type INFO -Text "Module is not installed, try simple method:  $Module"
        try {
            Install-Module $Module -Force -Confirm:$false -ErrorAction Stop

            Write-TechguyLog -Type INFO -Text "Module was installed the simple way:  $Module"
        }
        catch {
            Write-TechguyLog -Type INFO -Text "Module is not installed, try the advanced way:  $Module"

            try {
                Set-ExecutionPolicy -ExecutionPolicy Unrestricted -force
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                Install-PackageProvider -Name NuGet  -MinimumVersion 2.8.5.201 -Force 
                Install-Module $Module -Force -Confirm:$false
                Write-TechguyLog -Type INFO -Text "Module was installed the advanced way:  $Module"
            }
            catch {
                Write-TechguyLog -Type INFO -Text "could not install module:  $Module"

            }
        }
    }
    try {
        Write-TechguyLog -Type INFO -Text  "Import Module:  $Module"
        Import-module $Module
    
    }
    catch {
        Write-TechguyLog -Type INFO -Text "could not import module:  $Module"

    }
}



#Clean Logs
if ($environment -eq "AAHybrid" -or $environment -eq "local") {
    Write-TechguyLog -Type INFO -Text "Clean Log Files"
    $limit = (Get-Date).AddDays(-$DeleteAfterDays)
    Get-ChildItem -Path $LogPath -Filter "*$LogfileName.log" | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force
}

Write-TechguyLog -Type INFO -Text "END Script"