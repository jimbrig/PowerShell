# ===========================================================================
#   Get-Requirement.ps1 -----------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-Requirement {

    <#
    .SYNOPSIS
        Get the content of an existing requirement file.

    .DESCRIPTION
        Get the content of an existing requirement file in predefined requirements folder. All available requirement files can be accessed by autocompletion.
    
    .PARAMETER Requirement

    .EXAMPLE
        PS C:\>New-Requirement -Name venv
        PS C:\>Get-Requirement -Requirement \venv-requirements.txt
        Click==7.0
        PS C:\>

        -----------
        Description
        Get the content of an existing requirement file in predefined requirements folder. All available virtual environments can be accessed by autocompletion.

    .INPUTS
        System.String. Relative path of existing requirement file

    .OUTPUTS
        System.String. Content of an existing requirement file
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([System.String])]

    Param(
        [ValidateSet([ValidateRequirements])]
        [Parameter(Position=1, ValueFromPipeline, HelpMessage="Relative path to a requirements file, or name of a virtual environment.")]
        [System.String] $Requirement
    )

    Process {

        # get existing requirement file 
        if ($Requirement) {   
            $requirement_file = Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath $Requirement
        }

        return Get-Content $requirement_file
    }
}
