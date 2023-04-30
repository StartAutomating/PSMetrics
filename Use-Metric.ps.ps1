function Use-Metric {
    [CmdletBinding(PositionalBinding=$false)]
    param(
    [vfp()]
    $InputObject,

    [Parameter(Position=0)]
    [string]
    $OutputPath,

    [Parameter(ValueFromRemainingArguments)]
    $Arguments
    )


    dynamicParam {
        $suffixes = "(?>∑|📈|📉|📊|◕|◔|Chart|Metric|PSMetric)"
        $metricMatcher = "(?<MetricName>(?:.|\s){0,}?(?=\z|\s|$suffixes))(?<Suffix>$suffixes)?"
        return if $MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Name
        return if $myInvocation.InvocationName -notmatch $metricMatcher
        $metricMatch = @{} + $matches
        $MetricCommand = Get-Metric $metricMatch.MetricName
        return if -not $MetricCommand

        $Intention = 
            if ($metricMatch.Suffix -eq "∑") {
                'Metric'
            } elseif ($metricMatch.Suffix -eq '📈') {
                'LineAscending'
            } elseif ($metricMatch.Suffix -eq '📉') {
                'LineDescending'
            } elseif ($metricMatch.Suffix -eq "📊") {
                'BarChart'
            } 
            elseif ($metricMatch.Suffix -eq '◕') {
                'PieAscending'
            }
            elseif ($metricMatch.Suffix -eq '◔') {
                'PieDescending'
            }
            elseif ($metricMatch.Suffix -like '*Chart*') {
                'Chart'
            } elseif ($metricMatch.Suffix -like '*Metric*') {
                'Metric'
            }
    }

    begin {
        $accumulateInput = [Collections.Queue]::new()
    }

    process {
        if ($InputObject) {
            $accumulateInput.Enqueue($InputObject)
        }        
    }

    end {
        return if -not $MetricCommand
        $metricOutput = @($accumulateInput.ToArray() | & $MetricCommand)
        $commandOutput = 
            if ($Intention -eq 'Metric') {
                $metricOutput
            } else {
                if ($Intention -like '*Descending*') {
                    [Array]::Reverse($metricOutput)
                }
                
                [PSCustomObject][Ordered]@{
                    PSTypeName     = 'Chart'
                    ChartData      = $metricOutput
                    ChartType      = if ($Intention -match 'Line') {
                        'line'
                    } elseif ($Intention -match 'Bar') {
                        'bar'
                    } elseif ($Intention -match 'Pie') {
                        'pie'
                    } else {
                        ''
                    }
                    MetricCommand  = $MetricCommand
                    MetricName     = $MetricCommand.Name -replace '\.metric\.ps1$'
                } |
                Out-String -Width 1mb
            }

        if ($OutputPath) {            
            $exporter = $ExecutionContext.SessionState.InvokeCommand.GetCommand(
                "Export-$(@($OutputPath -split '\.')[-1])",
                'Function,Alias,Cmdlet'
            )
            if ($exporter) {
                $metricOutput | & $exporter $OutputPath
            } else {
                $metricOutput | Set-Content $OutputPath
            }

            if (Test-Path $OutputPath) {
                Get-Item $OutputPath
            }
            
        } else {
            if (-not $Intention) {
                $metricOutput
            } else {
                $commandOutput
            }
            
        }
    }
}
