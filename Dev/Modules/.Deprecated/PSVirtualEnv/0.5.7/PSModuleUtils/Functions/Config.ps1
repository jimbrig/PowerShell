# ===========================================================================
#   Config.ps1 --------------------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-ConfigHome {

    <#
    .DESCRIPTION
        Get the base directory relative to which user specific configuration files should be stored. It is XDG compatible, which means that if the environment variable 'XDG_CONFIG_HOME' is defined it will use the configuration folder 'XDG_CONFIG_HOME/<project-name>' instead.
    
    .OUTPUTS
        System.String. Configuration base directory.
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String])]

    Param()

    Process {
        $config_home = Join-Path -Path $([System.Environment]::GetEnvironmentVariable("USERPROFILE", "process")) -ChildPath ".config"

        $xdg_home = [System.Environment]::GetEnvironmentVariable("XDG_CONFIG_HOME", "process")
        if ($xdg_home) {
            $config_home = $xdg_home
        }

        return $config_home
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function New-ConfigHome {

    <#
    .DESCRIPTION
        Create the base directory relative to which user specific configuration files should be stored. It is XDG compatible, which means that if the environment variable 'XDG_CONFIG_HOME' is defined it will use the configuration folder 'XDG_CONFIG_HOME/<project-name>' instead.
        
    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([Void])]

    Param()

    Process {
        $config_home = Get-ConfigHome

        if(-not $(Test-Path -Path $config_home)){
            New-Item -Path $config_home -ItemType Directory
        }
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-ConfigProjectDirList {

    <#
    .DESCRIPTION
        Get specific '<project-name'> configuration directories where configuration files might be stored

    .OUTPUTS
        System.String. Folder where configuration files might be stored.
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage="Name of project.")]
        [System.String] $Name
    )

    Process {
        $dir_list = New-Object -TypeName System.Collections.Generic.List[System.Object]
        
        $xdg_dir_list = [System.Environment]::GetEnvironmentVariable("XDG_CONFIG_DIRS", "process")
        if ($xdg_dir_list) {
            # config_home should also be included on top of 'XDG_CONFIG_DIRS'
            foreach($xdg_dir in $($xdg_dir_list -split ";")) {
                if (-not $xdg_dir){
                    continue
                }
                [Void] $dir_list.Add($(Join-Path -Path $xdg_dir -ChildPath $Name))
            }
        }
        # Take 'XDG_CONFIG_HOME' and '%USERPROFILE%/.<project-name>' for backwards compatibility
        [Void] $dir_list.Add($(Join-Path -Path $(Get-ConfigHome) -ChildPath $Name))

        return $dir_list
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-ConfigProjectDir {

    <#
    .DESCRIPTION
        Get folder where the configuration files are stored, e.g. '%USERPROFILE%/.<project-name>'. It is XDG compatible, which means that if the environment variable 'XDG_CONFIG_HOME' is defined it will use the configuration folder 'XDG_CONFIG_HOME/<project-name>' instead.

    .PARAMETER Name

    .OUTPUTS
        System.String. Folder where the configuration files are stored
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage="Name of project.")]
        [System.String] $Name
    )

    Process {

        foreach ($dir in (Get-ConfigProjectDirList -Name $Name) ) {
            if ($(Test-Path -Path $dir)) {
                return $dir
            }
        }

        # If no folder is found, then return config home
        $config_home = Join-Path -Path (Get-ConfigHome) -ChildPath $Name

        return $config_home
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-ConfigProjectFile {

    <#
    .DESCRIPTION
        Get configuration base file locate in project configuration folder, e.g. '%USERPROFILE%/.<project-name>/config.ini'. 

    .PARAMETER Name

    .OUTPUTS
        System.String. Path of configuration base file
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage="Name of project.")]
        [System.String] $Name
    )

    Process {

        return Join-Path -Path $(Get-ConfigProjectDir -Name $Name) -ChildPath "config.ini"
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function New-ConfigProjectDir  {

    <#
    .DESCRIPTION
        Create folder where the configuration files are stored, e.g. '%USERPROFILE%/.<project-name>'. It is XDG compatible, which means that if the environment variable 'XDG_CONFIG_HOME' is defined it will use the configuration folder 'XDG_CONFIG_HOME/<project-name>' instead.
    
    .PARAMETER Name

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([Void])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage="Name of project.")]
        [System.String] $Name
    )

    Process {
        $config_home = Get-ConfigProjectDir -Name $Name

        if(-not $(Test-Path -Path $config_home)){
            New-Item -Path $config_home -ItemType Directory
        }

    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-ScriptProjectDir {

    <#
    .DESCRIPTION
        Get folder where the scripts are stored, e.g. '%USERPROFILE%/.<project-name>/scripts'. It is XDG compatible, which means that if the environment variable 'XDG_CONFIG_HOME' is defined it will use the configuration folder 'XDG_CONFIG_HOME/<project-name>/scripts' instead.

    .PARAMETER Name

    .OUTPUTS
        System.String. Folder where the scripts are stored
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage="Name of project.")]
        [System.String] $Name
    )

    Process {

        $config_home = $Null
        foreach ($dir in (Get-ConfigProjectDirList -Name $Name) ) {
            if ($(Test-Path -Path $dir)) {
                $config_home = $dir
                break
            }
        }

        # If no folder is found, then return config home
        if (-not $config_home){
            Join-Path -Path $(Get-ConfigProjectDir -Name $Name) -ChildPath $Name
        } 
        
        $scripts_home = Join-Path -Path $config_home -ChildPath "scripts"
        
        return $scripts_home
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function New-ScriptProjectDir  {

    <#
    .DESCRIPTION
        Create folder where the scripts are stored, e.g. '%USERPROFILE%/.<project-name>/scripts'. It is XDG compatible, which means that if the environment variable 'XDG_CONFIG_HOME' is defined it will use the configuration folder 'XDG_CONFIG_HOME/<project-name>/scripts' instead.
    
    .PARAMETER Name

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([Void])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage="Name of project.")]
        [System.String] $Name
    )

    Process {
        $scripts_home = Get-ScriptProjectDir -Name $Name

        if(-not $(Test-Path -Path $scripts_home)){
            New-Item -Path $scripts_home -ItemType Directory
        }

    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-ProjectDir {

    <#
    .DESCRIPTION
        Get folder where the project files are stored, e.g. '%USERPROFILE%/<project-name>'.

    .PARAMETER Name

    .OUTPUTS
        System.String. Folder where the project files are stored
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage="Name of project.")]
        [System.String] $Name,

        [Parameter(HelpMessage="If folder does not exist, it will be created.")]
        [Switch] $Force
    )

    Process {
        $project_home = Join-Path -Path $([System.Environment]::GetEnvironmentVariable("USERPROFILE", "process")) -ChildPath $Name

        return $project_home
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function New-ProjectDir  {

    <#
    .DESCRIPTION
        Create folder where the project files are stored, e.g. '%USERPROFILE%/<project-name>'.
    
    .PARAMETER Name

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([Void])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage="Name of project.")]
        [System.String] $Name
    )

    Process {
        $project_home = Get-ProjectDir -Name $Name

        if(-not $(Test-Path -Path $project_home)){
            New-Item -Path $project_home -ItemType Directory
        }

    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function New-ProjectConfigDirs  {

    <#
    .DESCRIPTION
        Create folder where configuration and  scripts are stored, e.g. '%USERPROFILE%/.<project-name>'. It is XDG compatible, which means that if the environment variable 'XDG_CONFIG_HOME' is defined it will use the configuration folder 'XDG_CONFIG_HOME/<project-name>/scripts' instead.
    
    .PARAMETER Name

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([Void])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage="Name of project.")]
        [System.String] $Name
    )

    Process {

        New-ConfigHome
        New-ConfigProjectDir -Name $Name
        New-ScriptProjectDir -Name $Name
        # New-ProjectDir -Name $Name

    }
}
