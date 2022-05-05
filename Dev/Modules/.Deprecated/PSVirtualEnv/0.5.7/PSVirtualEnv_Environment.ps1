# ===========================================================================
#   PSVirtualEnv_Environment.ps1 --------------------------------------------
# ===========================================================================

#   environment -------------------------------------------------------------
# ---------------------------------------------------------------------------
@(
    @{  # virtual environment variable
        Name="ProjectEnv"
        Value="$($PSVirtualEnv.Name.ToUpper())_PROJECT"
    }
    @{  # backup of virtual environment variable
        Name="ProjectEnvOld"
        Value="$($PSVirtualEnv.Name.ToUpper())_PROJECT_OLD"
    }
    @{  # backup of systems path environment variable
        Name="PathEnvOld"
        Value="$($PSVirtualEnv.Name.ToUpper())_PATH_OLD"
    }
    @{  #  pythonhome environment variable
        Name="PythonHome"
        Value="PYTHONHOME"
    }
    @{  # offline use of module
        Name="ProjectOffline"
        Value="$($PSVirtualEnv.Name.ToUpper())_OFFLINE"
    }
) | ForEach-Object {
    $PSVirtualEnv | Add-Member -MemberType NoteProperty -Name $_.Name -Value $_.Value
}

#   environment -------------------------------------------------------------
# ---------------------------------------------------------------------------
[System.Environment]::SetEnvironmentVariable("$($PSVirtualEnv.Name.ToUpper())_WORK", $PSVirtualEnv.WorkDir)
[System.Environment]::SetEnvironmentVariable("$($PSVirtualEnv.Name.ToUpper())_LOCAL", $PSVirtualEnv.LocalDir)
[System.Environment]::SetEnvironmentVariable("$($PSVirtualEnv.Name.ToUpper())_REQUIRE", $PSVirtualEnv.RequireDir)