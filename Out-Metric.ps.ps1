function Out-Metric {
    <#
    .SYNOPSIS
        Outputs Metrics
    .DESCRIPTION
        Outputs Metrics, given a pipeline of input.

        This command is often called via a smart alias.

        Each metric imported by Import-Metric will create several aliases to this command.
    .LINK
        Import-Metric
    .LINK
        Get-Metric
    #>
    [CmdletBinding(PositionalBinding=$false,SupportsPaging)]
    param(
    # A Pipeline of InputObjects
    # This should be provided from the object pipeline.
    [vfp()]
    $InputObject,

    # The output path.  If provided will output the metric to this path.    
    [string]
    $OutputPath,

    # Any remaining arguments.  This parameter is here to provide open-ended input and customization.
    [Parameter(ValueFromRemainingArguments)]
    $Arguments,

    # The name of the view to use.
    # Different views can make metrics render different ways.
    [string]
    $View,

    # If set, will flip the order of any outputted metric data.
    # Metrics should output their data sorted by default, and thus, this should make any metric sorted the opposite of a default order.
    [Alias('Reverse')]
    [switch]
    $Descending,

    # If provided, will render a chart of a particular type.
    [string]
    $ChartType,

    # The background colors for the chart
    [Alias('Color','BackgroundColors')]
    [string[]]
    $BackgroundColor,

    # The border colors for the chart
    [Alias('BorderColors')]
    [string[]]
    $BorderColor,

    # Any metadata related to the metric.
    # This will add a YAML header to HTML metrics
    [Collections.IDictionary]
    $Metadata = [Ordered]@{}
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
            elseif ($metricMatch.Suffix -eq '◔') {
                'PieAscending'
            }
            elseif ($metricMatch.Suffix -eq '◕') {
                'PieDescending'
            }            
            elseif ($metricMatch.Suffix -like '*Chart*') {
                'Chart'
            } elseif ($metricMatch.Suffix -like '*Metric*') {
                'Metric'
            }
    }

    begin {
        # Prepare to accumulate pipeline input.
        $accumulateInput = [Collections.Queue]::new()
    }

    process {
        # Accummulate what is piped in.        
        if ($InputObject) {
            $accumulateInput.Enqueue($InputObject)
        }        
    }

    end {
        # If there was no metric command, return.
        return if -not $MetricCommand

        # Pipe to our metric.  If this fails, let the errors bubble up.
        $metricOutput     = @($accumulateInput.ToArray() | & $MetricCommand)
        $formatParameters = @{}
        if ($view) {
            $formatParameters["View"] = $view
        } else {
            if ($PSUEnvironment) {
                $formatParameters["View"] = $view = 'PowerShellUniversal'
            }
        }
        $ViewOutput   =
            if ($Intention -eq 'Metric' -and -not $view -and -not $ChartType) {
                $metricOutput
            } else {
                if ($Intention -like '*Descending*' -or $Descending) {
                    [Array]::Reverse($metricOutput)
                }

                if ($PSBoundParameters['Skip']) {
                    $metricOutput = $metricOutput[(0+$PSBoundParameters['Skip'])..($metricOutput.Length - 1)]
                }

                if ($PSBoundParameters['First']) {
                    if ($PSBoundParameters['First'] -gt 0) {
                        $metricOutput = $metricOutput[0..$($PSBoundParameters['First'] -1)]
                    } else {
                        $metricOutput = $metricOutput[$PSBoundParameters['First']]
                    }
                    
                }
                
                [PSCustomObject][Ordered]@{
                    PSTypeName      = 'Chart'
                    ChartData       = $metricOutput
                    ChartType       =   if ($chartType) {
                                            $chartType
                                        } elseif ($Intention -match 'Line') {
                                            'line'
                                        } elseif ($Intention -match 'Bar') {
                                            'bar'
                                        } elseif ($Intention -match 'Pie') {
                                            'pie'
                                        } else {
                                            ''
                                        }
                    MetricCommand   = $MetricCommand
                    MetricName      = $MetricCommand.MetricName
                    BackgroundColor = $BackgroundColor
                    BorderColor     = $BorderColor
                    Metadata        = $Metadata
                } |
                Format-Custom @formatParameters |
                Out-String -Width 1mb
            }

        # If an -OutputPath was provided
        if ($OutputPath) {            
            # try to find an exporter
            $exporter = $ExecutionContext.SessionState.InvokeCommand.GetCommand(
                # (by looking for any Export-Command that shares a name with the extension)
                "Export-$(@($OutputPath -split '\.')[-1])",
                'Function,Alias,Cmdlet'
            )

            # If an exporter was found
            if ($exporter) {
                # we can export the data by piping to the exporter
                $metricOutput | 
                    & $exporter $OutputPath
            } else {
                # Otherwise, we can use set-content to output the view.
                $ViewOutput | Set-Content $OutputPath
            }

            # If -OutputPath existed
            if (Test-Path $OutputPath) {
                Get-Item $OutputPath # output the file
            }
            
        } else {
            # If no intention can be inferred
            if (-not $Intention) {
                $metricOutput # output the data
            } else {
                # otherwise, output the view
                if ($ViewOutput -match '^\s{0,}\{' -and 
                    $ViewOutput -match '\}\s{0,}$') {
                    try {
                        ConvertFrom-Json -InputObject $ViewOutput
                    } catch {
                        try {
                            & (
                                [scriptblock]::Create(
                                    $ViewOutput -replace '^\s{0,}\{' -replace '\}\s{0,}$'
                                )
                            )
                        } catch {
                            $ViewOutput
                        }
                    }
                } else {
                    $ViewOutput
                }
                
            }            
        }
    }
}
