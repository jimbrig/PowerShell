# ===========================================================================
#   Install-VirtualEnv.ps1 --------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Install-VirtualEnv {

    <#
    .SYNOPSIS
        Install or upgrade packages from command line or requirement files to virtual environments.
    .DESCRIPTION
        Install or upgrade packages from command line or requirement files to virtual environments. All available requirement files can be accessed by autocompletion.

    .PARAMETER Name

    .PARAMETER Requirement

    .PARAMETER Package

    .PARAMETER Uninstall

    .PARAMETER All

    .PARAMETER Offline

    .PARAMETER SILENT

    .EXAMPLE
        PS C:\> Install-VirtualEnvPckg -Name venv -Package package
        [PSVirtualEnv]::PROCESS: Try to install packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\package-requirements.txt'.

        [PSVirtualEnv]::SUCCESS: Packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\package-requirements.txt' were installed.

        -----------
        Description
        Install package 'package' to specified virtual environment 'venv' by creating a requirement file with specified package and pipe it to virtual envinroments package manager.

    .EXAMPLE
        PS C:\> in-venv venv -Package package

        [PSVirtualEnv]::SUCCESS: Packages from requirement file C:\Users\User\PSVirtualEnv\.require\package-requirements.txt' were installed.

        -----------
        Description
        Install package 'package' to specified virtual environment 'venv' with predefined alias of command.

    .EXAMPLE
        PS C:\> Install-VirtualEnvPckg -Python -Package package

        [PSVirtualEnv]::SUCCESS: Packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\package-requirements.txt' were installed.

        -----------
        Description
        Install package 'package' to default python distribution.

    .EXAMPLE
        PS C:\> Install-VirtualEnvPckg -Name venv -Requirement \requirements.txt

        [PSVirtualEnv]::SUCCESS: Packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\requirements.txt' were installed.

        -----------
        Description
        Install packages defined in requirements file to specified virtual environment 'venv'. All available requirement files can be accessed by autocompletion.


    .EXAMPLE
        PS C:\> Install-VirtualEnvPckg -Name venv -Uninstall -Package package

        [PSVirtualEnv]::PROCESS: Try to uninstall packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\package-requirements.txt'.

        [PSVirtualEnv]::SUCCESS: Packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\package-requirements.txt' were uninstalled.

        -----------
        Description
        Remove package 'package' from specified virtual environment 'venv' by creating a requirement file with specified package and pipe it to virtual envinroments package manager.

    .EXAMPLE
        PS C:\> Install-VirtualEnvPckg -Name venv -Upgrade

        [PSVirtualEnv]::PROCESS: Try to upgrade packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\venv-requirements.txt'.

        Requirement already up-to-date: 'package'>='version' 

        [PSVirtualEnv]::SUCCESS: Packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\venv-requirements.txt' were upgraded.

    .INPUTS
        System.String. Name of existing virtual environment.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param (
        [ValidateSet([ValidateVirtualEnv])]
        [Parameter(Position=1, ValueFromPipeline, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name="",

        [ValidateSet([ValidateRequirements])]
        [Parameter(Position=2, HelpMessage="Relative path to a requirements file, or name of a virtual environment.")]
        [System.String] $Requirement="",

        [Parameter(HelpMessage="Package to be installed.")]
        [System.String[]] $Package,

        [Parameter(HelpMessage="If switch 'Uninstall' is true, specified packages will be uninstalled.")]
        [Switch] $Uninstall,

        [Parameter(HelpMessage="If switch 'Upgrade' is true, specified packages will be upgraded.")]
        [Switch] $Upgrade,

        [Parameter(HelpMessage="If switch 'All' is true, all existing virtual environments will be changed.")]
        [Switch] $All,

        [ValidateSet([ValidateVirtualEnvLocal])]
        [Parameter(HelpMessage="Path to a folder with local packages.")]
        [System.String] $Offline="",

        [Parameter(HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent
    )
    
    Process {

        # check valide virtual environment 
        if ($Name)  {
            if (-not (Test-VirtualEnv -Name $Name)){
                Write-FormattedError -Message "The virtual environment '$($Name)' does not exist." -Module $PSVirtualEnv.Name -Space -Silent:$Silent -Space 
                Get-VirtualEnv
                return
            }

            $virtualEnv = @{ Name = $Name }
        }

        # get all existing virtual environments if 'Name' is not set
        if ($All) {
            $virtualEnv = Get-VirtualEnv
        }

        # get existing requirement file 
        if ($Requirement) {   
            $requirement_file = Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath $Requirement
        }

        # create a valide requirement file for a specified package
        if ($Package){
            $Upgrade = $False                
            $requirement_file = New-TemporaryFile -Extension ".txt"

            if ($package.Count -eq 1) {
                $package = $package -split "," | Where-Object { $_}
            }
            $package | Out-File -FilePath $requirement_file
        }

        if ($Offline) {
            $local_path = Join-Path -Path $PSVirtualEnv.LocalDir -ChildPath $Offline

            if (-not $(Test-Path -Path $local_path)){
                Write-FormattedError -Message "File $($local_path) does not exist. Abort operation." -Module $PSVirtualEnv.Name
                return
            }

            $packages = Get-ChildItem -Path $local_path  

            $packages_bin = $packages | Where-Object {-not ($_.Name -match ".zip")} |  Select-Object -ExpandProperty FullName
            $packages_rep = $packages | Where-Object {$_.Name -match ".zip"} |  Select-Object -ExpandProperty FullName

            $packages =  $packages_bin + $packages_rep

            $requirement_file = New-TemporaryFile -Extension ".txt"
            Out-File -FilePath $requirement_file -InputObject $packages
        }

        $virtualEnv | ForEach-Object {

            # get existing requirement file 
            if ($Upgrade -and -not $Offline) {
                if (-not $requirement_file){
                    $requirement_file = Get-RequirementFile -Name $_.Name
                }
                New-Requirement -Name $_.Name -Upgrade
            }

            # install packages from the requirement file
            Install-VirtualEnvPackage -Name $_.Name -Requirement  $requirement_file -Uninstall:$Uninstall -Upgrade:$Upgrade -Silent:$Silent
            # --find-links /path/to/download/dir/ 
        }
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Install-VirtualEnvPackage {

    <#
    .DESCRIPTION
        Gets the properties of all packages in a python environment.
    
    .PARAMETER Name

    .PARAMETER Requirement

    .PARAMETER Uninstall

    .PARAMETER Upgrade

    .PARAMETER Silent

    .OUTPUTS
        PSCustomObject. Properties of all packages in a python environment
    #>

    
    [CmdletBinding(PositionalBinding)]

    [OutputType([PSCustomObject])]

    Param (
        [Parameter(Position=1, ValueFromPipeline, HelpMessage="Name of the virtual environment to be changed.")]
        [System.String] $Name="",

        [Parameter(Position=2, Mandatory, HelpMessage="Path to a requirements file.")]
        [System.String] $Requirement,

        [Parameter(HelpMessage="If switch 'Uninstall' is true, specified packages will be uninstalled.")]
        [Switch] $Uninstall,

        [Parameter(HelpMessage="If switch 'Upgrade' is true, specified packages will be upgraded.")]
        [Switch] $Upgrade,

        [Parameter(HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent
    )

    # specify the command to install or uninstall
    $install_cmd = "install"
    if ($Uninstall){
        $Upgrade = $False
        $install_Cmd = "uninstall"
    }
    $message = $install_cmd

    # if packages mmight be upgraded, consider upgrading in installation command
    $upgrade_cmd = ""
    if ($Upgrade) {
        $upgrade_cmd = "--upgrade"
        $message = "upgrade"
    }

    Write-FormattedProcess -Message "Try to $($message) packages from requirement file '$Requirement'." -Module $PSVirtualEnv.Name -Silent:$Silent

    Set-VirtualEnv -Name $Name
    
    # install packages from a requirement file
    if ($Silent) {
        pip $install_cmd --requirement $Requirement $upgrade_cmd 2>&1> $Null
    } else {
        pip $install_cmd --requirement $Requirement $upgrade_cmd
    }

    Restore-VirtualEnv

    Write-FormattedSuccess -Message "Packages from requirement file '$Requirement' were $($message)ed." -Module $PSVirtualEnv.Name -Silent:$Silent -Space 

}
