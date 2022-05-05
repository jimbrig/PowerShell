# ===========================================================================
#   Start-VirtualEnv.ps1 ----------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Start-VirtualEnv {

    <#
    .SYNOPSIS
        Starts a specific virtual environment in the predefined directory.

    .DESCRIPTION
        Starts a specific virtual environment in the predefined virtual environment directory. All available virtual environments can be accessed by autocompletion.

    .PARAMETER Name

    .PARAMETER Silent

    .EXAMPLE
        PS C:\> Start-VirtualEnv -Name venv

        [PSVirtualEnv]::SUCCESS: Virtual enviroment 'venv' was started.

        [venv] PS C:\>
        
        -----------
        Description
        Starts the virtual environment 'venv', which must exist in the predefined directory. All available virtual environments can be accessed by autocompletion.

    .EXAMPLE
        PS C:\> start-venv venv

        [PSVirtualEnv]::SUCCESS: Virtual enviroment 'venv' was started.

        -----------
        Description
        Starts the virtual environment 'venv' with predefined alias of command.

    .INPUTS
        System.String. Name of virtual environment, which should be started.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(
        [ValidateSet([ValidateVirtualEnv])]     
        [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name,

        [Parameter(HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent
    )

    Process {

        # check whether the specified virtual environment exists
        if (-not $(Test-VirtualEnv -Name $Name -Verbose)){
            Get-VirtualEnv
            return $Null
        }

        # deactivation of a running virtual environment
        Restore-VirtualEnv

        # activate the virtual environment
        Set-VirtualEnv -Name $Name

        if (-not $Silent) {
            Write-FormattedSuccess -Message "Virtual enviroment '$Name' was started." -Module $PSVirtualEnv.Name -Space
        }
    }
}
