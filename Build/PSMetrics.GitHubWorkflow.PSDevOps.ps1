#requires -Module PSDevOps
#requires -Module PSMetrics
Import-BuildStep -ModuleName PSMetrics
Push-Location ($PSScriptRoot | Split-Path)
New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis,
    TestPowerShellOnLinux,
    TagReleaseAndPublish,
    BuildPSMetrics -OutputPath .\.github\workflows\TestReleaseAndPublish.yml
Pop-Location