#Requires -Version 7

# ----------------------------------------------------
# Current User, All Hosts Powershell Core v7 $PROFILE:
# ----------------------------------------------------

# Trust PSGallery
$galleryinfo = Get-PSRepository | Where-Object { $_.Name -eq "PSGallery" }
if (-not($galleryinfo.InstallationPolicy.Equals("Trusted"))) { Set-PSRepository -Name PSGallery -InstallationPolicy Trusted }

# Default Parameters
$PSDefaultParameterValues = @{ 
	"Update-Module:Confirm"=$False; 
	"Update-Module:Force"=$True; 
	"Update-Module:Scope"="CurrentUser"; 
	"Update-Module:ErrorAction"="SilentlyContinue";
	"Update-Help:Force"=$True;
	"Update-Help:ErrorAction"="SilentlyContinue"
}

# Prompt
Set-PoshPrompt -Theme wopian -ErrorAction SilentlyContinue

# ZLocation must be after all prompt changes:
Import-Module ZLocation
Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"

