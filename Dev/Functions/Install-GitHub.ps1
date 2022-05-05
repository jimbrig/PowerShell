Function Install-GitHubRepo {
	<#
	.SYNOPSIS
		This function retrieves the specified repository on GitHub to a local directory with authentication.
	.DESCRIPTION
		This function retrieves the specified repository on GitHub to a local directory with authentication, being a single file, a complete folder, or the entire repository.
	.PARAMETER User
		Your GitHub username, for using the Authenticated Service. Providing 5000 requests per hour.
		Without this you will be limited to 60 requests per hour.
		See for more information: https://developer.github.com/v3/auth/
	.PARAMETER Token
		The parameter Token is the generated token for authenticated users.
		Create one here (after logging in on your account): https://github.com/settings/tokens
	.PARAMETER Owner
		Owner of the repository you want to download from.
	.PARAMETER Repository
		The repository name you want to download from.
	.PARAMETER Path
		The path inside the repository you want to download from.
		If empty, the function will iterate the whole repository.
		Alternatively you can specify a single file.
	.PARAMETER DestinationPath
		The local folder you want to download the repository to.
	.EXAMPLE
		PS C:\> Install-GitHubRepo -User "jimbrig" -Token $env:GITHUB_PAT -Owner "jimbrig" -Repository "jimsdots" -Path "powershell" -DestinationPath "$HOME\Downloads\PowerShell"
	#>

	Param(
		[Parameter(Mandatory=$True)]
		[string]$User,

		[Parameter(Mandatory=$True)]
		[string]$Token,

		[Parameter(Mandatory=$True)]
		[string]$Owner,

		[Parameter(Mandatory=$True)]
		[string]$Repository,

		[Parameter(Mandatory=$True)]
		[AllowEmptyString()]
		[string]$Path,

		[Parameter(Mandatory=$True)]
		[string]$DestinationPath
	)

	# Authentication
	$authPair = "$($User):$($Token)";
	$encAuth = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($authPair));
	$headers = @{ Authorization = "Basic $encAuth" };

	# REST Building
	$baseUri = "https://api.github.com";
	$argsUri = "repos/$Owner/$Repository/contents/$Path";
	$wr = Invoke-WebRequest -Uri ("$baseUri/$argsUri") -Headers $headers;

	# Data Handler
	$objects = $wr.Content | ConvertFrom-Json
	$files = $objects | Where-Object {$_.type -eq "file"} | Select-Object -exp download_url
	$directories = $objects | Where-Object {$_.type -eq "dir"}

	# Iterate Directory
	$directories | ForEach-Object {
		DownloadFilesFromRepo -User $User -Token $Token -Owner $Owner -Repository $Repository -Path $_.path -DestinationPath "$($DestinationPath)/$($_.name)"
	}

	# Destination Handler
	if (-not (Test-Path $DestinationPath)) {
		try {
			New-Item -Path $DestinationPath -ItemType Directory -ErrorAction Stop;
		} catch {
			throw "Could not create path '$DestinationPath'!";
		}
	}

	# Iterate Files
	foreach ($file in $files) {
		$fileDestination = Join-Path $DestinationPath (Split-Path $file -Leaf)
		$outputFilename = $fileDestination.Replace("%20", " ");
		try {
			Invoke-WebRequest -Uri "$file" -OutFile "$outputFilename" -ErrorAction Stop -Verbose
			"Grabbed '$($file)' to '$outputFilename'";
		} catch {
			throw "Unable to download '$($file)'";
		}
	}
}
