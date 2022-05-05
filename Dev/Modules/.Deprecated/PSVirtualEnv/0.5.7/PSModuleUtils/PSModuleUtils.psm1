# ===========================================================================
#   PSModuleUtils.psm1 ------------------------------------------------------
# ===========================================================================

#   settings ----------------------------------------------------------------
# ---------------------------------------------------------------------------
$path = $MyInvocation.MyCommand.Path
$name = [System.IO.Path]::GetFileNameWithoutExtension($path)
$Module = New-Object -TypeName PSObject -Property @{
    Name = $name
    Dir =  Split-Path -Path $path -Parent
    FunctionsDir = Join-Path -Path $(Split-Path -Path $path -Parent) -ChildPath "Functions"
}

#   functions ---------------------------------------------------------------
# ---------------------------------------------------------------------------
Get-ChildItem -Path $Module.FunctionsDir -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
}
