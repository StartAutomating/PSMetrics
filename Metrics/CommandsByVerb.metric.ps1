<#
.SYNOPSIS
    Commands By Verb
.DESCRIPTION
    Commands by the command's verb
.EXAMPLE
    
#>
param(
[Parameter(ValueFromPipelineByPropertyName)]
[string]
$Verb
)

begin {
    $verbs = [Ordered]@{}    
}

process {
    $verbs[$Verb]++    
}

end {
    foreach ($sorted in $Verbs.GetEnumerator() | Sort-Object Value -Descending) {
        [PSCustomObject][Ordered]@{
            Verb  = $sorted.Key
            Count = $sorted.Value
        }
    }
}
