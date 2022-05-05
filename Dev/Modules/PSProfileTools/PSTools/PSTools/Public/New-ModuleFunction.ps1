$PSFunctionHeader = @"
Function $FunctionName {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE
        PS>

        Runs the command
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param (
        # Parameter description can go here or above in format: .PARAMETER  <Parameter-Name>
        [Parameter()]
    )

}
"@

Function New-ModuleFunction {
    param (
        [string]$path
    )

    New-Item -ItemType File -Path $path
    $FunctionName = Split-Path $path -Parent -Leaf
    Write-Output $PSFunctionHeader -     >> $path

}
