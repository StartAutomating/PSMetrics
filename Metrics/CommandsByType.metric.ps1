<#
.SYNOPSIS
    Commands By Type
.DESCRIPTION
    Commands by the type of command
.EXAMPLE

#>
param(
[Parameter(ValueFromPipelineByPropertyName)]
[string]
$CommandType
)

begin {
    $CommandTypes = @{}    
}

process {
    $CommandTypes[$CommandType]++    
}

end {
    foreach ($sorted in $CommandTypes.GetEnumerator() | Sort-Object Value -Descending) {
        [PSCustomObject][Ordered]@{
            CommandType  = $sorted.Key
            Count = $sorted.Value
        }
    }
}
