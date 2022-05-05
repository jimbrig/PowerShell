# ===========================================================================
#   PSVirtualEnv.Tests.ps1 ---------------------------------------------
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

    # get module name and directory
    $Script:moduleName = "PSVirtualEnv"
    $Script:Dir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
    
    # set test flag
    $Env:PSVirtualEnv = 1

    # execute file with the specific module settings
    . (Join-Path -Path $Script:Dir -ChildPath ($Script:moduleName + ".Module.ps1"))

    # load essential functions
    . $Module.FunctionsFile

#   test environment --------------------------------------------------------
# ---------------------------------------------------------------------------

#   module test -------------------------------------------------------------
# ---------------------------------------------------------------------------

    # test general settings of module
    Describe -Tags 'ModuleSettings' "$Script:moduleName manifest" {
        It "has a valid module name" {
            Test-Path -Path $Module.Name | Should Not BeNullOrEmpty
        }
        
        It "has a valid directory" {
            {
                Test-Path -Path $Module.Dir 
            } | Should Not Throw
        }

        It "has a valid function directory" {
            {
                Test-Path -Path $Module.FunctionsDir
            } | Should Not Throw
        }

        It "has a valid test directory" {
            {
                Test-Path -Path $Module.TestsDir
            } | Should Not Throw
        }

        It "has a valid configuration file" {
            {
                Test-Path -Path $Module.Config 
            } | Should Not Throw
        }

        It "has a valid module scrip" {
            {
                Test-Path -Path $Module.ModuleFile 
            } | Should Not Throw
        }

        It "has a valid functions script" {
            {
                Test-Path -Path $Module.FunctionsFile 
            } | Should Not Throw
        }

    }

#   tests -------------------------------------------------------------------
# ---------------------------------------------------------------------------

    # invoke all scripts below listed with pester
    Get-ChildItem -Path $Module.TestsDir -Filter "*.ps1" | ForEach-Object {
        Invoke-Pester -Script  $_.FullName
    }

#   end of tests ------------------------------------------------------------
# ---------------------------------------------------------------------------
    $Env:PSVirtualEnv = $Null
