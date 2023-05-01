#requires -Module PSMetrics

$psMetricsFiles = Get-Module PSMetrics |
    Split-Path |
    Get-ChildItem -File

$psMetricsFunctions = 
    Get-Command -Module PSMetrics -CommandType Function

$docsRoot  = Join-Path $env:GITHUB_WORKSPACE "docs"


$psMetricsFiles | FilesByExtension◔ -OutputPath (
    Join-Path $docsRoot "PSMetrics-FilesByExtension.html"
)

$psMetricsFiles | FileSizeByExtension◔ -OutputPath (
    Join-Path $docsRoot "PSMetrics-FileSizeByExtension.html"
)

$psMetricsFunctions | CommandsByVerb◔ -OutputPath (
    Join-Path $docsRoot "PSMetrics-CommandsByVerb.html"
)
