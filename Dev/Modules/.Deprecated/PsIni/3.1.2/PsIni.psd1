﻿@{
    RootModule             = 'PsIni.psm1'
    ModuleVersion          = '3.1.2'
    GUID                   = '98e1dc0f-2f03-4ca1-98bb-fd7b4b6ac652'
    Author                 = 'Oliver Lipkau <oliver@lipkau.net>'
    CompanyName            = 'Unknown'
    Copyright              = '(c) 2013 Oliver Lipkau. All rights reserved.'
    Description            = 'Convert hashtable to INI file and back. @ http://lipkau.github.io/PsIni/'
    PowerShellVersion      = '3.0'
    PowerShellHostName     = ''
    PowerShellHostVersion  = ''
    DotNetFrameworkVersion = ''
    CLRVersion             = ''
    ProcessorArchitecture  = ''
    RequiredModules        = @()
    RequiredAssemblies     = @()
    ScriptsToProcess       = @()
    TypesToProcess         = @()
    FormatsToProcess       = @()
    NestedModules          = @()
    FunctionsToExport      = @('Add-IniComment','Get-IniContent','Out-IniFile','Remove-IniComment','Remove-IniEntry','Set-IniContent')
    CmdletsToExport        = @()
    VariablesToExport      = @()
    AliasesToExport        = @(
        'gic',
        'oif',
        'aic',
        'ric',
        'rie',
        'sic'
    )
    ModuleList             = @()
    FileList               = @()
    PrivateData            = @{
        PSData = @{
            Tags       = @('ini', 'PsIni')
            LicenseUri = 'https://github.com/lipkau/PsIni/blob/master/LICENSE'
            ProjectUri = 'http://lipkau.github.io/PsIni'
            # IconUri = ''
            # ReleaseNotes = ''
            # ExternalModuleDependencies = ''
        }
    }
}
