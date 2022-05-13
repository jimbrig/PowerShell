<#PSScriptInfo
.VERSION 
1.0.0

.GUID 
1a3a69ce-b6a1-443b-8e2d-781e2a302d87

.AUTHOR 
Jimmy Briggs

.TAGS
markdown tree
#>

<# 
.SYNOPSIS
Script for creating a markdown file with a folder's tree.
.DESCRIPTION
Script for creating a markdown file with a folder's tree.
.PARAMETER Path
Provide the Path to search for the file tree.
.PARAMETER fileName
Provice the file name for the generated .md file.
.INPUTS
N/A
.OUTPUTS
N/A
.NOTES
N/A
#>

param(
    [string]$Path = $PSScriptRoot,
    [string]$fileName = "folders"
)
if (!(Test-Path $Path -PathType Container)) { throw "Wrong directory path" }

function Get-FolderStructureToMarkdown ([string]$Path, [int]$Level) {
    foreach ($childDirectory in Get-ChildItem -Force -LiteralPath $Path -Directory | Sort-Object -Property BaseName -Descending) {
        $childFolders = Get-FolderStructureToMarkdown -Path $childDirectory.FullName -Level ($Level + 1)
    }

    $folderName = Split-Path -Path $Path -Leaf

    switch ($Level) {
        2 { $folderName = "1. $folderName"; Break }
        1 { $folderName = "`r`n## $folderName`r`n"; Break }
        0 { $folderName = "# $folderName"; Break }
        { $_ -ge 3 } { $folderName = "$('   ' * ($Level - 2))- $folderName"; Break }
    }

    return $folderName + "`r`n" + $childFolders
}

Get-FolderStructureToMarkdown -Path $Path > "$(Join-Path -Path $Path -ChildPath $fileName).md"