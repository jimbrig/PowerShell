# ===========================================================================
#   Set-VirtualEnvLocation.ps1 ----------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Set-VirtualEnvLocation {

    <#
    .SYNOPSIS
        Set the location of the predefined directory.

    .DESCRIPTION
        Set the location of the predefined virtual environment directory. All available virtual environments can be accessed by autocompletion.

    .PARAMETER Name

    .EXAMPLE
        PS C:\> Set-VirtualEnvLocation

        PS C:\Users\User\PSVirtualEnv>

        -----------
        Description
        Set the location of the predefined virtual environment directory.

    .EXAMPLE
        PS C:\> cd-venv

        PS C:\Users\User\PSVirtualEnv>

        -----------
        Description
        Set the location of the predefined virtual environment directory with predefined alias of command.

    .EXAMPLE
        PS C:\> Set-VirtualEnvLocation -Name venv

        PS C:\Users\User\PSVirtualEnv\venv>

        -----------
        Description
        Set the location of the specified virtual environment 'venv'. All available virtual environments can be accessed by autocompletion.

    .INPUTS
        None.
    
    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(
        [ValidateSet([ValidateVirtualEnv])]     
        [Parameter(Position=1, ValueFromPipeline, HelpMessage="Name of virtual environment, which should be started.")]
        [System.String] $Name
    )

    Process{
        
        # set location of virtual env working directory
        $path = $PSVirtualEnv.WorkDir
        if ($Name) {
            $path = Get-VirtualEnvPath $Name
        }

        Set-Location -Path $path

    }
}
