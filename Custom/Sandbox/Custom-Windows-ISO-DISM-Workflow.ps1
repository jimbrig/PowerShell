# -------------------------
# ISO Creation Script
# -------------------------

# https://www.tenforums.com/tutorials/131765-apply-unattended-answer-file-windows-10-install-media.html
# https://www.tenforums.com/tutorials/131765-apply-unattended-answer-file-windows-10-install-media.html
# https://www.tenforums.com/tutorials/165836-how-add-remove-optional-features-windows-install-media.html
# https://www.tenforums.com/tutorials/95008-dism-add-remove-drivers-offline-image.html

# Download ISO Image

# Extract and Run UUP

# Mount
Mount-DiskImage $isopath

# Copy Contents to $extractdir
$extractdir = "S:\ISO\"
$mountdriveletter = "G"
$mountdrive = $mountdriveletter + ":\"
Set-Location $mountdrive\
copy-item .\* $extractdir -r

# Use DISM to list WimInfo
$installwimpath = $mountdrive + "sources\install.wim"
sudo Dism /Get-WimInfo /WimFile:$installwimpath

# ensure install.wim is not read-only
attrib -R install.wim

# Mount to $mountdir
$mountdir = "S:\Mount"
New-Item -ItemType Directory -Path $mountdir

# Mount to $mountdir
$extractwimfile = $extractdir + "sources\install.wim"
Dism /Mount-Image /ImageFile:$extractwimfile /Index:6 /MountDir:$mountdir

# Add Panther Dir
Set-Location $mountdir
New-Item -ItemType Directory -Path .\Panther

# Add unattend.xml
Copy-Item S:\Config\AutoUnattend\unattend.xml -Destination .\Panther\

# Dismount
dism /Unmount-Image /MountDir:S:\Mount /Commit
