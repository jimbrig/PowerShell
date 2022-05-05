# ===========================================================================
#   New-Requirement.ps1 -----------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function New-Requirement {

    <#
    .SYNOPSIS
        Create the requirement file of a specific virtual environment.
        
    .DESCRIPTION
        Create the requirement file of a specific virtual environment in predefined requirements folder.. All available virtual environments can be accessed by autocompletion. Flag 'All' enables the creation of requirments file for all existing virtual environments. Flag 'Upgrade' replaces in resulting requirement file '==' with '>=' for the use of upgrading packages.
    
    .PARAMETER Name

    .PARAMETER All

    .PARAMETER Upgrade

    .EXAMPLE
        PS C:\>New-Requirement -Name venv
        PS C:\>Get-Requirement -Requirement \venv-requirements.txt
        Click==7.0
        PS C:\>

        -----------
        Description
        Get the content of an existing requirement file in predefined requirements folder. All available virtual environments can be accessed by autocompletion.

    .EXAMPLE
        PS C:\>New-Requirement -Name venv
        PS C:\>Get-Requirement -Requirement \venv-requirements.txt
        Click==7.0
        PS C:\>

        -----------
        Description
        Get the content of an existing requirement file in predefined requirements folder. All available virtual environments can be accessed by autocompletion.

    .EXAMPLE

        PS C:\>New-Requirement -Python
        PS C:\>Get-Requirement -Requirement \python-requirements.txt
        virtualenv==16.7.4
        PS C:\>
 
        -----------
        Description
        Get the requirement file of the default python distribution.

    .EXAMPLE
        PS C:\>New-Requirement -Name venv -Upgrade
        PS C:\>Get-Requirement -Requirement \venv-requirements.txt
        Click>=7.0
        PS C:\>

        -----------
        Description
        Get the requirement file of an existing requirement file in predefined requirements folder. Flag 'Upgrade' replaces in resulting requirement file '==' with '>=' for the use of upgrading packages.
    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(
        [ValidateSet([ValidateVirtualEnv])]
        [Parameter(Position=1, ValueFromPipeline, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name="",

        [Parameter(HelpMessage="If switch 'All' is true, the requirement file for all existing virtual environments will be generated.")]
        [Switch] $All,

        [Parameter(HelpMessage="If switch 'Upgrade' is true the requirement file is prepared for upgrading packages.")]
        [Switch] $Upgrade
    )

    Process {

        # check valide virtual environment 
        if ($Name) {
            if (-not(Test-VirtualEnv -Name $Name)){
                Write-FormattedError -Message "The virtual environment '$($Name)' does not exist." -Module $PSVirtualEnv.Name -Space
                Get-VirtualEnv

                return
            }

            $virtualEnv = @{ Name = $Name }
        }

        # Get all existing virtual environments if 'Name' is not set
        if ($All) {
            $virtualEnv = Get-VirtualEnv
        }

        $virtualEnv | ForEach-Object {

            # get full path of requirement file
            $requirement_file = Get-RequirementFile -Name $_.Name

            # create the requirement file of the specified virtual environment
            Set-VirtualEnv -Name $Name
            . pip freeze > $requirement_file
            Restore-VirtualEnv

            if ($Upgrade){
                $(Get-Content $requirement_file) -replace "==", ">=" | Out-File -FilePath $requirement_file
            }

            Write-FormattedSuccess -Message "Requirement file for virtual enviroment '$($_.Name)' created." -Module $PSVirtualEnv.Name
        }
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-RequirementFile {

    <#
    .DESCRIPTION
        Create the requirement file of a specific virtual environment.
    
    .PARAMETER Name

    .OUTPUTS
        System.String. Full path of virtual environment requirements file.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(
        [Parameter(Position=1, ValueFromPipeline, Mandatory, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    Process {

        return Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath "$($Name)-requirements.txt" 
        
    }
}
