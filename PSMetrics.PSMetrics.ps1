#requires -Module PSMetrics

$psMetricsFiles = Get-Module PSMetrics |
    Split-Path |
    Get-ChildItem -File

$psMetricsCommands = 
    Get-Command -Module PSMetrics -CommandType All

$docsRoot  = Join-Path $env:GITHUB_WORKSPACE "docs"


$psMetricsFiles | FilesByExtension◔ -OutputPath (
    Join-Path $docsRoot "PSMetrics-FilesByExtension.html"
)

$psMetricsCommands | CommandsByVerb◔ -OutputPath (
    Join-Path $docsRoot "PSMetrics-CommandsByVerb.html"
)
