#requires -Module HelpOut
Push-Location $PSScriptRoot

Import-Module .\PSMetrics.psd1

Save-MarkdownHelp -Module PSMetrics -ScriptPath '\.metric\.ps1$' -ReplaceScriptName '\.metric\.ps1$' -ReplaceScriptNameWith "-Metric" -PassThru -CommandType Function,ExternalScript -SkipCommandType alias

Pop-Location