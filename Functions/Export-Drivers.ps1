Function Export-Drivers($destdir) {

  $dir = $destdir + "\" + (get-date -format "yyyy-MM-dd")
  if (-not (test-path $dir)) { New-Item -ItemType Directory -Path $dir }
  Dism.exe /online /export-driver /destination:$dir

  $table = Get-WindowsDriver -Online | Select-Object Driver, CatalogFile, ClassDescription, ProviderName, Version
  Export-Csv -InputObject $table -Path "$dir\Driver-Details.csv" -NoTypeInformation
  explorer.exe $dir

}
