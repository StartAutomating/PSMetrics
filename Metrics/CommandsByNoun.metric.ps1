<#
.SYNOPSIS
    Commands By Noun
.DESCRIPTION
    Commands by the command's Noun
.EXAMPLE
    Get-Command -Module PSMetric -CommandType Function | CommandsByNoun
#>
param(
[Parameter(ValueFromPipelineByPropertyName)]
[string]
$Noun
)

begin {
    $Nouns = [Ordered]@{}    
}

process {
    $Nouns[$Noun]++    
}

end {
    foreach ($sorted in $Nouns.GetEnumerator() | Sort-Object Value -Descending) {
        [PSCustomObject][Ordered]@{
            Noun  = $sorted.Key
            Count = $sorted.Value
        }
    }
}
