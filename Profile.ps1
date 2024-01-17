using namespace System.Management.Automation
using namespace System.Management.Automation.Language
using namespace System.Diagnostics.CodeAnalysis

# Version: 0.1.0

# --------------------------------------------------------------------
# Current User, All Hosts Powershell Core v7 $PROFILE
# Path: $Home\Documents\PowerShell\Profile.ps1
# --------------------------------------------------------------------

<#
    .SYNOPSIS
        Current User, All Hosts PowerShell `$PROFILE`: `Profile.ps1`
    .DESCRIPTION
        This script is executed when a new PowerShell session is created for the current user, on any host.
    .PARAMETER Vanilla
        Runs a "vanilla" session, without any configurations, variables, customizations, modules or scripts pre-loaded.
    .PARAMETER NoImports
        Skips importing modules and scripts.
    .NOTES
        Author: Jimmy Briggs <jimmy.briggs@jimbrig.com>
#>
#Requires -Version 7
[SuppressMessageAttribute('PSAvoidAssignmentToAutomaticVariable', '', Justification = 'PS7 Polyfill')]
[SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Profile Script')]
Param(
    [Parameter()]
    [Switch]$Vanilla,

    [Parameter()]
    [Switch]$NoImports
)

# --------------------------------------------------------------------
# Profile Variables
# --------------------------------------------------------------------

# Profile Paths
$ProfileRootPath = Split-Path -Path $PROFILE -Parent
$ProfileSourcePath = Join-Path -Path $ProfileRootPath -ChildPath 'Profile'

# System Information
if ($PSEdition -eq 'Desktop') {
    $isWindows = $true
    $isLinux = $false
    $isMacOS = $false
}

# --------------------------------------------------------------------
# Profile Environment
# --------------------------------------------------------------------

# Set editor to VSCode
if (Get-Command code -Type Application -ErrorAction SilentlyContinue) {
    $ENV:EDITOR = 'code'
}

if ($Host.Name -eq 'ConsoleHost') {
    Write-Verbose "Detected Host: 'ConsoleHost'. Loading 'PSReadLine' Setup..."
    . "$ProfileSourcePath/Profile.PSReadLine.ps1"
}

. "$ProfileSourcePath/Profile.Shorthands.ps1"
. "$ProfileSourcePath/Profile.Helpers.ps1"
. "$ProfileSourcePath/Profile.Integrations.ps1"
. "$ProfileSourcePath/Profile.Modules.ps1"
