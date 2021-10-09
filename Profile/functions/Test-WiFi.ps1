Function Test-WiFi {
  if (Test-Connection -Count 4 -Quiet -Delay 3 www.github.com) {
    Write-Host "Internet Connection is good to go." -ForegroundColor Green
  }
  else {
    Write-Host "Not connected to the internet." -ForegroundColor Red
    netsh wlan disconnect; Start-Sleep 2;
    netsh wlan connect name=vino-enhanced-5G-2;
  }
}

