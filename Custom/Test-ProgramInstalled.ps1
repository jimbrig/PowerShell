Function Test-ProgramInstalled {
	<#
	.SYNOPSIS
		Test if a program is installed on machine.
	.DESCRIPTION
		This function scans various system locations to determine if a program has been installed.
	.PARAMETER programName
    Program Name to search for (i.e. "Visual Studio Code")
  .EXAMPLE
		PS C:\> Test-ProgramInstalled -programName "Typora"
	#>

	Param(
		[Parameter(Mandatory=$True)]
		[string]$programName
  )

  $localmachine_x86_check = ((Get-ChildItem "HKLM:Software\Microsoft\Windows\CurrentVersion\Uninstall") | `
    Where-Object { $_.GetValue('DisplayName') -like "*$programName*" } ).Length -gt 0

  if (Test-Path 'HKLM:Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall') {
    $localmachine_x64_check = ((Get-ChildItem "HKLM:Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | `
      Where-Object { $_.GetValue('DisplayName') -like "*$programName*" } ).Length -gt 0
  }

  $programexe = $programName + ".exe"
  $apppath_x64_check = ((Get-ChildItem "HKLM:Software\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths") | `
    Where-Object { $_.Name -like "*$programexe*" } ).Length -gt 0

  $user_x86_check = ((Get-ChildItem "HKCU:Software\Microsoft\Windows\CurrentVersion\Uninstall") | `
    Where-Object { $_.GetValue('DisplayName') -like "*$programName*" } ).Length -gt 0

  if (Test-Path 'HKCU:Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall') {
    $user_x64_check = ((Get-ChildItem "HKCU:Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | `
      Where-Object { $_.GetValue('DisplayName') -like "*$programName*" } ).Length -gt 0
  }

  $localmachine_check = $localmachine_x86_check -or $localmachine_x64_check
  $user_check = $user_x86_check -or $user_x64_check
  return $localmachine_check -or $user_check -or $apppath_x64_check
}
