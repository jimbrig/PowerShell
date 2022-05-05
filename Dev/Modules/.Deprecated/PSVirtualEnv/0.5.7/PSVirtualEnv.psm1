# ===========================================================================
#   PSVirtualEnv.psm1 -------------------------------------------------------
# ===========================================================================

#   settings ----------------------------------------------------------------
# ---------------------------------------------------------------------------
$path = $MyInvocation.MyCommand.Path
$name = [System.IO.Path]::GetFileNameWithoutExtension($path)
$Module = New-Object -TypeName PSObject -Property @{
    Name = $name
    Dir =  Split-Path -Path $path -Parent
    Config = Get-ConfigProjectFile -Name $name
}

#   configuration -----------------------------------------------------------
# ---------------------------------------------------------------------------
$module_format = Get-Content -Path (Join-Path -Path $Module.Dir -ChildPath "module_format.json") | ConvertFrom-Json 
Format-JsonContent -Content $module_format -Substitution $Module | ForEach-Object{
    $Module | Add-Member -MemberType NoteProperty -Name $_.Name -Value $_.Value
}

. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Config.ps1")

#   functions ---------------------------------------------------------------
# ---------------------------------------------------------------------------
. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Functions.ps1")

#   environment -------------------------------------------------------------
# ---------------------------------------------------------------------------
. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Environment.ps1")

#   aliases -----------------------------------------------------------------
# ---------------------------------------------------------------------------
. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Alias.ps1")

#   settings ----------------------------------------------------------------
# ---------------------------------------------------------------------------
. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Settings.ps1")
