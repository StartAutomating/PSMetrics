Metrics/CommandsByNoun.metric.ps1
---------------------------------




### Synopsis
Commands By Noun



---


### Description

Commands by the command's Noun



---


### Examples
#### EXAMPLE 1
```PowerShell
Get-Command -Module PSMetric -CommandType Function | CommandsByNoun
```



---


### Parameters
#### **Noun**




|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|





---


### Syntax
```PowerShell
Metrics/CommandsByNoun.metric.ps1 [[-Noun] <String>] [<CommonParameters>]
```
