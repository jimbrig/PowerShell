# PowerShell Modules

This directory (~/Documents/PowerShell/Modules) represents the *Current User, All Hosts* `$PSModulePath`. The installed modules are backed up into a simple `JSON` file: [modules.json](modules.json) and created via [modules.ps1](modules.ps1).

## Installed Modules

- [modules.json](modules.json)

```powershell
➜ cat Modules/modules.json | jq
[
  "7Zip4Powershell",
  "AU",
  "BurntToast",
  "ChocolateyGet",
  "Evergreen",
  "Foil",
  "oh-my-posh",
  "posh-git",
  "Posh-Sysmon",
  "powershell-yaml",
  "psake",
  "PSEverything",
  "PSFzf",
  "PSProfiler",
  "PSScriptTools",
  "PSWriteColor",
  "Terminal-Icons",
  "WindowsCompatibility",
  "WslInterop",
  "ZLocation"
]
```

