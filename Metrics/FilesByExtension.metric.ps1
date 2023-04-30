<#
.SYNOPSIS
    Gets files by extension
.DESCRIPTION
    Gets the number of files of each extension.
.LINK
    Import-Metric
.EXAMPLE
    dir -File -Recurse | FilesByExtension
#>
param(
[Parameter(ValueFromPipelineByPropertyName)]
[string]
$Extension
)

begin {
    $ExtensionsFound = @{}    
}

process {
    $ExtensionsFound[$Extension]++    
}

end {
    foreach ($sorted in $ExtensionsFound.GetEnumerator() | Sort-Object Value -Descending) {
        [PSCustomObject][Ordered]@{
            Extension = $sorted.Key
            FileCount = $sorted.Value
        }
    }
}
