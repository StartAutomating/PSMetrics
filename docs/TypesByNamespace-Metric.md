Metrics/TypesByNamespace.metric.ps1
-----------------------------------




### Synopsis
Gets types by namespace



---


### Description

Gets the number of types in each namespace.



---


### Related Links
* [Import-Metric](Import-Metric.md)





---


### Examples
#### EXAMPLE 1
```PowerShell
[PSObject].Assembly.GetTypes() | TypesByNamespace -First 10
```

#### EXAMPLE 2
```PowerShell
[PSObject].Assembly.GetTypes() | ? IsPublic | TypesByNamespace -First 10
```



---


### Parameters
#### **Namespace**




|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|





---


### Syntax
```PowerShell
Metrics/TypesByNamespace.metric.ps1 [[-Namespace] <String>] [<CommonParameters>]
```
