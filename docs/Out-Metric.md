Out-Metric
----------




### Synopsis
Outputs Metrics



---


### Description

Outputs Metrics, given a pipeline of input.
This command is often called via a smart alias.
Each metric imported by Import-Metric will create several aliases to this command.



---


### Related Links
* [Import-Metric](Import-Metric.md)



* [Get-Metric](Get-Metric.md)





---


### Parameters
#### **InputObject**

A Pipeline of InputObjects
This should be provided from the object pipeline.






|Type      |Required|Position|PipelineInput |
|----------|--------|--------|--------------|
|`[Object]`|false   |named   |true (ByValue)|



#### **OutputPath**

The output path.  If provided will output the metric to this path.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |



#### **Arguments**

Any remaining arguments.  This parameter is here to provide open-ended input and customization.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |named   |false        |



#### **View**

The name of the view to use.
Different views can make metrics render different ways.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |





---


### Syntax
```PowerShell
Out-Metric [-InputObject <Object>] [-OutputPath <String>] [-Arguments <Object>] [-View <String>] [<CommonParameters>]
```