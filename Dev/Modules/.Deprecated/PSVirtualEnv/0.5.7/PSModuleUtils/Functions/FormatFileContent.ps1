# ===========================================================================
#   FormatFileContent.ps1 ---------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Format-IniContent  {

     <#
    .DESCRIPTION
        Searches for pattern '%(value)s' in specified content of a config file and replaces this pattern with the value of the referenced field or with the value of the corresponding system environment.

        [section]
        field-reference = value
        field-with-pattern-reference = %(field-reference)s\file-name
        field-with-pattern-environment = %(HOME)s\file-name

        Field 'field-with-pattern-reference' will be assigned the value 'value/file-name' and 'field-with-pattern-environment' gets the value 'C:\Users\User\file-name'.
    
    .PARAMETER Content

    .OUTPUTS
        System.Object. Formatted config content.
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.Object])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Content from config file.")]
        [System.Object] $Content,

        [Parameter(Position=2, HelpMessage="Object with values for substitution.")]
        [System.Object] $Substitution
    )
   
    Process {

        # loop over all sections in config object
        $keys = $Content.Keys -split " "
        for($i=0; $i -lt $keys.Count; $i++  ) {
            $Content.($keys[$i]) = Format-FileContent -Content $Content.($keys[$i]) -Substitution $Substitution
        }

        return $Content
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Format-JsonContent  {

    <#
   .DESCRIPTION
       Searches for pattern '%(value)s' in specified content of a json file and replaces this pattern with the value of a referenced field or with the value of the corresponding system environment.

        {
            'field-reference' : 'value'
            'field-with-pattern-reference' = '%(field-reference)s\file-name'
            'field-with-pattern-environment' = '%(HOME)s\file-name'
        }

       Field 'field-with-pattern-reference' will be assigned the value 'value/file-name' and 'field-with-pattern-environment' gets the value 'C:\Users\User\file-name'.
   
   .PARAMETER Content

   .OUTPUTS
       System.Object. Formatted json content.
   #>

   [CmdletBinding(PositionalBinding)]
   
   [OutputType([System.Object])]

   Param(
       [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Content from json file.")]
       [System.Object[]] $Content,

        [Parameter(Position=2, HelpMessage="Object with values for substitution.")]
        [System.Object] $Substitution
   )
  
   Process {

        # loop over all elements in json object
        for($i=0; $i -lt $Content.Length; $i++) {
            $hashtable = ConvertTo-HashtableFromObject $Content[$i]
            $result = Format-FileContent -Content $hashtable -Substitution $Substitution
            $Content[$i] = ConvertTo-ObjectFromHashtable $result
        }

        return $Content
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Format-FileContent  {
    <#

    .DESCRIPTION

    .PARAMETER Content

    .OUTPUTS
        System.Object. Formatted config content.
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.Object])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Content of a arbitrary file.")]
        [System.Object] $Content,

        [Parameter(Position=2, HelpMessage="Object with values for substitution.")]
        [System.Object] $Substitution
    )
   
    Process {

        # loop over all fields in a specific config section
        if ($Substitution){
            $default_keys = ($Substitution  | Get-Member | Where-Object {$_.MemberType -eq "NoteProperty" -or $_.MemberType -eq "Property"} | Select-Object -ExpandProperty Name) -split " "
        }
        $default = $False 
        if ($default_keys) {
            $default = $True
        }

        $keys_sec = $Content.Keys -split " "

        for($j=0; $j -lt $keys_sec.Count; $j++ ) {
            # if there are matches each result will be stored and replaced with referenced field or corresponding environment variable
            $Content.($keys_sec[$j]) = Get-FormattedString -String $Content.($keys_sec[$j]) -Keys $keys_sec -Object $Content -Default:$default -DefaultKeys $default_keys -DefaultObject $Substitution
        }
        return $Content
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-FormattedString  {
    <#

    .DESCRIPTION

    .PARAMETER String

    .OUTPUTS
        System.Object. Object which contains all values inside ini pattern.
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.Object])]
    
    Param (

        [Parameter(HelpMessage="Search string.")]
        [System.String] $String,

        [Parameter(HelpMessage="Keys for substitution.")]
        [System.Object] $Keys,

        [Parameter(HelpMessage="Object with elements for substitution.")]
        [System.Object] $Object,

        [Parameter(HelpMessage="Use default object for substitution.")]
        [Switch] $Default,

        [Parameter(HelpMessage="Default keys for substitution.")]
        [System.Object] $DefaultKeys,

        [Parameter(HelpMessage=
            "Default object with elements for substitution.")]
        [System.Object] $DefaultObject

    )

    Process{ 
        $string_backup = $String
        $pattern = "\%\(([a-z-_]+)\)s"
        
        # if there are matches each result will be stored and replaced with referenced field or corresponding environment variable
        Get-RegexMatchResultList -String $String -Pattern $pattern | ForEach-Object {
            # search for reference field and corresponding environment variable
            $value = $Null
            if ($Keys -contains $_){
                $value = $Object.($_)
            }
            elseif ($Default) {
                if ($DefaultKeys -contains $_){
                    $value = $DefaultObject.($_)
                }
            } 
            
            if (-not $value) {
                $value = [System.Environment]::GetEnvironmentVariable($_)
            }
            
            if ($value) {
                # replace the pattern in given field as well as return formatted string
                $String = [Regex]::Replace( $String, "\%\(($_)\)s", $value, "IgnoreCase")
            }
        }
        
        # if the search pattern was found and string was modified, perform a recursive proceeding, else return the string
        if ($string_backup -eq $String){
            return $String
        } else {
            return Get-FormattedString -String $String -Keys $Keys -Object $Object -Default:$Default -DefaultKeys $DefaultKeys -DefaultObject $DefaultObject
        }
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-RegexMatchResultList {

    Param(
        [Parameter(HelpMessage="Search string.")]
        [System.String] $String,

        [Parameter(HelpMessage="Search patterm.")]
        [System.String] $Pattern
    )

    return [Regex]::Matches($String, $Pattern, "IgnoreCase").Groups | Where-Object { $_.Name -eq 1} | Select-Object -ExpandProperty Value
}