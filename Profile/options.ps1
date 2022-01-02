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

# Set PSReadLineOptions's (Beta Version Required):
Set-PSReadLineOption -PredictionSource History -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineOption -EditMode Windows
