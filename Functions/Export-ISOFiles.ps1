Function Export-ISOFiles($path, $destination) {
  # Mount ISO
  $details = Mount-DiskImage -ImagePath $path
  $devicepath = $details.DevicePath
  $diskimage = Get-DiskImage -DevicePath $devicepath | Get-Volume
  $driveletter = $diskimage.DriveLetter
  $mountdir = "$driveletter" + ":\"

  # Copy Contents
  Set-Location -Path $mountdir
  New-Item -ItemType Directory $destination
  Copy-Item -Path ".\*" -Destination "$destination\" -Recurse
  Set-Location -Path $destination

  # Unmount
  Dismount-DiskImage -DevicePath $devicepath

  # Open
  explorer.exe $destination

}
