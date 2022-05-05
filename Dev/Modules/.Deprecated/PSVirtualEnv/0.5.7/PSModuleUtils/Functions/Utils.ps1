# ===========================================================================
#   Utils.ps1 ---------------------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-TemporaryFile {
    <#
    .DESCRIPTION
        Return a random file name in system's temp folder.

    .PARAMETER Extension

    .PARAMETER Directory

    .OUTPUTS
        Systems.String. Random file name.
    #>
    
    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String])]

    Param(

        [Parameter(HelpMessage="Extension of temporary file, to be created, e.g. '.json'")]
        [System.String] $Extension,

        [Parameter(HelpMessage="Return a temporary folder name.")]
        [Switch] $Directory
    )

    Process{
        
        $temp_path = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([Guid]::NewGuid()).ToString()
        $temp_ext = ".tmp"

        if ($Directory) {
            return $temp_path
        }
        
        if ($Extension){
            return $temp_path + $Extension
        } else {
            return $temp_path + $temp_ext
        }
   }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function New-TemporaryDirectory {

    <#
    .DESCRIPTION
        Creates a folder with a random name in system's temp folder.

    .OUTPUTS
        Systems.String. Absolute path of created temporary folder.
    #>
    
    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String])]

    Param()

    $path = Get-TemporaryFile -Directory

    #if/while path already exists, generate a new path
    While(Test-Path -Path $path) {
        $path = Get-TemporaryFile -Directory
    }

    #create directory with generated path
    New-Item -Path $path -ItemType Directory
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function New-TemporaryFile {

    <#
    .DESCRIPTION
        Creates a random file name in system's temp folder.

    .PARAMETER Extension

    .OUTPUTS
        Systems.String. Absolute path of created random file.
    #>
    
    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String])]

    Param(
        [Parameter(HelpMessage="Extension of temporary file, to be created, e.g. '.json'")]
        [System.String] $Extension
    )

    $path = Get-TemporaryFile -Extension $Extension

    #if/while path already exists, generate a new path
    While(Test-Path -Path $path) {
        $path = Get-TemporaryFile -Extension $Extension
    }

    #create directory with generated path
    New-Item -Path $path -ItemType File
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function ConvertTo-ObjectFromHashtable {
        
    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.Object])]

    Param (
        [Parameter(Position=1, Mandatory, ValueFromPipeline,ValueFromPipelineByPropertyName)] 
        [System.Object[]] $Hashtable
    )
   
    Begin { $i = 0; }
   
    Process {
        foreach ($element in $Hashtable) {
            if ($element.GetType().Name -eq 'Hashtable') {
                $object = New-Object -TypeName PSObject

                Add-Member -InputObject $object -MemberType ScriptMethod -Name AddNote -Value { 
                    Add-Member -InputObject $this -MemberType NoteProperty -Name $args[0] -Value $args[1];
                };
                $element.Keys | Sort-Object | ForEach-Object { 
                    $object.AddNote($_, $element.$_); 
                }
            } else {
                Write-Warning "Index $i is not of type [Hashtable]";
            }
            $i += 1; 
        }
        return $object
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function ConvertTo-HashtableFromObject {
    
    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.Object])]
    
    Param (
        [Parameter(Position=1, Mandatory, ValueFromPipeline,ValueFromPipelineByPropertyName)] 
        [System.Object[]] $Object
    )
   
    Process {
        foreach ($element in $Object) {
            $hashtable = @{}
            $element | Get-Member -MemberType *Property | ForEach-Object {
                $hashtable.($_.name) = $element.($_.name)
            }
            
            return $hashtable;
        }
    }
} 