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

<canvas id="$chartHTMLID"></canvas>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>  
<script>
const ctx = document.getElementById('$chartHTMLID');
new Chart(ctx, {
    type: '$chartType',
    data: {
    labels: $($chartLabels | ConvertTo-Json -Compress),
    datasets: [{
        label: '$ChartName',
        data: $($chartData | ConvertTo-Json -Compress),
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

    "New-UDChartJS -Data (
        ConvertFrom-JSON '$((ConvertTo-Json -Compress -InputObject $chartInfo.ChartData) -replace "'","''")'
    ) -Type $chartType -Id $chartHTMLID -DataProperty '$($secondProp.Name)' -LabelProperty '$($firstProp.Name)'"
}