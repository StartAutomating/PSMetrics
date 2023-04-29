function Get-Metric {
    <#
    .SYNOPSIS
        Gets Metrics
    .DESCRIPTION
        Gets loaded Metrics.
        
        Metrics are defined in *.metric.ps1 files, and imported with Import-Metric
    .EXAMPLE
        Get-Metric
    .LINK
        Import-Metric        
    #>
    param(
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Metric')]
    [string]
    $MetricName
    )
    begin {
        if (-not $script:ChartMetrics) {
            $script:ChartMetrics = [Ordered]@{}
        }
    }
    process {
        if ($MetricName) {
            if ($script:ChartMetrics[$MetricName]) {
                $script:ChartMetrics[$MetricName]
            } else {
                :LookForMetric foreach ($metricInfo in $script:ChartMetrics.Values) {
                    if (($metricInfo.Name -replace '\.metric\.ps1$') -eq $MetricName) { 
                                $metricInfo;break LookForMetric                        
                            } 
                }
            }
        } else {
            $script:ChartMetrics.Values | Sort-Object Rank, Name
        }
    }
}

