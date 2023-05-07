@{
    ModuleVersion     = '0.1.1'
    Guid              = '8577cd1c-bcae-43ac-a8ac-ba0090b24d3f'
    RootModule        = 'PSMetrics.psm1'
    TypesToProcess    = 'PSMetrics.types.ps1xml'
    FormatsToProcess  = 'PSMetrics.format.ps1xml'
    Description       = 'A Module for Metrics in PowerShell'
    CompanyName       = 'Start-Automating'
    Copyright         = '2023 Start-Automating'
    Author            = 'James Brundage'
    PrivateData       = @{
        PSData          = @{
            ProjectURI = 'https://github.com/StartAutomating/PSMetrics'
            LicenseURI = 'https://github.com/StartAutomating/PSMetrics/blob/main/LICENSE'
            ReleaseNotes = @'
## PSMetrics 0.1.1

* New Metric : Types By Namespace (#26)
* Out-Metric
  * Now supports paging (#27)
  * Now supports -BackgroundColor/-BorderColor (#20)
  * Runs Script Block Views (#23)
  * Defaults to PowerShell Universal in PowerShell Universal (#25 #24)
* GitHub Page now available [https://psmetrics.start-automating.com](https://psmetrics.start-automating.com)
* Fixing GitHub Action Name (#22)

---

## PSMetrics 0.1

* Initial Release of PSMetrics (#1 #2 #7 #8)
* Get-Metric gets metrics (#4)
* Import-Metric imports metrics (#3)
* Out-Metric renders metrics (#5)
* Built-in metrics:
  * CommandsByNoun (#15)
  * CommandsByVerb (#12)
  * FileSizeByExtension (#10)
  * FilesByExtension (#9)
  * PipeScript Factor (#18)
'@
        }
    }
}

