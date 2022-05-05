# ===========================================================================
#   Message.ps1 -------------------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Write-FormattedProcess {

    <#
    .DESCRIPTION
        Displays a formatted process message.

    .PARAMETER Message

    .PARAMETER Module

    .PARAMETER Space

    .PARAMETER Silent

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="Message, which should be displayed.")]
        [System.String] $Message,

        [Parameter(HelpMessage="Identifier, which defines the message cause")]
        [System.String] $Module,

        [Parameter(HelpMessage="If Space is true, spaces will be displayed.")]
        [Switch] $Space,

        [Parameter(HelpMessage="If switch 'Silent' is true no output will be created")]
        [Switch] $Silent
    )
    
    Process {
        $Color = "Yellow"
        Write-FormattedMessage -Message $Message -Color $Color -Type "PROCESS" -Module $Module -Space:$Space -Silent:$Silent
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Write-FormattedError {

    <#
    .DESCRIPTION
        Displays a formatted error message.

    .PARAMETER Message

    .PARAMETER Module

    .PARAMETER Space

    .PARAMETER Silent

    .OUTPUTS
        None.
    #>
    
    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="Message, which should be displayed.")]
        [System.String] $Message,

        [Parameter(HelpMessage="Identifier, which defines the message cause")]
        [System.String] $Module,

        [Parameter(HelpMessage="If Space is true, spaces will be displayed.")]
        [Switch] $Space,

        [Parameter(HelpMessage="If switch 'Silent' is true no output will be created")]
        [Switch] $Silent
    )

    Process {
        $Color = "Red"
        Write-FormattedMessage -Message $Message -Color $Color -Type "ERROR" -Module $Module -Space:$Space -Silent:$Silent
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Write-FormattedSuccess {
    
    <#
    .DESCRIPTION
        Displays a formatted success message.
    
    .PARAMETER Message

    .PARAMETER Module

    .PARAMETER Space

    .PARAMETER Silent

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="Message, which should be displayed.")]
        [System.String] $Message,
        
        [Parameter(HelpMessage="Identifier, which defines the message cause")]
        [System.String] $Module,

        [Parameter(HelpMessage="If Space is true, spaces will be displayed.")]
        [Switch] $Space,

        [Parameter(HelpMessage="If switch 'Silent' is true no output will be created")]
        [Switch] $Silent
    )

    Process {
        $Color = "Green"
        Write-FormattedMessage -Message $Message -Color $Color "SUCCESS" -Module $Module -Space:$Space -Silent:$Silent
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Write-FormattedWarning {
    
    <#
    .DESCRIPTION
        Displays a formatted warning message.
    
    .PARAMETER Message

    .PARAMETER Module

    .PARAMETER Space

    .PARAMETER Silent

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="Message, which should be displayed.")]
        [System.String] $Message,
        
        [Parameter(HelpMessage="Identifier, which defines the message cause")]
        [System.String] $Module,

        [Parameter(HelpMessage="If Space is true, spaces will be displayed.")]
        [Switch] $Space,

        [Parameter(HelpMessage="If switch 'Silent' is true no output will be created")]
        [Switch] $Silent
    )

    Process {
        $Color = "DarkYellow"
        Write-FormattedMessage -Message $Message -Color $Color "WARNING" -Module $Module -Space:$Space -Silent:$Silent
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Write-FormattedMessage {
    
    <#
    .DESCRIPTION
        Displays a formatted message.
    
    .PARAMETER Message

    .PARAMETER Module

    .PARAMETER Color

    .PARAMETER Space

    .PARAMETER Silent

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="Message, which should be displayed.")]
        [System.String] $Message,

        [Parameter(HelpMessage="Color of the message to be displayed.")]
        [System.String] $Color="White",

        [Parameter(HelpMessage="Type of Message")]
        [System.String] $Type="Message",

        [Parameter(HelpMessage="Identifier, which defines the message cause")]
        [System.String] $Module,

        [Parameter(HelpMessage="If Space is true, spaces will be displayed.")]
        [Switch] $Space,

        [Parameter(HelpMessage="If switch 'Silent' is true no output will be created")]
        [Switch] $Silent
    )

    if ($Silent) {
        return
    }

    if ($Space) { Write-Host }
    if ($Module) {Write-Host "[$Module]::" -ForegroundColor $Color -NoNewline}
    Write-Host "$($Type): $($Message)" -ForegroundColor $Color
    if ($Space) { Write-Host }
}