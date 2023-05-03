<#
.SYNOPSIS
    PipeScript Factor
.DESCRIPTION
    Calculates the factor of a generated PipeScript file to it's source
#>
param(
# The full name of the file
[Parameter(ValueFromPipelineByPropertyName)]
[string]
$Fullname,

# The file length
[Parameter(ValueFromPipelineByPropertyName)]
[long]
$Length
)

begin {
    $FileLengths = [Ordered]@{}    
}

process {
    $FileLengths[$fullName] = $Length
}

end {
    $PipeScriptFiles = [Ordered]@{}
    foreach ($kv in $FileLengths.GetEnumerator()) {
        if ($kv.Key -match '\.ps1?.(?<x>[^\.]+)$') {
            $x = $matches.x
            $v = $FileLengths[
                $kv.Key -replace '\.ps1?.(?<x>[^\.]+)$', ".$x"
            ]
            if ($v -and $kv.Value) {
                $PipeScriptFiles[$kv.Key] = $v / $kv.Value
            }            
        }
    }
    foreach ($sorted in $PipeScriptFiles.GetEnumerator() | Sort-Object Value -Descending) {
        [PSCustomObject][Ordered]@{
            File  = $sorted.Key
            Factor = $sorted.Value
        }
    }
}

