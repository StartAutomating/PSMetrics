Get-Metric
----------




### Synopsis
Gets Metrics



---


### Description

Gets loaded Metrics.

Metrics are defined in *.metric.ps1 files, and imported with Import-Metric



---


### Related Links
* [Import-Metric](Import-Metric.md)





---


### Examples
#### EXAMPLE 1
```PowerShell
Get-Metric
```



---


### Parameters
#### **MetricName**

The name of the metric.






|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |1       |true (ByPropertyName)|Metric |





---


### Syntax
```PowerShell
Get-Metric [[-MetricName] <String>] [<CommonParameters>]
```
