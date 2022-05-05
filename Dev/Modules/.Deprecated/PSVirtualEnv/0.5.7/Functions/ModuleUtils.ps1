# ===========================================================================
#   Module-Tools.ps1 --------------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Set-VirtualEnv {

    <#
    .DESCRIPTION
        Set environment variable for using virtual environment in current session.
    
    .PARAMETER Name

    .OUTPUTS 
        None.
    #>

    [OutputType([System.String])]

    Param(
        [Parameter(HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    # checks whether a virtual environment session has been already running
    $venv_old = Get-ActiveVirtualEnv
    if($venv_old) {
        [System.Environment]::SetEnvironmentVariable($PSVirtualEnv.ProjectEnvOld, $venv_old, "process")
    }

    # set a backup of the pythonhome environment variable
    $python_home = [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.PythonHome, "process")

    # set a backup of the environment path
    $path_old = [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.PathEnvOld, "process")
    if (-not $path_old) {
        [System.Environment]::SetEnvironmentVariable($PSVirtualEnv.PathEnvOld, $env:PATH, "process")
    }

    # start virtual environment session
    if ($Name) {
        if ($Name -eq "Python")
        {
            $virtual_env = $python_home
            $path_new = "$($python_home);$($python_home)\Scripts;" + $env:PATH
        }
        else{
            $virtual_env  = Get-VirtualEnvPath -Name $Name
            $path_new = "$(Get-VirtualEnvPath -Name $Name)\Scripts;" + $env:PATH
        }

        # set environment path and virtual environment environment variable
        [System.Environment]::SetEnvironmentVariable("PATH", $path_new, "process")
        [System.Environment]::SetEnvironmentVariable($PSVirtualEnv.ProjectEnv, $virtual_env, "process")
        [System.Environment]::SetEnvironmentVariable($PSVirtualEnv.PythonHome, $virtual_env, "process")
    }
}

function Restore-VirtualEnv {
    <#
    .DESCRIPTION
        Restore environment variable, which are set by Set-VirtualEnv.
    
    .PARAMETER Name

    .OUTPUTS 
        None.
    #>

    [OutputType([Void])]

    Param ()

    # restore oler environment path version
    $path_old = [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.PathEnvOld, "process")
    if ($path_old) {
        [System.Environment]::SetEnvironmentVariable($PSVirtualEnv.PathEnvOld, $Null,"process")
        [System.Environment]::SetEnvironmentVariable("PATH", $path_old, "process")
    }

    [System.Environment]::SetEnvironmentVariable($PSVirtualEnv.PythonHome, $PSVirtualEnv.Python,"process")

    # stop virtual environment session
    [System.Environment]::SetEnvironmentVariable($PSVirtualEnv.ProjectEnv, $Null,"process")

    # restart previously running virtual environment session
    $venv_old = [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.ProjectEnvOld, "process")
    if($venv_old) {
        [System.Environment]::SetEnvironmentVariable($PSVirtualEnv.ProjectEnvOld, $Null, "process")
        Set-VirtualEnv -Name $venv_old
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualEnvPath {

    <#
    .DESCRIPTION
        Get the absolute path of a virtual environment, which is composed of the predefined system variable and a specified virtual environment
    
    .PARAMETER Name

    .OUTPUTS 
        System.String. Absolute path of a specified virtual environment
    #>

    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    return Join-Path -Path $PSVirtualEnv.WorkDir -ChildPath $Name
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualPython {

    <#
    .DESCRIPTION
        Get the absolute path of the executable of a specified virtual environment, which is composed of the predefined system variable, a specified virtual environment and the fixed location of the executable
    
    .PARAMETER Name

    .OUTPUTS 
        System.String. Absolute path of the executable of a specified virtual environment
    #>

    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    return Join-Path -Path (Get-VirtualEnvPath -Name $Name) -ChildPath $PSVirtualEnv.VirtualEnv 
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualEnvActivationScript {

    <#
    .DESCRIPTION
        Get the absolute path of the activation sript of a specified virtual environment, which is composed of the predefined system variable, a specified virtual environment and the fixed location of the executable
    
    .PARAMETER Name

    .OUTPUTS 
        System.String. Absolute path ofthe activation sript a specified virtual environment
    #>

    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    return Join-Path -Path (Get-VirtualEnvPath -Name $Name) -ChildPath $PSVirtualEnv.Activation
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualEnvLocalDir {

    <#
    .DESCRIPTION
        Get the absolute path of the download directory of a virtual environment.
    
    .PARAMETER Name

    .OUTPUTS 
        Get the absolute path of the download directory of a virtual environment
    #>

    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    return  Join-Path -Path $PSVirtualEnv.LocalDir -ChildPath $Name
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-PythonVersion() {
    
    <#
    .DESCRIPTION
        Retrieve the python version of a given python distribution.
    
    .PARAMETER Path

    .OUTPUTS
        Int. The version of the detected python distribution.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Int])]

    Param(
        [Parameter(Position=1, Mandatory, HelpMessage="Path to a folder or executable of a python distribution.")]
        [System.String] $Path
    )

    # get the version of a given python distribution
    $Path = Find-Python $Path
    if (-not $Path) { return }
    $pythonVersion = . $Path --version 2>&1
    write-host $pythonVersion
    # check the compatibility of the detected python version 
    $pythonVersion2 = ($pythonVersion -match "^Python\s2") -or ($pythonVersion -match "^Python\s3.3")
    $pythonVersion3 = $pythonVersion -match "^Python\s3" -and -not $pythonVersion2
    if (-not $pythonVersion2 -and -not $pythonVersion3) {
        if ($VerbosePreference) {
            Write-FormattedError -Message "This module is not compatible with the detected python version $pythonVersion" -Module $PSVirtualEnv.Name
        }
        return $Null
    }

    # return the version of the detected python distribution.
    return $(if ($pythonVersion2) {"2"} else {"3"})
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-ActiveVirtualEnv {

    <#
    .DESCRIPTION
        Detects activated virtual environments.

    .OUTPUTS 
       System.String. Running virtual environments.
    #>
    
    [CmdletBinding(PositionalBinding)]

    [OutputType([System.String])]

    Param()
    
    $virtual_env = [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.ProjectEnv, "process")

    if ($virtual_env -and $(Test-Path -Path $virtual_env)) {
        return Split-Path -Path $virtual_env -Leaf
    }
}
