Function Write-Log {
    <#
    .SYNOPSIS
    Write a log to a designated location on the local file system.
    .DESCRIPTION
    This function is used to write application specific logs to a log file.
    .PARAMETER logPath
    Directory where logs are stored: defaults to "$env:APPDATA\powershell\Logs".
    .PARAMETER logFileName
    Filename of the log to be appended after the date: defaults to "PSWinSetup".
    .PARAMETER deleteAfterDays
    Number of days to retain logs for.
    .PARAMETER Type
    One of DEBUG, INFO, WARNING, ERROR
    .PARAMETER Text
    Text to write to log.
    .EXAMPLE
    Write-Log -Type INFO -Text Script Started
    Write-Log -Type ERROR -Text Script Failed    
    #>
    [CmdletBinding()]
    param (
        [string]$logPath = "$env:APPDATA\powershell\Logs",
        [string]$logFileName = "PSWinSetup",
        [int]$deleteAfterDays = $null,
        [ValidateSet('DEBUG', 'INFO', 'WARNING', 'ERROR')]
        [string]$Type,
        [string]$Text
    )

    if (!(Test-Path -Path $logPath)) { New-Item -Path $logPath -ItemType Directory -Force }
    
    [string]$logFile = '{0}\{1}_{2}.log' -f $logPath, $(Get-Date -Format 'yyyy-MM-dd'), $logfileName
    If (!(Test-Path -Path $logFile)) { New-Item -Path $logFile -ItemType File -Force }
    $logEntry = '{0}: <{1}> {2}' -f $(Get-Date -Format 'yyyy-MM-dd HH:MM:ss'), $Type, $Text
    Add-Content -Path $logFile -Value $logEntry

    $limit = (Get-Date).AddDays(-$deleteAfterDays)
    Get-ChildItem -Path $logPath -Filter "*$logfileName.log" | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force
}

Function Open-Logs {
    param()
    codee "$env:APPDATA\powershell\Logs"    
}