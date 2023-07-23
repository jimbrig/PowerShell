---

---

# PowerShell Core `$PROFILE`

## Contents

<!-- Start doctoc -->
- [Overview](#overview)
- [Profile Configuration](#profile-configuration)
- [Profile Structure](#profile-structure)
- [Customizations](#customizations)
  - [Options](#options)
    - [Network Security](#network-security)
    - [Execution Policy](#execution-policy)
    - [Trusted Repositories](#trusted-repositories)
    - [Default Parameters](#default-parameters)
    - [PSReadLine Options](#psreadline-options)
    - [Miscellaneous Options and Fixes](#miscellaneous-options-and-fixes)
<!-- End doctoc -->

## Overview

The primary profile file is [`Profile.ps1`](../profile.ps1), representing the `CurrentUserAllHosts` Profile, or `$PROFILE.CurrentUserAllHosts`, typically located at path: `$HOME/Documents/PowerShell/profile.ps1` or `$ONEDRIVE/Documents/PowerShell/profile.ps1` (if backing up your User Profile's Documents folder with OneDrive).

- Top Level [`Profile.ps1`](../profile.ps1):

<details><summary>View Code</summary><p>

```powershell
#Requires -Version 7

# Version: 0.1.0

# ----------------------------------------------------
# Current User, All Hosts Powershell Core v7 $PROFILE:
# ----------------------------------------------------

$psfiles = Join-Path (Split-Path -Parent $profile) "Profile" | Get-ChildItem -Filter "*.ps1"
ForEach ($file in $psfiles) { . $file }
```

</p></details>

## Profile Configuration

- Top Level [`powershell.config.json`](../powershell.config.json)

<details><summary>View Code</summary><p>

```json
{
  "Microsoft.PowerShell:ExecutionPolicy": "Unrestricted",
  "ExperimentalFeatures": [
    "PSCommandNotFoundSuggestion",
    "PSLoadAssemblyFromNativeCode",
    "PSNativeCommandErrorActionPreference",
    "PSSubsystemPluginModel"
  ]
}
```

</p></details>

Note that this configuration `JSON` file contains the following:

- The Default PowerShell ExecutionPolicy Level (i.e. I set mine to `Unrestricted`)
- List of Currently Enabled [PowerShell Experimental Features](https://learn.microsoft.com/en-us/powershell/scripting/learn/experimental-features?view=powershell-7.3&viewFallbackFrom=powershell-7#available-features)

## Profile Structure

- Default PowerShell Profile Directory Folders:
  - [Help](./../Help/): PowerShell Help Files
  - [Modules](../Modules/): Installed (User Scoped) PowerShell Modules
  - [Scripts](../Scripts/): Installed (User Scoped) PowerShell Scripts and their info files 

- Top-Level, Custom [Profile](../Profile/) folder: This folder houses all of my customizations and session startup scripts.
  - [Aliases](../Profile/Aliases/): Custom assigned aliases
  - [Completions](../Profile/Completions/): Various shell/tab completion predictor files
  - [Data](../Profile/Data/): Data related to PowerShell profile
  - [Functions](../Profile/Functions/): Helper Functions to load at startup
  - [Modules](../Profile/Modules/): Separate Profile-Specific Modules
  - [Options](../Profile/Options/): Custom PowerShell Options
  - [Scripts](../Profile/Scripts/): Custom Profile Scripts
  - [Tools](../Profile/Tools/): Various Tools
  - [Templates](../Profile/Templates/): [`Plaster`]() Templates and other template files
  - [Themes](../Profile/Themes/): `oh-my-posh` theme(s)
  - [Types](../Profile/Types/): Custom types

<details><summary>View Directory Tree</summary><p>

```text
# ~/Documents/PowerShell/PSProfile/:

|   .gitattributes
|   .gitignore
|   CHANGELOG.md
|   PSProfile.psd1
|   PSProfile.psm1
|   README.md
|   Requirements.psd1
|   
+---Config
+---Docs
+---Source
|   |   Load-Profile.ps1
|   |   
|   +---Aliases
|   +---Data
|   +---Functions
|   +---Modules
|   +---Options
|   +---Resources
|   |   +---Classes
|   |   +---Completions
|   |   +---DSCResources
|   |   +---Templates
|   |   \---Types
|   \---Scripts
\---Tests
```

</p></details>

## Customizations

- Options/Settings
- Prompt
- Completions
- PSReadLine
- Modules
- Helper/Utility Functions
- Aliases
- Default Parameters
- Common Paths
- Environment/Session Variables

### Options

Custom PowerShell *options* are split out into their respective individual scripts under the Profile's [Source/Options](../Profile/Source/Options/) folder.

These individual options scripts are then *dot-sourced* using a parent script that loops through and sources in each file.

- [`Import-ProfileOptions.ps1`]() script:

<details><summary>View Code</summary><p>

```powershell
# ----------------------------------
# Custom PowerShell Profile Options
# ----------------------------------

$Options = Get-ChildItem -Path $(Get-Location) -Filter "*options.ps1"
$Options | ForEach-Object {
  Write-Verbose "Importing Options from file: $_.Name"
  . $_.FullName
}

Write-Verbose "Imported $Options.Count total option files"
```

</p></details>

#### Network Security

> This option deals with Transport Layer Security Version 1.2.

This option is used to ensure that [TLS Version 1.2]() is enabled. 

*For more details on Transport Layer Security and its implications with Windows, .NET, and PowerShell see the Appendix: [Appendix: Transport Layer Security Details]().*

<details><summary>View Code</summary><p>

```powershell
# ------------------------------------------
# Option Script to Ensure TLS 1.2 Support
# ------------------------------------------

$CurrentVersionTls = [Net.ServicePointManager]::SecurityProtocol
$AvailableTls = [enum]::GetValues('Net.SecurityProtocolType') | Where-Object { $_ -ge 'Tls12' }
$AvailableTls.ForEach({
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor $_
})
$AlteredVersionTls = [Net.ServicePointManager]::SecurityProtocol
Write-Verbose "Protocol before change: $CurrentVersionTls`nProtocol after change: $AlteredVersionTls" -Verbose
```

</p></details>

#### Execution Policy

Although already handled with the configuration `JSON` file mentioned above, this option simply ensures the [Execution Policy]() is set correctly for the current session.

- [Options/ExecutionPolicy.options.ps1]():

<details><summary>View Code</summary><p>

```powershell
# ----------------------------------------------
# Option Script for PowerShell Execution Policy
# ----------------------------------------------

If ((Get-ExecutionPolicy -Scope CurrentUser) -ne 'Unrestricted') {
  Write-Verbose "Setting PowerShell Execution Policy for Current User to Unrestricted"
  Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
}
```

</p></details>

#### Trusted Repositories

This option ensures that package management *repositories* such as the [PowerShell Gallery]() have an `InstallationPolicy` set to `Trusted`.

*Note that other repositories such as [GitHub's NuGet Provider]() are also ensured to be trusted using the script below*

The options use the script [Options/RepositoryTrust.options.ps1]():

<details><summary>View Code</summary><p>

```powershell
# -----------------------------------------------------------
# Option Script Trusting Repository's via InstallationPolicy
# ------------------------------------------------------------

$Repos = Get-PSRepository

# Ensure PSGallery in Registered and Trusted
If ($Repos.Name -notcontains 'PSGallery') {
    Write-Verbose 'Registering PowerShell Gallery.'
    Register-PSRepository -Name 'PSGallery' -SourceLocation 'https://www.powershellgallery.com/api/v2/' -InstallationPolicy Trusted
}
ElseIf (($Repos | Where-Object Name -eq PSGallery).InstallationPolicy -ne 'Trusted') {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Write-Verbose "Trusted PSGallery Repository"
}
Else {
    Write-Verbose "PSGallery Repository Already Trusted"
}

# Other Registered Repositories
$OtherRepos = $Repos | Where-Object Name -ne 'PSGallery'
$OtherRepos | ForEach-Object {
    If ($_.InstallationPolicy -ne 'Trusted') {
        Write-Verbose "Trusting $($_.Name) Repository"
        Set-PSRepository -Name $_.Name -InstallationPolicy Trusted
    }
    Else {
        Write-Verbose "$($_.Name) Repository Already Trusted"
    }
}

$UpdatedRepos = Get-PSRepository
Write-Verbose "Updated Registered Repositories: $UpdatedRepos"
```

</p></details>

#### Experimental Features

Similar to the `ExecutionPolicy` this option should be handled via the `JSON` config file but is also sourced as a script via the code below.

- [Options/ExperimentalFeatures.options.ps1]():

<details><summary>View Code</summary><p>

```powershell
#Requires -Version 7

# ---------------------------------------------------------
# PowerShell Core v7 Experimental Features Options Script:
# ---------------------------------------------------------

# See https://docs.microsoft.com/en-us/powershell/scripting/whats-new/experimental-features?view=powershell-7

# Get Current PowerShell Version
$PSVersion = $PSVersionTable.PSVersion

Write-Verbose "Current PowerShell version is $PSVersion.Major.$PSVersion.Minor.$PSVersion.Patch."

# Get Experimental Features for Current Version
$ExperimentalFeatures = Get-ExperimentalFeature

ForEach ($Feature in $ExperimentalFeatures) {
    If ($Feature.Enabled) {
        Write-Verbose "PowerShell Experimental Feature $Feature.Name already enabled, skipping."
    }
    Else {
        Write-Verbose "Enabling PowerShell Experimental Feature: $Feature.Name"
        Enable-ExperimentalFeature -Name $Feature.Name -Scope CurrentUser
    }
}
```

</p></details>

### Prompt

#### oh-my-posh

### Modules

#### Posh-Git

#### Terminal-Icons

#### PSReadLine (Key Handlers)

### Completion Predictors

#### Module Based Predictors

##### Az.Tools.Predictor

##### DockerCompletion

#### Custom Predictors

### ZLocation

### Custom Modules

### Custom Functions and Aliases

### Custom Scripts

### Environment

### Session Variables and Default Parameters

### Version Control and Git

## Appendices

## Appendix: Transport Layer Security Details

Transport Layer Security (TLS) is the successor to SSL. Starting around 2018, TLS 1.0 and 1.1 we're deprecated in most browsers, leaving TLS 1.2 as the *de-facto standard*, with TLS 1.3 adoption rising but not widespread, yet.

By default, PowerShell (which is built from the .NET Framework) will use whatever the *default system's crypto settings* are which can be checked via:

```powershell
PS > [Net.ServicePointManager]::SecurityProtocol
SystemDefault
```

Notice that this simply returns `SystemDefault`, which is not very useful because each system could be different. In order to *force* each PowerShell session to enable System support for TLS 1.2 use:

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
```
