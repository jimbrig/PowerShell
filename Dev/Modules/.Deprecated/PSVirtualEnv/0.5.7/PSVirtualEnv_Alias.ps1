# ===========================================================================
#   PSVirtualEnv_Alias.ps1 --------------------------------------------------
# ===========================================================================

#   aliases -----------------------------------------------------------------
# ---------------------------------------------------------------------------

# define aliases for specific function
@(
    @{ Name = "activate-venv";  Value = "ActivateVirtualEnvAutocompletion"}
    @{ Name = "cd-venv";        Value = "Set-VirtualEnvLocation"}
    @{ Name = "ed-venv-req";    Value = "Edit-Requirement"}
    @{ Name = "is-venv";        Value = "Install-VirtualEnv"}
    @{ Name = "i-venv";         Value = "Invoke-VirtualEnv"}
    @{ Name = "ls-venv";        Value = "Get-VirtualEnv"}
    @{ Name = "ls-venv-req";    Value = "Get-Requirement"}
    @{ Name = "mk-venv";        Value = "New-VirtualEnv"}
    @{ Name = "mk-venv-req";    Value = "New-Requirement"}
    @{ Name = "mk-venv-local";  Value = "New-VirtualEnvLocal"}
    @{ Name = "rm-venv";        Value = "Remove-VirtualEnv"}
    @{ Name = "sa-venv";        Value = "Start-VirtualEnv"}
    @{ Name = "sp-venv";        Value = "Stop-VirtualEnv"}

) | ForEach-Object {
    Set-Alias -Name $_.Name -Value $_.Value
}
