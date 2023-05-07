Write-FormatView -TypeName Chart -Action {
    if (-not $global:ChartEngine) {
        $global:ChartEngine = 'ChartJS'
    }

    $_ | 
        Format-Custom -View $global:ChartEngine |
        Out-String -Width 1mb
}

Write-FormatView -TypeName Chart -Name ChartJS -Action {
    
    $chartInfo = $_
    $ChartName = $_.MetricName
    $chartLabels = @()
    $chartData = @()    
    foreach ($row in $chartInfo.ChartData) {
        $firstProp, $secondProp, $rest = @($row.psobject.properties)
        $chartLabels += $firstProp.Value
        $chartData += $secondProp.value
    }
    $chartHTMLID = $ChartName -replace '[\s\p{P}\<\>]'
    $chartType = if ($chartInfo.ChartType) {
        $chartInfo.ChartType
    } else {
        'bar'
    }
    @"
$(
if ($chartInfo.Metadata.Count) {
@(
"---"
foreach ($kv in $chartInfo.Metadata.GetEnumerator()) {
    "$($kv.Key): $(if ($kv.Value -is [string] -or $kv.Value.GetType().IsPrimitive) {
        $kv.Value
    } else {ConvertTo-Json $kv.Value -Compress})"
}
"---"
) -join [Environment]::NewLine
}
)
<div style='width:100%;height:100%;text-align:center;justify-content:center'>
<div style='max-height:90%;display:flex;margin-left:auto;margin-right:auto;text-align:center;justify-content:center'>
<canvas id="$chartHTMLID"></canvas>
</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>  
<script>
const ctx = document.getElementById('$chartHTMLID');
new Chart(ctx, {
    type: '$chartType',
    data: {
    labels: $($chartLabels | ConvertTo-Json -Compress),
    datasets: [{
        label: '$ChartName',
        data: $($chartData | ConvertTo-Json -Compress),$(if ($chartInfo.BackgroundColor) {
            "backgroundColor: $(ConvertTo-Json @($chartInfo.BackgroundColor))," + [Environment]::NewLine + (' ' * 8)
        })$(if ($chartInfo.BorderColor) {
            "borderColor: $(ConvertTo-Json @($chartInfo.BorderColor))," + [Environment]::NewLine + (' ' * 8)
        })
        borderWidth: 1
    }]
    }
});
</script>
"@  
    
}

Write-FormatView -TypeName Chart -Name PowerShellUniversal -Action {
    $chartInfo = $_
    $ChartName = $_.MetricName
    $chartLabels = @()
    $chartData = @()    
    foreach ($row in $chartInfo.ChartData) {
        $firstProp, $secondProp, $rest = @($row.psobject.properties)
        break
    }
    $chartHTMLID = $ChartName -replace '[\s\p{P}\<\>]'
    $chartType = if ($chartInfo.ChartType) {
        $chartInfo.ChartType
    } else {
        'bar'
    }

    "{New-UDChartJS -Data (
        ConvertFrom-JSON '$((ConvertTo-Json -Compress -InputObject $chartInfo.ChartData) -replace "'","''")'
    ) -Type $chartType -Id $chartHTMLID -DataProperty '$($secondProp.Name)' -LabelProperty '$($firstProp.Name)'$(
if ($chartInfo.BackgroundColor) { "-BackgroundColor '$($chartInfo.BackgroundColor -join "','")'"}
)
$(
if ($chartInfo.BorderColor) { "-BackgroundColor '$($chartInfo.BorderColor -join "','")'"}
)}"
}