# Changelog
All notable changes to this project will be documented in this file.

## [unreleased]

### Bug Fixes

- Fix psdefaultparams

### Configuration

- Tweak completions loop

### Documentation

- Create index.md in docs/
- Update docs/index.md with latest content

### Features

- Add gh-label CLI completion
- Add new script for markdown filetree
- Update winget completion
- Update installed scripts
- Add PowerShell.Installation.Tests.ps1
- Add GitConfig.Tests.ps1
- Add Network.Tests.ps1
- Add root PowerShell.Tests.ps1 runner

### Miscellaneous Tasks

- Autopublish 2022-05-13T01:07:25Z
- Autopublish 2022-05-13T02:41:38Z
- Autopublish 2022-05-13T02:46:03Z
- Autopublish 2022-08-20T21:56:43Z
- Autopublish 2023-07-23T00:42:45Z
- Autopublish 2023-07-23T03:14:54Z
- Autopublish 2023-11-18T17:19:04Z
- Autopublish 2023-11-18T17:19:39Z
- Autopublish 2023-11-18T17:20:28Z

## [1.4.0] - 2022-05-05

### Bug Fixes

- Fix aliases
- Quotes
- No duplicate import of psreadline

### Configuration

- Edit CRLF

### Documentation

- New release CHANGELOG docs
- Add ffsend to README
- Update HELP
- Add sub-directory READMEs
- Update modules README

### Features

- Add 2 new scripts
- Add `ffsend` completion
- Make completion scripts robust to errors
- Add Archived items back
- Enhance vscode settings
- Add choco to CurrentUserCurrentHost
- New aliases setup
- Add PSVirtualEnv shell completion
- Deprecate venv completion
- Add oh-my-posh shell completion
- Add new alias for code vs code-insiders
- New oh-my-posh setup
- Add Dev folder and test module "PSProfileTools"
- Deprecate venv completion
- Add Remove-OldModules script
- Restructure Dev
- Add deleteold-drivers script
- Add remove-oldmodules custom profile function
- Cleanup

### Miscellaneous Tasks

- Autopublish 2022-01-10T22:48:58Z
- Autopublish 2022-02-23T18:00:44Z
- Update TOC
- Autopublish 2022-02-23T18:03:59Z
- Autopublish 2022-02-26T23:17:42Z
- Autopublish 2022-02-26T23:19:17Z
- Autopublish 2022-05-04T03:43:14Z
- Autopublish 2022-05-05T03:01:33Z
- Autopublish 2022-05-05T03:09:20Z
- Autopublish 2022-05-05T03:54:00Z
- Autopublish 2022-05-05T04:48:47Z
- Autopublish 2022-05-05T04:53:56Z

## [1.3.0] - 2022-01-02

### Configuration

- Ignore desktop.ini
- Add vscode workspace settings and extensions
- Encrypt migrated keeperconfig.json
- Update git-cliff completion
- Installed script infos configs
- Re-encrypt keeperconfig.json

### Documentation

- Add help XML docs
- Update README with latest changes

### Features

- Add new Open-RProject custom function
- Add PSGallery Trust and Default params to profile
- Add to prompt pwsh version and exec. policy
- Restructure 'Custom' directory
- Add expl, np, and files aliases
- Add Fido.ps1 script for downloading ISOs
- Add posh-git, oh-my-posh, terminal-icons, and readline to module imports
- Add WIMWitch PSScript
- Add 5 new function profile imports
- Add encrypted keeperconfig.json
- Re-structure and enhance profile segmentations
- Create/edit modules options prompt and helpers

## [1.2.0] - 2021-12-25

### Bug Fixes

- Fix custom keeper commander functions

### Configuration

- Gpg changes due to using git native gpg now
- Restructure - move history to Archive dir

### Documentation

- Release v1.1.0 Changelog
- Update CHANGELOG
- Update CHANGELOG.md for new release

### Features

- Format config.json
- Add keeper-commander functions
- Avoid errors with oh-my-posh theme through erroraction flag
- Silently continue for PSReadLine options
- Tweak aliases
- Add yq cli shell completion
- Add custom dir
- Add new launcher open functions
- Update aliases
- Add custom system functions
- Add new console host history
- Update modules.yml
- Add new Obsidian Helper Functions
- Add archived previous versions
- Use code as core editor in functions
- Update gcalcli aliases and functions
- Add Remove-CalendarEvent ps1 function
- Add git-crypt custom functions and aliases to match WSL

## [1.1.0] - 2021-10-25

### Configuration

- Remove unnecessary module imports

### Documentation

- New CHANGELOG
- Update README with latest details and code

### Features

- Add s-search completion
- Enhance loading of profile scripts
- Add update-profilemodules + tweak vscode cmd
- Add aws-cli shell completion
- Adjust shell completions to only run if found
- Update modules functionality and functions

### Gitflow-release-stash

- V1.1.0

## [1.0.0] - 2021-10-10

### Bug Fixes

- Fix completion script root
- Fixed issues with edit functions mixups

### Configuration

- Update attributes
- Ignore keeper
- Add vscode workspace
- Removed 'touch' alias for 'set-filetime' from psx package
- Add cliff.toml git-cliff configuration file for Changelog (#1)

### Documentation

- Add Changelog.md (resolves #1)
- Update Changelog.md

### Features

- Add encrypted config.json
- Add experimental functions
- Add extract-icon
- Functions
- Migrate to new profile dir
- All new completion scripts
- Extract-icon
- Loaders
- Update VSCode profile
- Add hardware troubleshooting function sysutil
- Add PSDefaultParams to profile.ps1
- Add Troubleshooting Functions
- New Get-IP function
- New Get-AdminRights.ps1 function
- Add Test-WiFi function
- Add new 'Reset-Network' function.
- Add hardlinked PowerShell-History log to profile dir
- Add new Get-HistPath function 

### Cleanup

- Archive old functions
- Remove old files
- Cleanup actual profiles

### Update

- Modules

Generated by Git-Cliff
