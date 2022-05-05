# ===========================================================================
#   ScriptBlock.ps1 ---------------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-ArgumentList {

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(        
        [Parameter(HelpMessage="Specifies parameters or parameter values to use when this cmdlet starts the process. If parameters or parameter values contain a space, they need surrounded with escaped double quotes.")]
        [System.String[]] $ArgumentList
    )

    Process{
        if ($ArgumentList.Count -eq 1) {
            return $ArgumentList -split " " | Where-Object {$_}
        }

        return $ArgumentList
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Join-ScriptBlock {
    
    <#
    .DESCRIPTION
        Join several scriptblocks and move existing 'using' directives at the beginning of the script.

    .OUTPUTS
        ScriptBlock. Joint scriptblocks.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([ScriptBlock])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Array with objects of type [ScriptBlock] which are to be combined.")]
        [ScriptBlock[]] $Scripts
    )
    
    Process {

        # get all script blocks, convert them to strings as well as join these
        $script_joint = ""
        foreach ($script in $Scripts) {
            $script_joint += $script.ToString()
        }

        # search for 'using module' and 'using namespace' directives and get only unique ones
        $using_directive = ""
        $using_directive_search = "\s*(using\s+[a-z]+\s+[a-z\.]+)"
        [Regex]::Matches($script_joint, $using_directive_search, "IgnoreCase").Groups | Where-Object { $_.Name -eq 1} | Select-Object -ExpandProperty Value -Unique | ForEach-Object{
            $using_directive += "$_`n"
        }

        # generate a script block from singular script blocks and add 'using'-directives at its beginning
        $script_joint = $script_joint -replace $using_directive_search, ""
        return [ScriptBlock]::Create(
            $using_directive + $script_joint
        )
    }
}
