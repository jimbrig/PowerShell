# Install-fromURL
# example: Install-fromURL "<url>" "program-name"
function Install-fromURL($uri, $name) {
  $out = "$env:USERPROFILE\Downloads\$name.exe"
  Invoke-WebRequest -Uri $uri -OutFile $out
  Start-Process $out
}

# Get Github Download URL - Example: Get-GHDownloadURL "user/repo" "windows_x64" "*.exe"
function Get-GHDownloadURL($repo, $pattern, $extension) {
  $releasesUri = "https://api.github.com/repos/$repo/releases/latest"
  ((Invoke-RestMethod -Method GET -Uri $releasesUri).assets | Where-Object name -like $pattern ).browser_download_url
}

# Download from github
# example: Save-fromGH "user/repo" "*.exe" "program-name"
function Save-fromGH($repo, $pattern, $name) {
  $uri = Get-GHDownloadURL $repo $pattern
  $extension = $pattern.Replace("*", "")
  $out = $name + $extension
  Invoke-WebRequest -Uri $uri -OutFile "$env:USERPROFILE\Downloads\$out"
  explorer.exe "$env:USERPROFILE\Downloads"
}

# install from github
# example: Install-Github "user/repo" "*.exe" "program-name"
function Install-Github($repo, $pattern, $name) {
  Save-fromGH $repo $pattern $name
  $extension = $pattern.Replace("*", "")
  $installfile = $name + $extension
  $installpath = "$env:USERPROFILE\Downloads\" + $installfile
  Start-Process $installpath
}


