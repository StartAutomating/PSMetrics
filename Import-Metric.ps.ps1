function Import-Metric
{
    <#
    .SYNOPSIS
        Imports Metrics that could be charted
    .DESCRIPTION
        Imports Metrics that could be charted.

        A metric is a script that generates a series of data from pipelined input.        
    .EXAMPLE
        Import-Metric -Path (Get-Module PSMetrics)
    .LINK
        Get-Metric
    #>
    param(
    [vfp(vbn,Mandatory)]
    [Alias('FromPath','FromModule','FromScript','FromFunction','FullName','Source')]
    [ValidateTypes(TypeName={
        [string],
        [IO.FileInfo],
        [IO.DirectoryInfo]
        [Management.Automation.CommandInfo]
    })]
    $From
    )

    begin {
        if (-not $script:ChartMetrics) {
            $script:ChartMetrics = [Ordered]@{}
        }

        $newMetrics = @()
    }

    process {
        
        if ($From -is [string]) {            
            :ResolveFromString do {
                foreach ($loadedModule in @(Get-Module)) {
                    break ResolveFromString
                        if ($loadedModule.Name -eq $from -and $loadedModule.Path) {
                            $fromModule = $from                            
                            $from = Get-Item -LiteralPath ($loadedModule | Split-Path) -ErrorAction Ignore
                        }
                }
                $resolvedPath = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($from)
                if ($resolvedPath) {
                    $from = Get-Item -LiteralPath $resolvedPath
                }
            } while ($false)
        }
        
        if ($from -is [IO.DirectoryInfo]) {
            $FromDirectory = $from
            Get-ChildItem -LiteralPath $from.FullName -Recurse -File | 
                Where-Object Name -match '\.metric.ps1$' |
                Import-Metric
            return
        }
        if ($from -is [IO.FileInfo]) {
            return if $from.Name -notmatch '\.metric\.ps1$'            
            $from = $ExecutionContext.SessionState.InvokeCommand.GetCommand($from.FullName, 'ExternalScript')
        }

        if ($from -is [Management.Automation.CommandInfo]) {
            if ($from.pstypenames -notcontains 'Metric') {
                $from.pstypenames.insert(0,'Metric')                
            }
            
            $newMetrics+= $from
            $script:ChartMetrics[$from.Name -replace '\.metric\.ps1$'] = $from

            $from
        }                
    }

    end {
        $createAliases = 
        @(foreach ($newMetric in $newMetrics) {
            $metricSafeName = $newMetric -replace '\.metric\.ps1$'
            "Set-Alias $metricSafeName📈 Use-Metric"
            "Set-Alias $metricSafeName📉 Use-Metric"
            "Set-Alias $metricSafeName📊 Use-Metric"            
            "Set-Alias $metricSafeName◕ Use-Metric"
            "Set-Alias $metricSafeName◔ Use-Metric"
            "Set-Alias $metricSafeName∑ Use-Metric"
            "Set-Alias Chart.$metricSafeName Use-Metric"
            "Set-Alias Metric.$metricSafeName Use-Metric"            
        }
        "Export-ModuleMember -Alias *"
        ) -join [Environment]::NewLine

        $TempModuleName = 
            if ($FromModule) {
                "$FromModule.Metrics"
            } elseif ($FromDirectory) {
                "$($FromDirectory.Name)Metrics"
            } else {
                "${metricSafeName}Metrics"
            }

        New-Module -Name $TempModuleName -ScriptBlock ([scriptblock]::Create($createAliases)) | 
            Import-Module -Global -Force
    }
}
