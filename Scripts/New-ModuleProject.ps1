<#PSScriptInfo
.VERSION 
1.3.10

.GUID 
55ef3a83-4365-4e5e-844b-6ab2d323963b

.AUTHOR 
Christian Hoejsager

.COMPANYNAME 
ScriptingChris

.COPYRIGHT
Copyright (c) 2021 ScriptingChris

.TAGS
module project build

.LICENSEURI 
https://scriptingchris.tech/new-moduleproject_ps1/

.PROJECTURI
https://github.com/ScriptingChris/New-ModuleProject

.ICONURI


.EXTERNALMODULEDEPENDENCIES


.REQUIREDSCRIPTS


.EXTERNALSCRIPTDEPENDENCIES 


.RELEASENOTES
Created a lot of bug fixes to the build.ps1 script.
Added the the process of exporting aliases from the public functions aswell


Help documentation and use cases for the Script can be found here:
https://scriptingchris.tech/new-moduleproject_ps1/
#>

<# 
.SYNOPSIS
Script for easily creating a new module projects folder
.DESCRIPTION
Script which quickly creates a folder structure, Module Manifest and downloads a build.ps1 script
to use with Invoke-Build module for easy developing, maintaining, building and publishing your
powershell module.
Follow project at: https://github.com/ScriptingChris/New-ModuleProject
For in-depth help: https://scriptingchris.tech/new-moduleproject_ps1/
.EXAMPLE
PS C:\> New-ModuleProject.ps1 -Path ".\" -ModuleName "MyTestModule" -Prerequisites -Initialize -Scripts

This script will create a new folder structure in the path: ".\"
It will create the following folder structure:

MyTestModule\
    |_Docs\
    |_Output\
    |_Source\
    |   |_Public\
    |   |_Private\
    |   |_MyTestModule.psd1
    |_Tests\
    |_build.ps1

It will then make sure you have to follwoing modules installed:
- PowerSehllGet (For publishing modules)
- PlatyPS (For managing Help documentation)
- Pester (For Unit Testing)
- PSScriptAnalyzer (For Lint analyzing scripts)
- InvokeBuild (For building the module)

It will then download the build.ps1 script from the GitHub repository
https://raw.githubusercontent.com/ScriptingChris/New-ModuleProject/main/Source/build.ps1

The build script will be used for testing, building and publishing the module.
Help to use the build script can be found here: https://scriptingchris.tech/new-moduleproject_ps1/
.PARAMETER Path
Provide the Path to where the module should be placed (without the module name itself)
.PARAMETER ModuleName
Provice the name of your module
.PARAMETER Prerequisites
Parameter which will tricker installing of several modules:
- PowerShellGet
- PlatyPS
- Pester
- InvokeBuild
.PARAMETER Initialize
Parameter which will tricker the creation of the Module folder structure.
.PARAMETER Scripts
Parameter which will tricker the download of the default build script from:
https://raw.githubusercontent.com/ScriptingChris/New-ModuleProject/main/Source/build.ps1
.INPUTS
N/A
.OUTPUTS
N/A
.NOTES
N/A
#>


Param(
    [Parameter(Mandatory=$True)][String]$Path,
    [Parameter(Mandatory=$True)][String]$ModuleName,
    [Parameter(Mandatory=$false)][Switch]$Prerequisites,
    [Parameter(Mandatory=$true)][Switch]$Initialize,
    [Parameter(Mandatory=$false)][Switch]$Scripts
)

#Region - Prerequisites
if($Prerequisites.IsPresent){
    Write-Verbose -Message "Initializing Module PowerSehllGet"
    if (-not(Get-Module -Name PowerShellGet -ListAvailable)){
        Write-Warning "Module 'PowerShellGet' is missing or out of date. Installing module now."
        Install-Module -Name PowerShellGet -Scope CurrentUser -Force
    }

    Write-Verbose -Message "Initializing Module PSScriptAnalyzer"
    if (-not(Get-Module -Name PSScriptAnalyzer -ListAvailable)){
        Write-Warning "Module 'PSScriptAnalyzer' is missing or out of date. Installing module now."
        Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
    }

    Write-Verbose -Message "Initializing Module Pester"
    if (-not(Get-Module -Name Pester -ListAvailable)){
        Write-Warning "Module 'Pester' is missing or out of date. Installing module now."
        Install-Module -Name Pester -Scope CurrentUser -Force
    }

    Write-Verbose -Message "Initializing platyPS"
    if (-not(Get-Module -Name platyPS -ListAvailable)){
        Write-Warning "Module 'platyPS' is missing or out of date. Installing module now."
        Install-Module -Name platyPS -Scope CurrentUser -Force
    }

    Write-Verbose -Message "Initializing InvokeBuild"
    if (-not(Get-Module -Name InvokeBuild -ListAvailable)){
        Write-Warning "Module 'InvokeBuild' is missing or out of date. Installing module now."
        Install-Module -Name InvokeBuild -Scope CurrentUser -Force
    }
}
#EndRegion - Prerequisites

#Region - Initialize
if($Initialize.IsPresent){
    Write-Verbose -Message "Creating Module folder structure"
    
    try {
        Write-Verbose -Message "Creating Module root folder"
        New-Item -Path "$($Path)\$($ModuleName)" -ItemType Directory    
    }
    catch {
        Write-Error -Message "Error - Failed creating the module root folder"
    }
    if(Test-Path "$($Path)\$($ModuleName)"){
        try {
            Write-Verbose -Message "Creating Source, Tests, Output, Docs folders"
            New-Item -Path "$($Path)\$($ModuleName)\Source" -ItemType Directory
            New-Item -Path "$($Path)\$($ModuleName)\Tests" -ItemType Directory
            New-Item -Path "$($Path)\$($ModuleName)\Output" -ItemType Directory
            New-Item -Path "$($Path)\$($ModuleName)\Docs" -ItemType Directory    
        }
        catch {
            Write-Error -Message "Error - Failed creating Source, Test, Output and Docs folder"
        }
        
        Try {
            Write-Verbose -Message "Creating Private and Public functions folder"
            New-Item -Path "$($Path)\$($ModuleName)\Source\Private" -ItemType Directory
            New-Item -Path "$($Path)\$($ModuleName)\Source\Public" -ItemType Directory
        }
        catch {
            Write-Error -Message "Error - Failed creating private and public functions folders"
        }
    }
}
#EndRegion - Initialize

#Region - Scripts
if($Scripts.IsPresent){
    if(Test-Path "$($Path)\$($ModuleName)"){
        Write-Verbose -Message "Creating the Module Manifest"
        New-ModuleManifest -Path "$($Path)\$($ModuleName)\Source\$($ModuleName).psd1" -ModuleVersion "0.0.1"
    }

    Write-Verbose -Message "Downloading build script from: https://raw.githubusercontent.com/ScriptingChris/New-ModuleProject/main/Source/build.ps1"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ScriptingChris/New-ModuleProject/main/Source/build.ps1" -OutFile "$($Path)\$($ModuleName)\build.ps1"

    if(Test-Path "$($Path)\$($ModuleName)\build.ps1"){
        Write-Verbose -Message "Build script was downloaded successfully"
    }
    else {
        throw "Failed to downlaod the buildscript from: https://raw.githubusercontent.com/ScriptingChris/New-ModuleProject/main/Source/build.ps1"
    }
}
#EndRegion - Scripts
