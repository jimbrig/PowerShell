# ===========================================================================
#   Stop-VirtualEnv.ps1 -----------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Stop-VirtualEnv {

    <#
    .SYNOPSIS
        Stops current running  virtual environment.

    .DESCRIPTION
        Stops current running virtual environment.

    .PARAMETER Silent
    
    .EXAMPLE
        [venv] PS C:\> Stop-VirtualEnv

        [PSVirtualEnv]::SUCCESS: Virtual enviroment 'venv' was stopped.

        -----------
        Description
        Stops current virtual environment. 

    .EXAMPLE
        [venv] PS C:\> Stop-venv

        [PSVirtualEnv]::SUCCESS: Virtual enviroment 'venv' was stopped.

        -----------
        Description
        Stops current virtual environment with predefined alias of command.

    .INPUTS
        None.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent
    )

    Process { 

        # get a running virtual environment
        $old_venv = Get-ActiveVirtualEnv
        if (-not $old_venv){
            if (-not $Silent) {
                Write-FormattedWarning -Message "There is no running virtual enviroment." -Module $PSVirtualEnv.Name -Space
            }
            return
        }

        # deactivation of a running virtual environment
        Restore-VirtualEnv

        # if the environment variable is not empty, deactivation failed
        if (-not $Silent) {
            if ($old_venv -and  $old_venv -eq $(Get-ActiveVirtualEnv)) {
                Write-FormattedError -Message "Virtual enviroment '$old_venv' could not be stopped." -Module $PSVirtualEnv.Name -Space
            }         
            else{
                Write-FormattedSuccess -Message "Virtual enviroment '$old_venv' was stopped." -Module $PSVirtualEnv.Name -Space
            }
        }
    }
}
