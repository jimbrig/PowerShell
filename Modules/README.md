# PowerShell Modules

## Overview

This directory (~/Documents/PowerShell/Modules) represents the *Current User, All Hosts* `$PSModulePath` where PowerShell modules are installed under the `CurrentUser` Scope (i.e. `-Scope CurrentUser`).

*Note that my personal development modules I created or am in the process of developing are housed under the [Dev](../Dev) directory.*

## Module Management

I manage my modules using a custom [modules.json](modules.json) / [modules.yml](modules.yml) configuration file for easy backups and bootstrapping of installations.

The installed modules are backed up into a simple `JSON` file: [modules.json](modules.json) and created via [modules.ps1](modules.ps1).

## Installed Modules

- [**BuildHelpers**](BuildHelpers)
- [**Pester**](Pester)
- [**Plaster**](Plaster)
- [**platyPS**](platyPS)
- [**posh-git**](posh-git)
- [**powershell-yaml**](powershell-yaml)
- [**PowerShellBuild**](PowerShellBuild)
- [**PowerShellGet**](PowerShellGet)
- [**Profiler**](Profiler)
- [**ps2exe**](ps2exe)
- [**psake**](psake)
- [**PSDepend**](PSDepend)
- [**PSReadLine**](PSReadLine)
- [**PSWindowsUpdate**](PSWindowsUpdate)
- [**PSWriteColor**](PSWriteColor)
- [**Stucco**](Stucco)
- [**Terminal-Icons**](Terminal-Icons)
- [**VSCodeBackup**](VSCodeBackup)
- [**WingetTools**](WingetTools)
- [**WTToolBox**](WTToolBox)
- [**ZLocation**](ZLocation)

## Other Useful Modules

Here's a list of other useful modules I have encountered and experimented with in the past for reference:

- 7Zip4Powershell
- AU
- BurntToast
- ChocolateyGet
- Evergreen
- Foil
- Posh-Sysmon
- PSEverything
- PSFzf
- PSProfiler
- PSScriptTools
- WindowsCompatibility
- WslInterop
