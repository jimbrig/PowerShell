# Install-fromURL
# example: Install-fromURL "<url>" "program-name"
function Install-fromURL($uri, $name) {
  $out = "$env:USERPROFILE\Downloads\$name.exe"
  Invoke-WebRequest -Uri $uri -OutFile $out
  Start-Process $out
}

# Get Github Download URL
# example: Get-GHDownloadURL "user/repo" "*.exe"
function Get-GHDownloadURL($repo, $pattern) {
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

# Install Cascadia Code from Nerd Fonts
function Install-CascadiaCode {

  $address = Get-GHDownloadURL "ryanoasis/nerd-fonts" "CascadiaCode.zip"
  $archive = "$($Env:TEMP)\CascadiaCode.zip"
  $folder = "$($Env:TEMP)\CascadiaCode"
  $shell = New-Object -ComObject Shell.Application
  $obj = $shell.Namespace(0x14)
  $systemFontsPath = $obj.Self.Path

  Invoke-RestMethod -Method Get -Uri $address -OutFile $archive
  Expand-Archive -Path $archive -DestinationPath $folder -Force

  $shouldReboot = $false

  Get-ChildItem -Path $folder | ForEach-Object {
    $path = $_.FullName
    $fontName = $_.Name

    $target = Join-Path -Path $systemFontsPath -ChildPath $fontName

    if (test-path $target) {
      Write-Host "Ignoring $($path) as it already exists." -ForegroundColor Magenta
    }
    else {
      Write-Host "Installing $($path)..." -ForegroundColor Cyan
      $obj.CopyHere($path)
    }
  }

  Remove-Item -Path $folder -Recurse -Force -EA SilentlyContinue
}

# invoke remote script
# example: Invoke-RemoteScript
Function Invoke-RemoteScript {
  [CmdletBinding()]
  param(
    [Parameter(Position = 0)]
    [string]$address,
    [Parameter(ValueFromRemainingArguments = $true)]
    $remainingArgs
  )

  Invoke-Expression "& { $(Invoke-RestMethod $address) } $remainingArgs"
}

# Download Profile from jimsdots on Github
Function Download-Profile {
  [CmdletBinding()]
  param(
    [Parameter(Position = 0)]
    [string]$name
  )

  $template = "Microsoft.PowerShell_%{NAME}%profile.ps1"
  $address = "https://raw.githubusercontent.com/jimbrig/jimsdots/main/powershell/"
  $fileName = Split-Path $profile -Leaf
  $uri = "$($address)$($fileName)"
  $destination = Join-Path -Path (Split-Path $profile) -ChildPath $fileName

  Write-Host "GET $uri HTTP/1.1" -ForegroundColor Magenta

  New-Item `
    -Path (Split-Path $profile) `
    -ItemType Directory `
    -EA SilentlyContinue `
  | Out-Null

  Invoke-RestMethod `
    -Method Get `
    -Uri $uri `
    -OutFile $destination

  Write-Host "$destination updated." -ForegroundColor Cyan
}
