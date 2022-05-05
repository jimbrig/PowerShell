# ===========================================================================
#   Get-VirtualEnvConfig.ps1 -----------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualEnvConfig {

    <#
    .SYNOPSIS
        Get the content of module's configuration file.

    .DESCRIPTION
        Displays the content of module's configuration file in powershell.
    
    .PARAMETER Unformatted

    .EXAMPLE
        PS C:\> Get-VirtualEnvConfig 

        Name                           Value
        ----                           -----
        venv-work-dir                  A:\VirtualEnv
        venv-local-dir                 A:\VirtualEnv\.temp
        venv-require-dir               A:\VirtualEnv\.require
        python                         PYTHONHOME
        default-editor                 code
        editor-arguments               --new-window --disable-gpu
        venv                           Scripts\python.exe
        venv-activation                Scripts\activate.ps1
        venv-deactivation              deactivate

        -----------
        Description
        Displays the content of module's configuration file in powershell.

    .INPUTS
        None.

    .OUTPUTS
        System.Object. Content of module's configuration file.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([System.Object])]

    Param(
        [Parameter(HelpMessage="Return information not as readable table with additional details.")]
        [Switch] $Unformatted
    )

    Process {

        $config_content = Get-IniContent -FilePath $Module.Config -IgnoreComments
        $config_content = Format-IniContent -Content $config_content -Substitution $PSVirtualEnv 
        
        $result = @()
        $config_content.Keys | ForEach-Object {
            $result += $config_content[$_] 
        }

        if ($Unformatted) {
            return $result
        }
        return $result | Format-Table
    }

}
