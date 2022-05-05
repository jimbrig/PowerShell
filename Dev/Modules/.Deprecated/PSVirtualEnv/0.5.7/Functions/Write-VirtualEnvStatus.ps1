# ===========================================================================
#   Write-VirtualEnvStatus.ps1 ----------------------------------------------
# ===========================================================================

#   function -----------------------------------------------------------------
# ----------------------------------------------------------------------------
function Write-VirtualEnvStatus {

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param ()
    
    Process{

        $venv_path = [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.ProjectEnv, "process")
        Write-PromptModuleStatus -Module "Venv" -Value $(Split-Path -Path $venv_path -leaf)
    }
}
