# #Requires -Version 7

# -------------------------------------------------------
# Current User, Current Host Powershell Core v7 $PROFILE:
# -------------------------------------------------------

$psdir = (Split-Path -Parent $profile)

. "$psdir\Profile\functions.ps1"
. "$psdir\Profile\aliases.ps1"
. "$psdir\Profile\completion.ps1"
. "$psdir\Profile\modules.ps1"
