[cmdletbinding(DefaultParameterSetName = "new")]
Param (
    [Parameter(Position = 0)][string] $module_dir_path = $(throw "Mandatory parameter not provided: <module_dir_path>"),
    [Parameter(ParameterSetName = "upgrade_major")][switch] $major,
    [Parameter(ParameterSetName = "upgrade_minor")][switch] $minor,
    [Parameter(ParameterSetName = "upgrade_patch")][switch] $patch,
    [Parameter(ParameterSetName = "new")][switch] $new,
    [Parameter(ParameterSetName = "new")][switch] $skip_manifest_update
)



##########  VARS  ###############################################

$defaults = @{
    'Author'            = 'Jimmy Briggs';
    'CompanyName'       = 'Jimmy Briggs';
    'Copyright'         = ('(c) ' + (Get-Date -UFormat %Y) + ' Jimmy Briggs. All rights reserved.');
    'ModuleVersion'     = '0.1.0';
    'PowerShellVersion' = '5.1';
    'FunctionsToExport' = '*';
    'AliasesToExport'   = '*';
    'ReleaseNotes'      = 'Initial release.';
    'CmdletsToExport'   = $null;
    'VariablesToExport' = $null;
    'Description'       = 'not provided'
}

$user_input_strings = @(
    'Description',
    'LicenseUri',
    'ProjectUri',
    'IconUri',
    'HelpInfoURI'
)

$user_input_lists = @(
    'Tags'
)

$user_update_strings = @(
    'ReleaseNotes'
)

##########  FUNCTIONS  ##########################################

#--------------------------------------------------
function Verify-PublicURL {
    param ([Parameter()][string] $url)
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    $wc = New-Object System.Net.WebClient
    try { $response = $wc.DownloadString($url) }
    catch { return $false }
    return $true
}


#--------------------------------------------------
function Bump-Version {
    param ([Parameter()][string] $version_segment_string)
    return [string](([int]$version_segment_string) += 1)
}



##########  MAIN  ###############################################

#--------------------------------------------------
# INIT
$ErrorActionPreference = 'Stop'
$host.PrivateData.ErrorBackgroundColor = $host.UI.RawUI.BackgroundColor
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
if (!(Get-Module UtilityFunctions)) { Import-Module UtilityFunctions -Force -DisableNameChecking }


#--------------------------------------------------
info "verifying module location... " -no_newline
$MODULE_PATH = $module_dir_path | abspath -verify
$MODULE_NAME = Split-Path $MODULE_PATH -Leaf
$MODULE_FILE_NAME = "$MODULE_NAME`.psm1"
$MODULE_FILE_PATH = (Resolve-Path (Join-Path $MODULE_PATH $MODULE_FILE_NAME)).Path
info "found" -success


