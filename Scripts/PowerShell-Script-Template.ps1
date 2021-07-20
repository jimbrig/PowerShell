# MyScript.ps1
[CmdletBinding()]

PARAM (
    [string]$InitialDirectory = $(throw "-InitialDirectory is required."),
    [switch]$YesNoSwitch = $false
)

# Consider adding some comment based help for the script here.


#----------------[ Declarations ]----------------

# Set Error Action
$ErrorActionPreference = "Continue"

# Dot Source any required Function Libraries
. "C:\Scripts\Functions.ps1"

# Set any initial values
$Examplefile = "C:\scripts\example.txt"

#----------------[ Functions ]------------------
Function MyFunction1{
  Param()
  # Consider adding some comment based help for the function here.
  # main body of function1
}

Function MyFunction2{
  Param()
  # Consider adding some comment based help for the function here.
  # main body of function2
}

#----------------[ Main Execution ]---------------

# Script Execution goes here
# and can call any of the functions above.
