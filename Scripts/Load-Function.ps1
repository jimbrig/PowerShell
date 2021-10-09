$extras = (Get-ChildItem "$env:OneDrive\Documents\PowerShell\Functions" -Filter "*.ps*").Name
Write-Host "Select Function(s):"
foreach ($extra in $extras) {
  $i++
  Write-Host "$i`: $($extra)"
}
do {
  $SelectedIndex=(Read-Host -Prompt "Pick a Function:").ToInt32($null)
}
while ($SelectedIndex -notin (1..$i))
$SelectedItem=$extras[$SelectedIndex-1]
$load =  Join-Path "$env:OneDrive\Documents\PowerShell\Functions\" -ChildPath $SelectedItem
Write-Host "Loading Functions from: $load" -ForegroundColor Green
Import-Module -Global $load
