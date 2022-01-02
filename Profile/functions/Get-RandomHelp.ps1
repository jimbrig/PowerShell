Function Get-RandomHelp {
    Get-Command -Module Microsoft*, Cim*, PS*, ISE | Get-Random | Get-Help -ShowWindow
}