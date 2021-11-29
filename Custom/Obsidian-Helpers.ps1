# ------------------------------------
# Obsidian Helper PowerShell Functions
# ------------------------------------

Function Select-ObsidianVault {
    $ObsidianConfig = "$env:APPDATA\Obsidian\obsidian.json"

	$VaultKeys = Get-Content $ObsidianConfig | jq .vaults | jq keys | ConvertFrom-Json
	$VaultPaths = Get-Content $ObsidianConfig | jq '.vaults' | jq 'map(.path)' | ConvertFrom-Json
	$VaultNames = $VaultPaths | Split-Path -Leaf
	
	If (!($VaultNames.Count -gt 1)) { throw }
	
	Write-Host "Select a Vault:" -ForeGroundColor Yellow
	for($i = 0; $i -lt $VaultNames.count; $i++) {
		Write-Host "$($i): $($VaultNames[$i]) | $($VaultNames[$i])"
	}

	$selection = Read-Host -Prompt "Enter the Number for the Vault to Open:"
	$selectedVault = @{Name = $VaultNames[$selection]; Path = $VaultPaths[$selection]; ID = $VaultKeys[$selection] }
    $selectedVault
}

Function Backup-ObsidianVault {

    $vault = Select-ObsidianVault
    $vaultPath = $vault.Path
    $tempdir = "C:\temp"
    Copy-Item $vaultPath "$tempdir\$($vault.Name)" -Recurse -Force

    $gdrive = "G:\My Drive\2-Areas\Obsidian\Backups"
    $time = Get-Date -Format yyyy-MM-dd
    $backupFile = "$gdrive\$time-$($vault.Name).zip"
    Compress-Archive  "$tempdir\$($vault.Name)" $backupFile -Force
}

Function Get-ObsidianVaults {
    $ObsidianConfig = "$env:APPDATA\Obsidian\obsidian.json"
    $VaultKeys = cat $ObsidianConfig | jq .vaults | jq keys | ConvertFrom-Json
	$VaultPaths = cat $ObsidianConfig | jq '.vaults' | jq 'map(.path)' | ConvertFrom-Json
	$VaultNames = $VaultPaths | Split-Path -Leaf

    If (!($VaultNames.Count -gt 1)) { throw }

    Write-Host "Obsidian Vaults:" -ForegroundColor Yellow
    for($i = 0; $i -lt $VaultNames.count; $i++) {
		Write-Host "$($i): $($VaultNames[$i]) | $($VaultPaths[$i])"
	}
}
