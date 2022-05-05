# ===========================================================================
#   PSVirtualEnv_Settings.ps1 -----------------------------------------------
# ===========================================================================

#   settings ----------------------------------------------------------------
# ---------------------------------------------------------------------------

# check installation of python distribution
$PSVirtualEnv.Python = Find-Python -Verbose

# repair python distribution for full functionality of module
Repair-Python -Silent
