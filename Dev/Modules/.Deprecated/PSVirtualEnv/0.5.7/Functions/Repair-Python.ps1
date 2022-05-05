# ===========================================================================
#   Repair-Python.ps1 ---------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Repair-Python {

    <#
    .SYNOPSIS
        Install or upgrade required packages for full functionality of module
        .
    .DESCRIPTION
        Install or upgrade required packages for full functionality of module. The installation include the packages 'pip', 'setuptools and ''virtualenv'. It can be performed online or offline.

    .PARAMETER SILENT

    .INPUTS
        None.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param (
        [Parameter(HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent
    )

    Process {

        if (-not [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.ProjectOffline)) {

            Install-VirtualEnv -Name "python" -Upgrade -Package "pip", "setuptools",  "virtualenv" -Silent:$Silent

            # if (-not $( $(. $python_exe -m pip list) -match "virtualenv")){  
            # Write-FormattedWarning -Message "The python distribution does not provide the required package 'virtualenv'. Package will be installed automatically for full functionality." -Module $PSVirtualEnv.Name -Space
            # }
        }
        else {
            Install-VirtualEnv -Name "python" -Offline "\offline-pip" -Silent:$Silent
        }
    }
}