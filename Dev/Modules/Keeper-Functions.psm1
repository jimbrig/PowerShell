# ------------------------------------------
# File  : Keeper-Functions.ps1
# Author: Jimmy Briggs
# Title : Keeper Password Manager Functions
# ------------------------------------------

Function Get-KeeperSecret {
    $secret_names = ("ls 'Secrets/Access-Tokens'" | keeper --batch-mode) -split ';'
    Read-Host -Prompt "Select a secret to retrieve: $secret_names" 
}

Function Get-TodoistAPIToken {
    "cc 'Secrets/Access-Tokens/Todoist API Token'" | keeper --batch-mode
    Write-Host "Todoist API Token has been copied to your clipboard."
}
