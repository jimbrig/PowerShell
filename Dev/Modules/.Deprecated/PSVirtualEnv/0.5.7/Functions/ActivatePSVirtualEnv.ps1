# ===========================================================================
#   ActivatePSVirtualEnv.ps1 ------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function ActivateVirtualEnvAutocompletion {

    <#
    .DESCRIPTION
        Import PSVirtualEnv activating autocompletion for validating input of module functions.

    .OUTPUTS
        ScriptBlock. Scriptblock with using command.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([ScriptBlock])]

    Param()

    Process {

        return $(Get-Command $(Join-Path -Path $Module.ClassDir -ChildPath "ModuleValidation.ps1") | Select-Object -ExpandProperty ScriptBlock)

    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function ValidateVirtualEnvDirectories {

    <#
    .DESCRIPTION
        Return values for the use of validating existing virtual environments
    
    .OUTPUTS
        System.String[]. Virtual environments
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String[]])]

    Param()

    Process{

       return (Get-VirtualEnvWorkDir | Select-Object -ExpandProperty Name)
    
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function ValidateVirtualEnvRequirement {

    <#
    .DESCRIPTION
        Return values for the use of validating existing requirement files.
    
    .OUTPUTS
        System.String[]. Requirement files
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String[]])]

    Param()

    Process{

        $file_list = (Get-ChildItem -Path $PSVirtualEnv.RequireDir -Include "*requirements.txt" -Recurse).FullName
        return ($file_list | ForEach-Object {
            $_ -replace ($PSVirtualEnv.RequireDir -replace "\\", "\\")})

    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function ValidateVirtualEnvLocalDirectories {

    <#
    .DESCRIPTION
        Return values for the use of validating existing local package folders.
    
    .OUTPUTS
        System.String[]. Local package folder.
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String[]])]

    Param()

    Process{

        $file_list = (Get-ChildItem -Path $PSVirtualEnv.LocalDir -Directory)
        return ($file_list | ForEach-Object {
            $_ -replace ($PSVirtualEnv.LocalDir -replace "\\", "\\")})
    }
}
