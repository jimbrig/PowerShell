# -------------------------
# PowerShell Aliases
# -------------------------

Set-Alias -Name pro -Value Edit-Profile
Set-Alias -Name aliases -Value Get-Alias
Set-Alias -Name cpkgs -Value chocopkgs
Set-Alias -Name cclean -Value chococlean
Set-Alias -Name csearch -Value chocosearch
Set-Alias -Name cup -Value chocoupgrade
Set-Alias -Name cpkgs -Value chocopkgs
Set-Alias -Name cbackup -Value chocobackup
Set-Alias -Name refresh -Value refreshenv
Set-Alias -Name touch -Value New-File
Set-Alias -Name rproj -Value openrproj
Set-Alias -Name chkdisk -Value Check-Disk
Set-Alias -Name cdd -Value CreateAndSet-Directory
Set-Alias -Name emptytrash -Value Clear-RecycleBin
Set-Alias -Name codee -Value code-insiders
Set-Alias -Name gcal -Value gcalcli
Set-Alias -Name agenda -Value Get-Agenda
Set-Alias -Name gcalm -Value Get-CalendarMonth
Set-Alias -Name gcalw -Value Get-CalendarWeek
Set-Alias -Name gcalnew -Value New-CalendarEvent

# Ensure `R` is for launching an R Terminal:
if (Get-Command R.exe -ErrorAction SilentlyContinue | Test-Path) {
  Remove-Item Alias:r -ErrorAction SilentlyContinue
  ${function:r} = { R.exe @args }
}

# Ensure gpg points to correct program
Set-Alias -Name gpg -Value 'C:\Program Files (x86)\GnuPG\bin\gpg.exe'

# Remove stupid 'touch' alias for 'set-filetime'
Remove-Alias -Name touch 
