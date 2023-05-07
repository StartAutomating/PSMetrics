<#
.SYNOPSIS
    Gets types by namespace
.DESCRIPTION
    Gets the number of types in each namespace.
.LINK
    Import-Metric
.EXAMPLE
    [PSObject].Assembly.GetTypes() | TypesByNamespace -First 10
.EXAMPLE
    [PSObject].Assembly.GetTypes() | ? IsPublic | TypesByNamespace -First 10
#>
param(
[Parameter(ValueFromPipelineByPropertyName)]
[string]
$Namespace
)

begin {
    $NamespacesFound = [Ordered]@{}    
}

process {
    $NamespacesFound[$Namespace]++    
}

end {
    foreach ($sorted in $NamespacesFound.GetEnumerator() | Sort-Object Value -Descending) {
        [PSCustomObject][Ordered]@{
            Namespace = $sorted.Key
            Count = $sorted.Value
        }
    }
}
