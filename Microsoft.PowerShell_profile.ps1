# #Requires -Version 7

# -------------------------------------------------------
# Current User, Current Host Powershell Core v7 $PROFILE:
# -------------------------------------------------------

# Load Functions, Aliases, and Completion
$psdir = (Split-Path -parent $profile)

. "$psdir\profile_functions.ps1"
. "$psdir\profile_aliases.ps1"
. "$psdir\profile_completion.ps1"

