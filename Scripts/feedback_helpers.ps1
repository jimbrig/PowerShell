function Write-Success ($text) {
  $msg = "✔️ Success: " + $text
  Write-Host $msg -ForegroundColor Green
}

function Write-Begin ($text) {
  $msg = "🕜 Begin: " + $text
  Write-Host $msg -ForegroundColor Cyan
}
