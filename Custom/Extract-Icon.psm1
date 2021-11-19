Function New-IconFromExe {
	<#
	.SYNOPSIS
		This function extracts an icon/image from an executable (*.exe).
	.DESCRIPTION
		This function extracts an icon/image from an executable (*.exe).
	.PARAMETER Path
        Path to the executable file.
	.PARAMETER Destination
        Path to desired destination folder.
    .PARAMETER Name
        Optional alternative basename for the created image file. Defaults to the basename (minus extension) of executable.
    .PARAMETER Format
        Desired format for the created image file: "ico", "bmp", "png", "jpg", or "gif".
	.LINK
        https://community.spiceworks.com/topic/592770-extract-icon-from-exe-powershell
    .LINK
        https://learn-powershell.net/2016/01/18/getting-the-icon-from-a-file-using-powershell/
	.EXAMPLE
		New-IconFromExe "C:\Program Files\PowerShell\7\pwsh.exe" "$HOME\OneDrive\Pictures\Icons\Programs\" "PowerShellCore" "ico"
	#>
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Specify the path to the file.")]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path,

        [Parameter(Position = 1, HelpMessage = "Specify the folder to save the file.")]
        [ValidateScript({ Test-Path $_ })]
        [string]$Destination = ".",

        [parameter(Position = 2, HelpMessage = "Specify an alternate base name for the new image file. Otherwise, the source name will be used.")]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Position = 3, HelpMessage = "What format do you want to use? The default is png.")]
        [ValidateSet("ico", "bmp", "png", "jpg", "gif")]
        [string]$Format = "png"
    )

    Write-Verbose "Starting $($MyInvocation.MyCommand)"

    Try {
        Add-Type -AssemblyName System.Drawing -ErrorAction Stop
    }
    Catch {
        Write-Warning "Failed to import System.Drawing"
        Throw $_
    }

    Switch ($format) {
        "ico" { $ImageFormat = "icon" }
        "bmp" { $ImageFormat = "Bmp" }
        "png" { $ImageFormat = "Png" }
        "jpg" { $ImageFormat = "Jpeg" }
        "gif" { $ImageFormat = "Gif" }
    }

    $file = Get-Item $path
    Write-Verbose "Processing $($file.fullname)"

    #convert destination to file system path
    $Destination = Convert-Path -path $Destination

    if ($Name) {
        $base = $Name
    }
    else {
        $base = $file.BaseName
    }

    #construct the image file name
    $out = Join-Path -Path $Destination -ChildPath "$base.$format"

    Write-Verbose "Extracting $ImageFormat image to $out"
    $ico = [System.Drawing.Icon]::ExtractAssociatedIcon($file.FullName)

    if ($ico) {
        #WhatIf (target, action)
        if ($PSCmdlet.ShouldProcess($out, "Extract icon")) {
            $ico.ToBitmap().Save($Out, $Imageformat)
            Get-Item -path $out
        }
    }
    else {
        #this should probably never get called
        Write-Warning "No associated icon image found in $($file.fullname)"
    }

    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}
