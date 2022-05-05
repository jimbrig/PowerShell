# ===========================================================================
#   New-VirtualEnvLocal.ps1 -------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function New-VirtualEnvLocal {

    <#
    .SYNOPSIS
        Download packages of a specified virtual environment.

    .DESCRIPTION
        Download packages of a specified virtual environment to a predefined local directory.
    
    .PARAMETER Name

    .PARAMETER All

    .EXAMPLE
        PS C:\>Get-VirtualEnvLocal -Name venv

        SUCCESS: Packages of virtual environment 'venv' were downloaded to 'A:\VirtualEnv\.temp\venv'.

        -----------
        Description
        Download all packages of the virtual environment 'venv' to a predefined download directory.

    .EXAMPLE
        PS C:\>Get-VirtualEnvLocal -All

        -----------
        Description
        Download all packages of each existing virtual environment to a predefined download directory.       

    .INPUTS
        System.String. Name of the virtual environment.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param (
        [ValidateSet([ValidateVirtualEnv])]
        [Parameter(Position=1, ValueFromPipeline, HelpMessage="Name of the virtual environment to be changed.")]
        [System.String] $Name="",

        [Parameter(HelpMessage="If switch 'All' is true, all existing virtual environments will be changed.")]
        [Switch] $All
    )
    
    Process {
        # check valide virtual environment 
        if ($Name)  {
            if (-not(Test-VirtualEnv -Name $Name)){
                Write-FormattedError -Message "The virtual environment '$($Name)' does not exist." -Module $PSVirtualEnv.Name -Space
                Get-VirtualEnv

                return
            }

            $virtualEnv = @{ Name = $Name }
        }

        # get all existing virtual environments if 'Name' is not set
        if ($All) {
            $virtualEnv = Get-VirtualEnv
        }

        $virtualEnv | ForEach-Object {


            # get absolute path of requirement file and download directoy
            $requirementFile = Get-RequirementFile -Name $_.Name
            $virtualEnvLocal = Get-VirtualEnvLocalDir -Name $_.Name

            # remove the requirement file when it exists and create the respective file
            if (Test-Path $requirementFile){
                Remove-Item -Path $requirementFile -Force
            }
            New-Requirement -Name $_.Name

            # remove a previous folder, which contains download file of packages related to a older state of the virtual environment
            if (Test-Path $virtualEnvLocal){
                Remove-Item -Path $virtualEnvLocal -Recurse 
            }

            # download the packages defined in the requirement file to the specified download directory
            Write-FormattedProcess -Message "[DL] Virtual environment '$($_.Name)' to '$virtualEnvLocal'" -Module $PSVirtualEnv.Name

            # set environment variable
            Set-VirtualEnv -Name $_.Name
            pip download --requirement $requirementFile --dest  $virtualEnvLocal
            Restore-VirtualEnv

            Write-FormattedSuccess -Message "Packages of virtual environment '$($_.Name)' were downloaded to '$virtualEnvLocal'" -Module $PSVirtualEnv.Name
        }
    }
}
