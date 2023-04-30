Import-Metric
-------------




### Synopsis
Imports Metrics that could be charted



---


### Description

Imports Metrics that could be charted.
A metric is a script that generates a series of data from pipelined input.



---


### Related Links
* [Get-Metric](Get-Metric.md)





---


### Examples
#### EXAMPLE 1
```PowerShell
Import-Metric -Path (Get-Module PSMetrics)
```



---


### Parameters
#### **From**




|Type      |Required|Position|PipelineInput                 |Aliases                                                                        |
|----------|--------|--------|------------------------------|-------------------------------------------------------------------------------|
|`[Object]`|true    |1       |true (ByValue, ByPropertyName)|FromPath<br/>FromModule<br/>FromScript<br/>FromFunction<br/>FullName<br/>Source|





---


### Syntax
```PowerShell
Import-Metric [-From] <Object> [<CommonParameters>]
```
