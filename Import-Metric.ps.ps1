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
    # The source location of the metrics.
    # This can be a string, file, directory, command, or module.
    [vfp(vbn,Mandatory)]
    [Alias(        
        'FromPath',
        'FromModule',
        'FromScript',
        'FromFunction',
        'FullName',
        'Path',
        'Source'
    )]    
    [ValidateTypes(TypeName={
        [string],
        [IO.FileInfo],
        [IO.DirectoryInfo]
        [Management.Automation.CommandInfo]
        [Management.Automation.PSModuleInfo]
    })]
    $From
    )

    begin {        
        if (-not $script:ChartMetrics) {
            $script:ChartMetrics = [Ordered]@{}
        }

        $newMetrics = @()
        $MetricPattern = '@/
        (?>
            ^Metric\p{P}
            |
            [\p{P}-[-]]Metric$
            |
            \p{P}Metric\.ps1
        )
        /@'
    }

    process {
        # Since -From can be many things, but a metric has to be a command,
        # the purpose of this function is to essentially resolve many things to a command, 
        # and then cache that command.

        # If -From was a string
        if ($From -is [string]) {
            # It could be a module, so check those first.            
            :ResolveFromString do {
                foreach ($loadedModule in @(Get-Module)) {
                    # If we find the module, don't try to resolve -From as a path
                    break ResolveFromString
                        if ($loadedModule.Name -eq $from) {
                            $from = $fromModule = $loadedModule # (just set -From again and let the function continue)
                        }
                }
                # If we think from was a path
                $resolvedPath = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($from)
                # attempt to resolve it
                if ($resolvedPath) {
                    $from = Get-Item -LiteralPath $resolvedPath
                }
            } while ($false)
        }

        # If -From is a module
        if ($from -is [Management.Automation.PSModuleInfo]) {
            # recursively call ourselves with all matching commands
            @($from.ExportedCommands.Values) -match $MetricPattern |
                Import-Metric
            # then, make -From a directory
            if ($from.Path) {
                $from = Get-Item ($from.Path | Split-Path) -ErrorAction SilentlyContinue
            }
        }
        
        # If -From is a directory
        if ($from -is [IO.DirectoryInfo]) {
            $FromDirectory = $from
            # recursively call ourselves with all matching scripts
            Get-ChildItem -LiteralPath $from.FullName -Recurse -File | 
                Where-Object Name -match '\.metric.ps1$' |
                Import-Metric
            return
        }

        # If -From is a file
        if ($from -is [IO.FileInfo]) {
            # and it matches the naming convention
            return if $from.Name -notmatch '\.metric\.ps1$'
            # make -From a command.
            $from = $ExecutionContext.SessionState.InvokeCommand.GetCommand($from.FullName, 'ExternalScript')
        }

        # If -From is a command
        if ($from -is [Management.Automation.CommandInfo]) {
            # decorate the command
            if ($from.pstypenames -notcontains 'Metric') {
                $from.pstypenames.insert(0,'Metric')                
            }
            
            # and add it to our list of new metrics
            $newMetrics+= $from
            $script:ChartMetrics[$from.Name -replace '\.metric\.ps1$'] = $from
            $from
        }                
    }

    end {
        # If there were no metrics to add, we're done.

        return if -not $newMetrics

        $AliasedTo = 'Out-Metric'
        # Otherwise, create many aliases for each metric
        $createAliases = 
        @(foreach ($newMetric in $newMetrics) {
            $metricSafeName = $newMetric -replace '\.metric\.ps1$'
            "Set-Alias $metricSafeName $AliasedTo"
            "Set-Alias $metricSafeName📈 $AliasedTo"
            "Set-Alias $metricSafeName📉 $AliasedTo"
            "Set-Alias $metricSafeName📊 $AliasedTo"            
            "Set-Alias $metricSafeName◕ $AliasedTo"
            "Set-Alias $metricSafeName◔ $AliasedTo"
            "Set-Alias $metricSafeName∑ $AliasedTo"           
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
