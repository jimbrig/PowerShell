# ---------------------------------------------------------------------
# PowerShell Profile - Custom Functions
# ---------------------------------------------------------------------

Function Update-Environment {
    Refresh-Profile
    Refresh-Path
    Refresh-Module
    Refresh-Function
    Refresh-Alias
    Refresh-Variable

}
Function Invoke-ProfileReload {
    & $PROFILE
}

Function Get-PublicIP {
    (Invoke-WebRequest 'http://ifconfig.me/ip' ).Content
}

Function Get-Timestamp {
    Get-Date -Format u
}

Function Get-RandomPassword {
    $length = 16
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+'
    -join ((0..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
}

Function Update-WinGet {
    Params(
        [Switch]$Admin,
        [Switch]$Interactive
    )

    if (Get-PSResource -Name WingetTools -ErrorAction SilentlyContinue) {
        Import-Module WingetTools
    } else {
        Install-Module WingetTools -Force -SkipPublisherCheck
    }

    if ($Admin) {
    } else {
        winget upgrade --all
    }
}
Function Update-Chocolatey {}
Function Update-Scoop {}
Function Update-R {}
Function Update-Python {}

Function Update-Node {}

Function Update-Pip {}
Function Update-Windows {}

Function Mount-DevDrive {
    if (-not(Test-Path -Path 'X:\')) {

        if (Get-PSDrive -Name 'Dev' -ErrorAction SilentlyContinue) {
            Write-Host 'Mapped PSDrive for  DevDrive already exists. Aborting Mounting...' -ForegroundColor Yellow
            Return
        } else {

            $cmd = "sudo powershell.exe -Command 'Mount-VHD -Path I:\DevDrive\DevDrive.vhdx'"

            try {
                Write-Verbose 'Mounting DevDrive...'
                Invoke-Expression -Command $cmd
            } catch {
                Write-Warning 'Failed to mount DevDrive...'
            }

            Write-Verbose 'Creating DevDrive PSDrive...'
            New-PSDrive -Name 'Dev' -PSProvider FileSystem -Root 'X:\' -Scope Global
        }
    }
}

Function Set-LocationDesktop {
    Set-Location -Path "$env:USERPROFILE\Desktop"
}

Function Set-LocationDownloads {
    Set-Location -Path "$env:USERPROFILE\Downloads"
}

Function Set-LocationDocuments {
    Set-Location -Path "$env:USERPROFILE\Documents"
}

Function Set-LocationPictures {
    Set-Location -Path "$env:USERPROFILE\Pictures"
}

Function Set-LocationMusic {
    Set-Location -Path "$env:USERPROFILE\Music"
}

Function Set-LocationVideos {
    Set-Location -Path "$env:USERPROFILE\Videos"
}

Function Set-LocationDevDrive {
    Set-Location -Path 'Dev:'
}

Function cd... {
    Set-Location -Path '..\..'
}

Function cd.... {
    Set-Location -Path '..\..\..'
}

Function Get-MD5Hash { Get-FileHash -Algorithm MD5 $args }

Function Get-SHA1Hash { Get-FileHash -Algorithm SHA1 $args }

Function Get-SHA256Hash { Get-FileHash -Algorithm SHA256 $args }

Function Invoke-Notepad { notepad.exe $args }


# Drive shortcuts
function HKLM: { Set-Location HKLM: }
function HKCU: { Set-Location HKCU: }
function Env: { Set-Location Env: }

if (Test-Path HKCU:\SOFTWARE\Microsoft\OneDrive) {
    $onedrive = Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\OneDrive
    if (Test-Path $onedrive.UserFolder) {
        New-PSDrive -Name OneDrive -PSProvider FileSystem -Root $onedrive.UserFolder -Description 'OneDrive'
        function OneDrive: { Set-Location OneDrive: }
    }
    Remove-Variable onedrive
}

Function Invoke-Admin {
    if ($args.Count -gt 0) {
        $argList = "& '" + $args + "'"
        Start-Process "$PSHOME\pwsh.exe" -Verb runAs -ArgumentList $argList
    } else {
        Start-Process "$PSHOME\pwsh.exe" -Verb RunAs
    }
}

Function Edit-PSProfile {
    $cmd = "$Env:Editor $PROFILE.CurrentUserAllHosts"
    Invoke-Expression -Command $cmd
}

Function Edit-PSProfileProject {
    if (-not($ProfileRootPath)) {
        Write-Warning 'ProfileRootPath not found.'
        $Global:ProfileRootPath = Split-Path -Path $PROFILE -Parent
    }

    $cmd = "$Env:Editor $ProfileRootPath"
    Invoke-Expression -Command $cmd
}

Function Invoke-WingetUpdate {
    Import-Module WingetTools

}

# Get-ProfileFunctions: Lists all custom functions in the current PowerShell profile.

Function Get-PSProfileFunctions {
    <#
        .SYNOPSIS
            Lists all custom functions in the current PowerShell profile.
        .DESCRIPTION
            Lists all custom functions in the current PowerShell profile.
        .EXAMPLE
            Get-ProfileFunctions
        .NOTES
            Author: Jimmy Briggs <jimmy.briggs@jimbrig.com>
    #>

    $Functions = @(

        [PSCustomObject]@{
            Name        = 'Get-PSProfileFunctions'
            Description = 'Lists all custom functions in the current PowerShell profile.'
            Alias       = 'psprofilefunctions'
        }

        [PSCustomObject]@{
            Name        = 'Get-PSProfileModules'
            Description = 'Lists all loaded modules in the current PowerShell profile.'
            Alias       = 'psprofilemodules'
        }

        [PSCustomObject]@{
            Name        = 'Update-Environment'
            Description = 'Updates the current environment.'
            Alias       = 'refreshenv'
        }

        [PSCustomObject]@{
            Name        = 'Invoke-ProfileReload'
            Description = 'Reloads the current PowerShell profile.'
            Alias       = 'reloadpsprofile'
        }

        [PSCustomObject]@{
            Name        = 'Get-PublicIP'
            Description = 'Gets the public IP address of the current machine.'
            Alias       = 'publicip'
        }

        [PSCustomObject]@{
            Name        = 'Get-Timestamp'
            Description = 'Gets the current timestamp.'
            Alias       = 'timestamp'
        }

        [PSCustomObject]@{
            Name        = 'Get-RandomPassword'
            Description = 'Generates a random password.'
            Alias       = 'randompassword'
        }

        [PSCustomObject]@{
            Name        = 'Update-WinGet'
            Description = 'Updates the Windows Package Manager (WinGet).'
            Alias       = 'updatewinget'
        }

        [PSCustomObject]@{
            Name        = 'Update-Chocolatey'
            Description = 'Updates the Chocolatey Package Manager.'
            Alias       = 'updatechoco'
        }

        [PSCustomObject]@{
            Name        = 'Update-Scoop'
            Description = 'Updates the Scoop Package Manager.'
            Alias       = 'updatescoop'
        }

        [PSCustomObject]@{
            Name        = 'Update-R'
            Description = 'Updates the R Programming Language.'
            Alias       = 'updater'
        }

        [PSCustomObject]@{
            Name        = 'Update-Python'
            Description = 'Updates the Python Programming Language.'
            Alias       = 'updatepython'
        }

        [PSCustomObject]@{
            Name        = 'Update-Node'
            Description = 'Updates the Node.js JavaScript Runtime.'
            Alias       = 'updatenode'
        }

    )

    Write-Host 'PowerShell Profile Custom Functions:' -ForegroundColor Cyan

    $Functions | Format-Table -AutoSize
}
