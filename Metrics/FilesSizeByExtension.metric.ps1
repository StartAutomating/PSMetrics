<#
.SYNOPSIS
    File Size By Extension
.DESCRIPTION
    Gets the total file size for each extension
#>
param(
[Parameter(ValueFromPipelineByPropertyName)]
[string]
$Extension,

[Parameter(ValueFromPipelineByPropertyName)]
[long]
$Length
)

begin {
    $ExtensionsFound = @{}    
}

process {
    if (-not $ExtensionsFound[$Extension]) {
        $ExtensionsFound[$Extension] = [long]0
    }
    $ExtensionsFound[$Extension]+=$Length    
}

end {
    foreach ($sorted in $ExtensionsFound.GetEnumerator() | Sort-Object Value -Descending) {
        [PSCustomObject][Ordered]@{
            Extension = $sorted.Key
            Size = $sorted.Value
        }
    }
}
