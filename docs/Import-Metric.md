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

The source location of the metrics.
This can be a string, file, directory, command, or module.






|Type      |Required|Position|PipelineInput                 |Aliases                                                                                 |
|----------|--------|--------|------------------------------|----------------------------------------------------------------------------------------|
|`[Object]`|true    |1       |true (ByValue, ByPropertyName)|FromPath<br/>FromModule<br/>FromScript<br/>FromFunction<br/>FullName<br/>Path<br/>Source|





---


### Syntax
```PowerShell
Import-Metric [-From] <Object> [<CommonParameters>]
```
