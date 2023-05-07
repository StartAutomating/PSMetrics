#requires -Module PSDevOps
#requires -Module PSMetrics
Import-BuildStep -ModuleName PSMetrics
Push-Location ($PSScriptRoot | Split-Path)
New-GitHubAction -Name "MeasureMetrics" -Description @'
Measure Metrics and Create Charts with PSMetrics
'@ -Action PSMetricsAction -Icon pie-chart -OutputPath .\action.yml
Pop-Location