#--------------------------------------------------
if (! $skip_manifest_update) {
    info "looking for module manifest file (.psd1)... " -no_newline
    $MODULE_MANIFEST_PATH = Join-Path $MODULE_PATH "$MODULE_NAME.psd1"
    $NEW_MANIFEST = $true
    if (Test-Path $MODULE_MANIFEST_PATH) {
        if ($new) {
            warning "found existing manifest."
            if (! (confirm "Parameter -new specified, overwrite existing manifest file?")) {
                info "manifest file has NOT been modified; exiting."
                newline
                exit
            }
        }
        else {
            $NEW_MANIFEST = $false
            info "found" -success
        }
    } else { warning "does not exist, will be created" -no_prefix}


    #--------------------------------------------------
    # CREATE NEW MANIFEST
    if ($NEW_MANIFEST) {
        info "creating new manifest:"
        $manifest = $defaults.Clone()
        $manifest.Add('RootModule', "./$MODULE_FILE_NAME")

        #--------------------------------------------------
        foreach ($item in $user_input_strings) {
            $value = $null
            info "  ? $item`: " -no_newline
            $value = Read-Host
            if ($value.Trim().Length -gt 0) { $manifest.$item = $value }
        }

        foreach ($item in $user_input_lists) {
            $value = $null
            info "  ? $item` (comma-separated): " -no_newline
            $value = Read-Host
            if ($value.Trim().Length -gt 0) { $manifest.$item = @($value.Split(',') | % {$_.Trim()}) }
        }

        # validating urls
        $urls_valid = $true
        foreach ( $key in ($manifest.Keys | ? { $_ -like '*Uri' }) ) {
            if ( ! (Verify-PublicURL $manifest.$key) ) {
                $urls_valid = $false
                error "Failed to verify URL for $key`: $($manifest.$key)"
            }
        }
        if (!$urls_valid) {
            if (! (confirm "Proceed?") ) {
                info "manifest file has NOT been created; exiting."
                newline
                exit
            }
        }

        #--------------------------------------------------
        info "generating manifest file... " -no_newline
        $command = "New-ModuleManifest -path '$MODULE_MANIFEST_PATH'"
        foreach ($key in $manifest.Keys) {
            if ($key -in $user_input_lists) {
                $command += " -$key $(($manifest.$key | % {"'$_'"}) -join (','))"
                continue
            }
            $command += " -$key '$($manifest.$key)'"
        }
        iex $command
        info "done" -success
    }


    #--------------------------------------------------
    # UPDATE EXISTING MANIFEST
    else {
        info "updating existing manifest:"
        $manifest = @{}
        $manifest_raw = cat $MODULE_MANIFEST_PATH -Raw

        # updating version
        $module_version = [regex]::Matches($manifest_raw, "(ModuleVersion\s+=\s+\')(\d+\.\d+\.\d+)(\')").Groups[2].Value.Split('.')
        if ($patch) { $module_version[2] = Bump-Version $module_version[2] }
        elseif ($minor) {
            $module_version[1] = Bump-Version $module_version[1]
            $module_version[2] = "0"
        }
        elseif ($major) {
            $module_version[0] = Bump-Version $module_version[0]
            $module_version[1] = "0"
            $module_version[2] = "0"
        }
        else { throw "Upgrade type not specified: major/minor/patch." }
        $manifest.ModuleVersion = $module_version -join '.'

        # updating copyright
        $copyright = [regex]::Matches($manifest_raw, "(Copyright\s+=\s+')(\(c\)[\s\d\-\.]+(\d{4})[^']+)'")
        $copyright_string = $copyright.groups[2].Value
        $copyright_date = $copyright.groups[3].Value
        $copyright_date_updated = Get-Date -UFormat %Y
        $manifest.Copyright = $copyright_string.replace($copyright_date, $copyright_date_updated)

        # updating release notes
        foreach ($item in $user_update_strings) {
            $value = $null
            info "  ? $item`: " -no_newline
            $value = Read-Host
            if ($value.Trim().Length -gt 0) { $manifest.$item = $value }
        }

        #--------------------------------------------------
        info "updating manifest file... " -no_newline
        $command = "Update-ModuleManifest -path '$MODULE_MANIFEST_PATH'"
        foreach ($key in $manifest.Keys) {
            if ($key -in $user_input_lists) {
                $command += " -$key $(($manifest.$key | % {"'$_'"}) -join (','))"
                continue
            }
            $command += " -$key '$($manifest.$key)'"
        }
        iex $command
        info "done" -success
    }
}


#--------------------------------------------------
# PUBLISH TO POWERSHELL GALLERY
info "ready to publish"
if (! (confirm "Publish module to PowerShell Gallery?")) {
    info "module will NOT be published; exiting."
    newline
    exit
}

$psgallery_api_key_file_path = "~\.psgallery" | abspath
if (Test-Path $psgallery_api_key_file_path) {
    $PSGALLERY_API_KEY = cat $psgallery_api_key_file_path -Raw | base64 -decrypt
}
else {
    info "  ? PowerShell Gallery API Key`: " -no_newline
    $PSGALLERY_API_KEY = Read-Host -AsSecureString | ss-to-plain
    $PSGALLERY_API_KEY | base64 | Out-File $psgallery_api_key_file_path -Force
}

info "publishing... " -no_newline
try { Publish-Module -Path $MODULE_PATH -NuGetApiKey $PSGALLERY_API_KEY | Out-Null }
catch {
    $err = $_
    if ($err.Exception -like '*The specified API key is invalid*') {
        rm $psgallery_api_key_file_path -Force -ErrorAction SilentlyContinue
    }
    throw $err.Exception
}
info "done" -success

info "Script finished successfully" -success
newline
