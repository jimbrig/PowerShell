# ===========================================================================
#   Remove-VirtualEnv.ps1 ---------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Remove-VirtualEnv  {

    <#
    .SYNOPSIS
        Removes a specific virtual environment in the predefined directory.

    .DESCRIPTION
        Removes a specific virtual environment in the predefined virtual environment directory. All available virtual environments can be accessed by autocompletion.

    .PARAMETER Name

    .EXAMPLE
        PS C:\> Remove-VirtualEnv -Name venv
        
        [PSVirtualEnv]::SUCCESS: Virtual Environment 'venv' was deleted permanently.

        -----------
        Description
        Removes the specified virtual environment 'venv'. All available virtual environments can be accessed by autocompletion.

    .EXAMPLE
        PS C:\> rm-venv venv
        
        [PSVirtualEnv]::SUCCESS: Virtual Environment 'venv' was deleted permanently.

        -----------
        Description
        Removes the specified virtual environment 'venv' with predefined alias of command.

    .INPUTS
        System.String. Name of virtual environment, which should be removed.
    
    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([PSCustomObject])]

    Param(
        [ValidateSet([ValidateVirtualEnv])]
        [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    Process{
        
        # check whether the specified virtual environment exists
        if (-not $(Test-VirtualEnv -Name $Name -Verbose)){
            Get-VirtualEnv
            return
        }

        # deactivation of a running virtual environment
        Restore-VirtualEnv

        # get the full path of the specified virtual environment, which is located in the predefined system path
        $virtualEnvDir = Get-VirtualEnvPath -Name $Name
        
        # remove specified virtual environment
        Remove-Item -Path $virtualEnvDir -Recurse -Force
        
        # check whether the virtual environment could be removed
        if (-not $(Test-Path -Path $virtualEnvDir)) {
            Write-FormattedSuccess -Message "Virtual Environment '$Name' was deleted permanently." -Module $PSVirtualEnv.Name -Space
        }
        else {
            Write-FormattedError -Message "Virtual environment '$Name' could not be deleted." -Module $PSVirtualEnv.Name -Space
        }

        return $(Get-VirtualEnv)

    }
}
