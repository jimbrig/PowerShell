# ===========================================================================
#   New-VirtualEnv.ps1 ------------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function New-VirtualEnv {

    <#
    .SYNOPSIS
        Creates a virtual environment.

    .DESCRIPTION
        Creates a virtual environment in the predefined virtual environment directory and install via a requirements file project related packages. All available requirement files can be accessed by autocompletion.

    .PARAMETER Name

    .PARAMETER Path

    .PARAMETER Requirement

    .PARAMETER OFFLINE

    .EXAMPLE
        PS C:\> New-VirtualEnv -Name venv

        [PSVirtualEnv]::PROCESS: Creating new virtual environment 'venv'.
        New python executable in C:\Users\User\PSVirtualEnv\venv\Scripts\python.exe
        Installing setuptools, pip, wheel...
        done.

        [PSVirtualEnv]::SUCCESS: Virtual environment 'C:\Users\User\PSVirtualEnv\venv' was created.

        -----------
        Description
        Creates the specified virtual environment 'venv' in the predefined directory with the default python distribution.

    .EXAMPLE
        PS C:\> mk-venv venv

        [PSVirtualEnv]::SUCCESS: Virtual environment 'C:\Users\User\PSVirtualEnv\venv' was created

        -----------
        Description
        Creates the specified virtual environment 'venv' with predefined alias of command
   
    .EXAMPLE
        PS C:\> New-VirtualEnv -Name venv -Path C:\Python35\python.exe

        [PSVirtualEnv]::SUCCESS: Virtual environment 'C:\Users\User\PSVirtualEnv\venv' was created.

        -----------
        Description
        Creates the specified virtual environment 'venv' in the predefined directory with the defined python distribution.

    .EXAMPLE
        PS C:\> New-VirtualEnv -Name venv -Requirement \requirements.txt

        [PSVirtualEnv]::PROCESS: Creating new virtual environment 'venv'.
        New python executable in C:\Users\User\PSVirtualEnv\venv\Scripts\python.exe
        Installing setuptools, pip, wheel...
        done.

        [PSVirtualEnv]::SUCCESS: Virtual environment 'C:\Users\User\PSVirtualEnv\venv' was created.

        [PSVirtualEnv]::PROCESS: Try to install missing packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\requirements.txt'.

        [PSVirtualEnv]::SUCCESS: Packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\requirements.txt' were installed.


        Name       Version Latest
        ----       ------- ------
        package    version
        pip        19.2.3
        setuptools 41.2.0
        wheel      0.33.6

        -----------
        Description
        Creates the specified virtual environment 'venv' and install packages which are defined in 'requirements.txt'. Before execution, the requirements file has to be created in the requirements folder, specified in configuration file. All available requirement files can be accessed by autocompletion.

    .INPUTS
        System.String. Name of virtual environment, which should be created.
    
    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Name of the virtual environment to be created.")]
        [System.String] $Name,

        [Parameter(Position=2, HelpMessage="Relative path to a folder or executable of a python distribution.")]
        [System.String] $Path,

        [ValidateSet([ValidateRequirements])]
        [Parameter(HelpMessage="Path to a requirement file, or name of a virtual environment.")]
        [System.String] $Requirement,

        # [ValidateSet([ValidateVirtualEnvLocalDirectories])]
        [Parameter(HelpMessage="Path to a folder with local packages.")]
        [System.String] $Offline=""
    )

    Process{
    
        # check whether the specified virtual environment exists
        if (Test-VirtualEnv -Name $Name){
            Write-FormattedError -Message "The virtual environment '$Name' already exists." -Module $PSVirtualEnv.Name -Space
            Get-VirtualEnv

            return
        }
        
        # deactivation of a running virtual environment
        Restore-VirtualEnv

        # get existing requirement file 
        if ($Requirement) {   
            $requirement_file = Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath $Requirement
        }

        if ($Offline) {
            if (-not $(Test-Path -Path $Offline)){
                Write-FormattedError -Message "File $($Offline) does not exist. Abort operation." -Module $PSVirtualEnv.
                return
            }

            $packages = Get-ChildItem -Path $Offline  

            $packages_bin = $packages | Where-Object {-not ($_.Name -match ".zip")} |  Select-Object -ExpandProperty FullName
            $packages_rep = $packages | Where-Object {$_.Name -match ".zip"} |  Select-Object -ExpandProperty FullName

            $packages =  $packages_bin + $packages_rep

            $requirement_file = New-TemporaryFile -Extension ".txt"
            Out-File -FilePath $requirement_file -InputObject $packages
        }

        # generate the full path of the specified virtual environment, which shall be located in the predefined system path
        $virtualEnvDir = Get-VirtualEnvPath -Name $Name
   
        # create the specified virtual environment
        Write-FormattedProcess "Creating new virtual environment '$Name'." -Module $PSVirtualEnv.Name

        $verbose_cmd = ""
        if ($VerbosePreference){
            $verbose_cmd = "--verbose"
        }
        Set-VirtualEnv -Name "python"
        virtualenv  $virtualEnvDir $verbose_cmd
        Restore-VirtualEnv

        # check whether the virtual environment could be created
        if (Test-VirtualEnv -Name $Name) {
            Write-FormattedSuccess -Message "Virtual environment '$virtualEnvDir' was created." -Module $PSVirtualEnv.Name -Space
        }
        else {
            Write-FormattedError -Message "Virtual environment '$virtualEnvDir' could not be created." -Module $PSVirtualEnv.Name -Space
            Get-VirtualEnv
            return $Null
        }

        # install packages from the requirement file
        if ($Requirement -or $Offline) {
            Install-VirtualEnvPackage -Name $Name -Requirement $requirement_file
            Get-VirtualEnvPackage -Name $Name
        }
    }
}
