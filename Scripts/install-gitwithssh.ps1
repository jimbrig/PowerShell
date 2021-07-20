# Direct Run From GitHub
# Invoke-Expression -command "Invoke-WebRequest -uri 'https://raw.githubusercontent.com/jimbrig/jimsdots/main/powershell/install-gitwithssh.ps1' -UseBasicParsing -OutFile ./install-gitwithssh.ps1" ; . ./install-gitwithssh.ps1

# Set environment variables before calling in order to test
If ((Test-Path env:YourGitServerhttpURL) -and (!(Test-Path variable:YourGitServerhttpURL))) { $YourGitServerhttpURL = "$env:YourGitServerhttpURL" }
If ((Test-Path env:GitSSHUserAndEndPointForTesting) -and (!(Test-Path variable:GitSSHUserAndEndPointForTesting))) { $GitSSHUserAndEndPointForTesting = "$env:GitSSHUserAndEndPointForTesting" }
# $YourGitServerhttpURL="https://github.com"
# $GitSSHUserAndEndPointForTesting="$env:jimbrig@github.com.com" #Optional to trigger testing Use "git@github.com" for GitHub.

If (!(Test-Path 'C:\Program Files\git\usr\bin\ssh-keygen.exe')) {
  Write-Host 'Installing latest git client using Chocolatey'
  If (!(Test-Path env:chocolateyinstall)) {
    Write-Host "Chocolatey is not present, installing on demand."
    Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
  }
  cinst -y git
}
If (!(Test-Path $env:userprofile\.ssh\id_rsa.pub)) {
  Write-Host 'No default ssh key present in $env:userprofile\.ssh, generating a new one.'
  Write-Warning 'Press enter for default file name and twice for password to set it to not have a password'
  & 'C:\Program Files\git\usr\bin\ssh-keygen.exe'
}
get-content $env:userprofile\.ssh\id_rsa.pub | clip
write-host "Your public ssh key is now on your clipboard, ready to be pasted into your git server at $YourGitServerhttpURL"

If (Test-Path variable:GitSSHUserAndEndPointForTesting) {
  Write-Host 'NOTE: Sometimes it takes a while for your Git server to propagate your key so it is available for authentication after first adding it!'
  Write-Host 'After you have setup the key, to test the connection, press any key to continue...';
  $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
  #Use git's open ssh:
  Write-Host "...Testing ssh login as ${GitSSHUserAndEndPointForTesting} using key $env:userprofile\.ssh\id_rsa on port 22"
  $env:term = 'xterm256colors'
  push-location 'c:\program files\git\usr\bin'
  .\ssh.exe "${GitSSHUserAndEndPointForTesting}" -i $env:userprofile\.ssh\id_rsa -p 22
  pop-location
  Write-Host 'After observing the test result above (note it may take time for your new key to propagate at the server), press any key to continue...';
  $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}
