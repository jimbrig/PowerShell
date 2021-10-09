<#
.Synopsis
   Short description
    This script will be used for downloafing the latest TortoiseGit version from its official site.
.DESCRIPTION
   Long description
    2021-02-06 Sukri Created.
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
    Author : Sukri Kadir
    Email  : msmak1990@gmail.com
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>

function Get-AdminRights {
  Param
  (
    [ValidateNotNullOrEmpty()]
    [String]
    $IsAdministrator = $null # initialize the variable to null.
  )

  Begin {
    #get boolean value if script ran with administration right.
    $IsAdministrator = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  }
  Process {
    #verbose the message.
    if ($IsAdministrator -eq $true) {
      Write-Warning -Message "It is currently in administration right." -WarningAction Continue
    }

    if ($IsAdministrator -ne $true) {
      Write-Warning -Message "It is currently NOT in administration right." -WarningAction Continue
    }
  }
  End {
    return $IsAdministrator
  }
}
