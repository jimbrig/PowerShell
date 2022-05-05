# ===========================================================================
#   Get-VirtualEnv.ps1 ------------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualEnv {

    <#
    .SYNOPSIS
        List all existing virtual environments in predefined directory.

    .DESCRIPTION
        Return all existing virtual environments in predefined virtual environment directory as PSObject with version number. All available virtual environments can be accessed by autocompletion.

    .PARAMETER Name

    .PARAMETER Full

    .PARAMETER Unformatted

    .PARAMETER ExpandProperty

    .EXAMPLE
        PS C:\> Get-VirtualEnv

        Name Version
        ---- -------
        venv 3.7.3

        -----------
        Description
        Return all existing virtual environments in predefined directory. Flags 'Full' and 'Unformatted' does not have any implications if merely virtual environments are queried.


    .EXAMPLE
        PS C:\> ls-venv

        Name Version
        ---- -------
        venv 3.7.3

         Return all existing virtual environments in predefined directory with predefined alias.

    .EXAMPLE
        PS C:\> Get-VirtualEnv -Name venv

        Name       Version Latest
        ----       ------- ------
        Click      7.0
        pip        19.2.3
        setuptools 41.2.0
        wheel      0.33.6

        -----------
        Description
        Return information about all independent packages installed in the specified virtual environment 'venv' and shows potentially newer versions. Flags 'Full' lists additionally all packages of the virtual environment, and "Unformatted' does not pipe results to cmdlet 'Format-Table'.

    .EXAMPLE
        PS C:\> Get-VirtualEnv -Python

        Name       Version  Latest
        ----       -------  ------
        pip        19.2.3
        setuptools 41.2.0
        virtualenv 16.6.1

        -----------
        Description
        RReturn information about all independent packages installed in the default python distribution.  Flags 'Full' lists additionally all packages of the virtual environment, and "Unformatted' does not pipe results to cmdlet 'Format-Table'.

    .INPUTS
        System.Strings. Name of existing virtual environment.

    .OUTPUTS
        PSCustomObject. Object with contain information about all virtual environments.

    .NOTES
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([System.Object])]

    Param (
        [ValidateSet([ValidateVirtualEnv])]
        [Parameter(Position=1, ValueFromPipeline, HelpMessage="Information about all packages installed in the specified virtual environment will be returned.")]
        [System.String] $Name,

        [Parameter(HelpMessage="Return information about required packages.")]
        [Switch] $Full,

        [Parameter(HelpMessage="Return information not as readable table with additional details.")]
        [Switch] $Unformatted,

        [Parameter(HelpMessage="Return only the specified property.")]
        [System.String] $ExpandProperty = "Name"
    )

    Process {

        # return information about specified virtual distribution
        if ($Name) {                     
            # check whether the specified virtual environment exists
            if (-not $(Test-VirtualEnv -Name $Name -Verbose)){
                return Get-VirtualEnv
            }

            return Get-VirtualEnvPackage -Name $Name -Full:$Full -Unformatted:$Unformatted
        }

        #  return information about all virtual environments in the predefined directory are gathered
        if (-not $Name) {
            # get all virtual environment directories in predefined directory as well as the local directories and requirement files
            $virtual_env = Get-VirtualEnvWorkDir
            if (-not $virtual_env) { 
                Write-FormattedError -Message "In predefined directory do not exist any virtual environments" -Module $PSVirtualEnv.Name -Space 
            }
            return $virtual_env
        }
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualEnvWorkDir {

    <#
    .DESCRIPTION
        Return all existing virtual environments.
    
    .OUTPUTS
        PSCustomObject. All existing virtual environments.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([System.Object])]

    Param ()

    Process{

        # get all virtual environment directories in predefined directory as well as the local directories and requirement files
        $virtualEnvSubDirs = Get-ChildItem -Path $PSVirtualEnv.WorkDir | Select-Object -ExpandProperty Name

        $virtualEnvs = $Null

        # call the python distribution of each virtual environnment and determine the version number
        if ($VirtualEnvSubDirs.length) {
            $VirtualEnvSubDirs = @("python") + $VirtualEnvSubDirs
            $virtualEnvs= $VirtualEnvSubDirs | ForEach-Object {
                if (Test-VirtualEnv -Name $_) {
                    # get name of virtual environment and python version
                    Set-VirtualEnv -Name $_
                    [PSCustomObject]@{
                        Name = $_
                        Version = (((. python --version 2>&1) -replace "`r|`n","") -split " ")[1]
                    }
                    Restore-VirtualEnv 
                }
            }
            return $virtualEnvs
        } 
    }
}


#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualEnvPackage {

    <#
    .DESCRIPTION
        Gets the properties of all packages in a python environment.
    
    .PARAMETER Name

    .PARAMETER FULL

    .PARAMETER Unformatted
    
    .OUTPUTS
        PSCustomObject. Properties of all packages in a python environment
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([System.Object])]

    Param (
        [Parameter(Position=1, ValueFromPipeline, HelpMessage="Information about all packages installed in the specified virtual environment will be returned.")]
        [System.String] $Name,

        [Parameter(HelpMessage="Return information about required packages.")]
        [Switch] $Full,

        [Parameter(HelpMessage="Return information not as readable table with additional details.")]
        [Switch] $Unformatted
    )

    Process {

        Set-VirtualEnv -Name $Name

        # get all packages in the specified virtual environment,  get all outdated packages and get all independent packages
        
        $venv_package = pip list --format json | ConvertFrom-Json 
        #$venv_outdated = pip list --format json --outdated | ConvertFrom-Json 
        $venv_independent = pip list --format json --not-required | ConvertFrom-Json 

        # combine all gathered properties about the packages in the specified virtual environment
        $venv_package = $venv_package | ForEach-Object{
            $package = $_
            #$package_outdated = $venv_outdated | Where-Object {$_.Name -eq $package.Name}
            $package_independent = $venv_independent | Where-Object {$_.Name -eq $Package.Name}

            [PSCustomObject]@{
                Name = $package.Name
                Version = $package.Version
                #Latest = $package_outdated.Latest
                Required = if ( $package_independent ) {$Null} else {$True}

            }
        } 

        # return all packages which are independent from others in a separated table
        $result = $venv_package
        # | Format-Table -Property Name, Version
        $result = $venv_package | Where-Object {-not $_.Required} 

        if ($Full) {
        $requires_dict = @{}
        $result | ForEach-Object{
            $package = $_.Name
            $result_info = pip show $package
            $result_info | ForEach-Object{
                    $result_requires = $_ -Split "^Requires: "
                    if ($result_requires.Length -gt 1){
                        foreach($required_package in ($result_requires[1] -Split ", ")){
                            $requires_dict[$required_package] = $package
                        }
                    }
                }
            }

    
        $result_required = $venv_package | Where-Object {$_.Required} 
        $result_required | ForEach-Object {
                if ($requires_dict.ContainsKey($_.Name)) {
                    $_ | Add-Member -MemberType NoteProperty -Name "Required-by" -Value $requires_dict[$_.Name]
                }
            }
        }

        Restore-VirtualEnv

        if ($Unformatted -and -not $Full){
            return $result
        }
        elseif ($Unformatted -and $Full) {
            return $result, $result_required
        }
        elseif (-not $Unformatted -and -not $Full) {
            return ($result | Format-Table -Property Name, Version)
        }
        else{
            return ($result | Format-Table -Property Name, Version), ($result_required | Format-Table -Property Name, Version, Required-by)
        }
    }
}
