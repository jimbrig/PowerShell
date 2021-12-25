:# ------------------------------------------
# File  : System-Functions.ps1
# Author: Jimmy Briggs
# Title : System Functions
# ------------------------------------------

# Check Disk
Function Invoke-Checkdisk { & chkdsk C: /f /r /x }

# Optional Features
Function Get-OptionalFeatures { & Get-WindowsCapability -Online | Where-Object { $_.State -eq 'Installed' } }

# SFC Scan
Function Invoke-SFCScan { & sfc /scannow }

# Admin
Function Test-Admin { 
    if (!(Verify-Elevated)) { 
        $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"; 
        $newProcess.Arguments = $myInvocation.MyCommand.Definition; 
        $newProcess.Verb = "runas"; 
        [System.Diagnostics.Process]::Start($newProcess); 
        exit 
  }
}

# Updates
Function Update-Npm { & npm install npm@latest -g }
Function Update-Pip { & python -m pip install --upgrade pip }
Function Update-Pwsh { & iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI" }
Function Update-Gcloud { & gcloud components update }

# MSStore
Function Reset-MSStore { & wsreset.exe }
Function Reset-StoreApps {
    Get-AppxPackage -allusers | foreach {Add-AppxPackage -register "$($_.InstallLocation)\appxmanifest.xml" -DisableDevelopmentMode}
}

# Drivers
Function Get-Drivers { & dism /online /get-drivers /format:table }

# Cleanup
Function Invoke-DiskCleanup { & sudo cleanmgr.exe }
Function Invoke-DiskCleanupAdvanced { & cmd.exe /c Cleanmgr /sageset:65535 & Cleanmgr /sagerun:65535 }

# winSAT
Function Invoke-WinSAT { & winSAT formal -restart }
Function Get-WinSATReport { & Get-CimInstance Win32_WinSat }

# Virus Scanning
Function Invoke-VirusScan { & cmd.exe "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1 }
Function Invoke-VirusScanFull { & start-mpscan -scantype fullscan }

# Repair Image
Function Repair-WinImage { 
    Dism.exe /Online /Cleanup-Image /ScanHealth
    Dism.exe /Online /Cleanup-Image /RestoreHealth
    Dism.exe /online /Cleanup-Image /StartComponentCleanup
}

# NOTE: pwsh syntax: # Function Repair-WinImage { Repair-WindowsImage -Online -ScanHealth }

Function Invoke-MemoryDiagnostic { & mdsched.exe }

Function Create-NetReport { & netsh wlan show wlanreport }

# Windows Updates
Function Reset-WUComponents { 
    net stop bits
    net stop wuavserv
    net stop appidsvc
    net stop cryptsvc
    ipconfig /flushdns
    del /s /q /f "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr*.dat"
    del /s /q /f "%SYSTEMROOT%\Logs\WindowsUpdate\*"
    net start bits
    net start weavserv
    net start appidsvc
    net start cryptsvc
    $restart = Read-Host "Restart?"
    if ($restart -eq "y") { Restart-Computer }
}