# ===========================================================================
#   Edit-Requirement.ps1 -----------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Edit-Requirement {

    <#
    .SYNOPSIS
        Edit the content of an existing requirement file.

    .DESCRIPTION
        Edit the content of an existing requirement file iin defined editor. All available requirement files can be accessed by autocompletion.
    
    .PARAMETER Requirement

    .EXAMPLE
        PS C:\> Edit-Requirement -Name venv

        -----------
        Description
        Open the requirement file of an existing virtual environment in defined editor. All available requirement files can be accessed by autocompletion.

    .INPUTS
        System.String. Relative path of existing requirement file

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(
        [ValidateSet([ValidateRequirements])]
        [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Relative  path to a requirements file, or name of a virtual environment.")]
        [System.String] $Requirement
    )

    Process {

        # get existing requirement file 
        if ($Requirement) {   
            $requirement_file = Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath $Requirement

        $editor_args = $($PSVirtualEnv.EditorArgs + " " + $requirement_file)
        # open existing requirement file 
        Start-Process -Path $PSVirtualEnv.Editor -NoNewWindow -Args $editor_args
        
        }
    }
}
