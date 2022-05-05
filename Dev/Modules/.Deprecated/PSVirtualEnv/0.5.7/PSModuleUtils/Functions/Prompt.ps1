# ===========================================================================
#   Prompt.ps1 --------------------------------------------------------------
# ===========================================================================

#   function -----------------------------------------------------------------
# ----------------------------------------------------------------------------
function Write-PromptModuleStatus {

    <#
    .DESCRIPTION
        Generate a informartion text box with module status for the use of adjusting console prompt.

    .PARAMETER Module

    .PARAMETER Value

    .PARAMETER ModuleColor

    .PARAMETER ParenColor

    .PARAMETER ValueColor

    .OUTPUTS
        Systems.String. Informartion text box with module status.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param (

        [Parameter(Position=1, Mandatory, HelpMessage="Name of module, which is the prefix when displaying module status.")]
        [System.String] $Module,

        [Parameter(Position=2, Mandatory, HelpMessage="Current module status.")]
        [System.String] $Value,

        [Parameter(Mandatory=$False, HelpMessage="Color used when displaying module name.")]
        [System.String] $ModuleColor = "DarkGray",

        [Parameter(Mandatory=$False, HelpMessage="Color used when displaying parentheses around module status.")]
        [System.String] $ParenColor = "Yellow",

        [Parameter(Mandatory=$False, HelpMessage="Color used when displaying module status.")]
        [System.String] $ValueColor = "Cyan"

    )
    
    Process{

        If ($Value) {       
            Write-Host $Module -NoNewline -ForegroundColor $ModuleColor
            Write-Host "["  -NoNewline -ForegroundColor $ParenColor
            Write-Host  $Value -NoNewline -ForegroundColor $ValueColor
            Write-Host  "]" -NoNewline -ForegroundColor $ParenColor
        }
    }
}
