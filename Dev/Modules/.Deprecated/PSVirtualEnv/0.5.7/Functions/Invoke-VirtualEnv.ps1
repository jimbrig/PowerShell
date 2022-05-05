# ===========================================================================
#   Invoke-VirtualEnv.ps1 ---------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Invoke-VirtualEnv {
    <#
    .SYNOPSIS
        Runs commands in a specified virtual environment.

    .DESCRIPTION
        The function runs commands  in a specified virtual environment and returns all output from the commands, including errors

    .PARAMETER Name

    .PARAMETER ArgumentList

    .PARAMETER Silent

    .EXAMPLE
        PS C:\> Invoke-VirtualEnv -Name venv -ArgumentList 'papis', 'config', 'dir'
        C:\Users\User\pocs

        -----------
        Description
        Runs command 'papis' with arguments 'config' and 'dir' in virtual environment 'venv'.

    .EXAMPLE
        PS C:\> Invoke-VirtualEnv -Name venv -ScriptBlock {papis config dir}
        C:\Users\User\pocs

        -----------
        Description
        Runs scriptblock '{papis config dir}'.

    .INPUTS
        Name. Name of the virtual environment.
    
    .OUTPUTS
        None.
    #>
    
    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(

        [ValidateSet([ValidateVirtualEnv])]
        [Parameter(Position=1, ValueFromPipeline, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name,

        [Parameter(Position=2, HelpMessage="Specifies parameters or parameter values to use when this cmdlet starts the process. If parameters or parameter values contain a space, they need surrounded with escaped double quotes.")]
        [System.String[]] $ArgumentList,

        [Parameter(HelpMessage="Specifies the commands to run. Enclose the commands in braces ( { } ) to create a script block.")]
        [ScriptBlock] $ScriptBlock,

        [Parameter(HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent
    )

    Process{

        Set-VirtualEnv -Name $Name
        
        $invokation_cmd = $ScriptBlock
        if ($ArgumentList) {
            $invokation_cmd = [ScriptBlock]::Create($(Get-ArgumentList -ArgumentList $ArgumentList))
        }


        if ($Silent) {
            $invokation_cmd.Invoke() 2>&1> $Null
        } else {
            $invokation_cmd.Invoke()
        }

        Restore-VirtualEnv

    }
}