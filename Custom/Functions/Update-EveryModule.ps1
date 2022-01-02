function Update-EveryModule {
    <#
    .SYNOPSIS
    Updates all modules from the PowerShell gallery.
    .DESCRIPTION
    Updates all local modules that originated from the PowerShell gallery.
    Removes all old versions of the modules.
    .PARAMETER ExcludedModules
    Array of modules to exclude from updating.
    .PARAMETER SkipMajorVersion
    Skip major version updates to account for breaking changes.
    .PARAMETER KeepOldModuleVersions
    Array of modules to keep the old versions of.
    .PARAMETER ExcludedModulesforRemoval
    Array of modules to exclude from removing old versions of.
    The Az module is excluded by default.
    .EXAMPLE
    Update-EveryModule -excludedModulesforRemoval 'Az'
    .NOTES
    Created by Barbara Forbes
    @ba4bes
    .LINK
    https://4bes.nl
    #>
    [cmdletbinding(SupportsShouldProcess = $true)]
    param (
        [parameter()]
        [array]$ExcludedModules = @(),
        [parameter()]
        [switch]$SkipMajorVersion,
        [parameter()]
        [switch]$KeepOldModuleVersions,
        [parameter()]
        [array]$ExcludedModulesforRemoval = @("Az")
    )
    # Get all installed modules that have a newer version available
    Write-Verbose "Checking all installed modules for available updates."
    $CurrentModules = Get-InstalledModule | Where-Object { $ExcludedModules -notcontains $_.Name -and $_.repository -eq "PSGallery" }

    # Walk through the Installed modules and check if there is a newer version
    $CurrentModules | ForEach-Object {
        Write-Verbose "Checking $($_.Name)"
        Try {
            $GalleryModule = Find-Module -Name $_.Name -Repository PSGallery -ErrorAction Stop
        }
        Catch {
            Write-Error "Module $($_.Name) not found in gallery $_"
            $GalleryModule = $null
        }
        if ($GalleryModule.Version -gt $_.Version) {
            if ($SkipMajorVersion -and $GalleryModule.Version.Split('.')[0] -gt $_.Version.Split('.')[0]) {
                Write-Warning "Skipping major version update for module $($_.Name). Galleryversion: $($GalleryModule.Version), local version $($_.Version)"
            }
            else {
                Write-Verbose "$($_.Name) will be updated. Galleryversion: $($GalleryModule.Version), local version $($_.Version)"
                try {
                    if ($PSCmdlet.ShouldProcess(
                        ("Module {0} will be updated to version {1}" -f $_.Name, $GalleryModule.Version),
                            $_.Name,
                            "Update-Module"
                        )
                    ) {
                        Update-Module $_.Name -ErrorAction Stop -Force
                        Write-Verbose "$($_.Name)  has been updated"
                    }
                }
                Catch {
                    Write-Error "$($_.Name) failed: $_ "
                    continue

                }
                if ($KeepOldModuleVersions -ne $true) {
                    Write-Verbose "Removing old module $($_.Name)"
                    if ($ExcludedModulesforRemoval -contains $_.Name) {
                        Write-Verbose "$($allversions.count) versions of this module found [ $($module.name) ]"
                        Write-Verbose "Please check this manually as removing the module can cause instabillity."
                    }
                    else {
                        try {
                            if ($PSCmdlet.ShouldProcess(
                                ("Old versions will be uninstalled for module {0}" -f $_.Name),
                                    $_.Name,
                                    "Uninstall-Module"
                                )
                            ) {
                                Get-InstalledModule -Name $_.Name -AllVersions
                                | Where-Object { $_.version -ne $GalleryModule.Version }
                                | Uninstall-Module -Force -ErrorAction Stop
                                Write-Verbose "Old versions of $($_.Name) have been removed"
                            }
                        }
                        catch {
                            Write-Error "Uninstalling old module $($_.Name) failed: $_"
                        }
                    }
                }
            }
        }
        elseif ($null -ne $GalleryModule) {
            Write-Verbose "$($_.Name) is up to date"
        }
    }
}