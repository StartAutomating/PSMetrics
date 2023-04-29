#requires -Module HelpOut
Push-Location $PSScriptRoot

Import-Module .\PSMetrics.psd1

Save-MarkdownHelp -Module PSMetrics -ScriptPath Metrics -ReplaceScriptName '\.metric\.ps1$' -ReplaceScriptNameWith "-Metric" -PassThru

Pop-Location