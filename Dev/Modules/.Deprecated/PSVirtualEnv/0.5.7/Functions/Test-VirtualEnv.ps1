# ===========================================================================
#   Test-VirtualEnv.ps1 -----------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Test-VirtualEnv {

    <#
    .SYNOPSIS
        Checks if there exists a specific virtual environment.

    .DESCRIPTION
        Checks if there exists a specific virtual environment in the predefined directory.

    .PARAMETER Name

    .EXAMPLE
        PS C:\> Test-VirtualEnv -Name venv

        True

        -----------
        Description
        Checks whether the virtual environment 'venv' exists.

    .INPUTS
        System.String. Name of virtual environment to be tested.
    
    .OUTPUTS
        Boolean. True if the specified virtual environment exists.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Boolean])]

    Param(        
        [Parameter(Position=1, ValueFromPipeline, HelpMessage="Name of virtual environment to be tested.")]
        [System.String] $Name
    )

    Process {

        # check whether a virtual environment is specified
        if (!$Name) {
            Write-FormattedError -Message "There is no virtual environment specified." -Module $PSVirtualEnv.Name -Space -Silent:(!$VerbosePreference)
            return $False
        }

        # check whether the test of a python distribution is specified
        if($Name -eq "python") {
            if (Find-Python){
                return $True
            }
        }

        # check if there exists the specified virtual environment in the predefined directory
        if ( -not $(Get-ChildItem $PSVirtualEnv.WorkDir | Where-Object {$_.Name -eq $Name} )) {
            Write-FormattedError -Message "The virtual environment '$Name' does not exist." -Module $PSVirtualEnv.Name -Space -Silent:(!$VerbosePreference)
            return $False
        }

        # get the full path of the specified virtual environment, which is located in the predefined system path and test the resulting path
        if ( -not $(Test-Path $(Get-VirtualEnvActivationScript -Name $Name) )) {
            Write-FormattedError -Message "Unable to find the activation script. The virtual environment '$Name' seems compromized." -Module $PSVirtualEnv.Name -Space -Silent:(!$VerbosePreference)
            return $False
        }

        return $True
    }
}
