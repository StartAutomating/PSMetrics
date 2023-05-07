#requires -Module PSMetrics

$psMetricsFiles = Get-Module PSMetrics |
    Split-Path |
    Get-ChildItem -File -Recurse

$psMetricsFunctions = 
    Get-Command -Module PSMetrics -CommandType Function

$docsRoot  = Join-Path $env:GITHUB_WORKSPACE "docs"


$psMetricsFiles | FilesByExtension◔ -OutputPath (
    Join-Path $docsRoot "PSMetrics-FilesByExtension.html"
)

$psMetricsFiles | FileSizeByExtension📊 -OutputPath (
    Join-Path $docsRoot "PSMetrics-FileSizeByExtension.html"
)

$psMetricsFunctions | CommandsByVerb◔ -OutputPath (
    Join-Path $docsRoot "PSMetrics-CommandsByVerb.html"
)

$psMetricsFunctions | CommandsByNoun◔ -OutputPath (
    Join-Path $docsRoot "PSMetrics-CommandsByNoun.html"
)


[PSObject].Assembly.GetTypes() | 
    Where-Object IsPublic | 
    TypesByNamespace📊 -OutputPath (
        Join-Path $docsRoot "PowerShell-Types-By-Namespace.html"
    )