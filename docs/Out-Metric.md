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



#### **Descending**

If set, will flip the order of any outputted metric data.
Metrics should output their data sorted by default, and thus, this should make any metric sorted the opposite of a default order.






|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|false   |named   |false        |Reverse|



#### **ChartType**

If provided, will render a chart of a particular type.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |



#### **BackgroundColor**

The background colors for the chart






|Type        |Required|Position|PipelineInput|Aliases                   |
|------------|--------|--------|-------------|--------------------------|
|`[String[]]`|false   |named   |false        |Color<br/>BackgroundColors|



#### **BorderColor**

The border colors for the chart






|Type        |Required|Position|PipelineInput|Aliases     |
|------------|--------|--------|-------------|------------|
|`[String[]]`|false   |named   |false        |BorderColors|



#### **Metadata**

Any metadata related to the metric.
This will add a YAML header to HTML metrics






|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |named   |false        |



#### **IncludeTotalCount**




|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



#### **Skip**




|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[UInt64]`|false   |named   |false        |



#### **First**




|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[UInt64]`|false   |named   |false        |





---


### Syntax
```PowerShell
Out-Metric [-InputObject <Object>] [-OutputPath <String>] [-Arguments <Object>] [-View <String>] [-Descending] [-ChartType <String>] [-BackgroundColor <String[]>] [-BorderColor <String[]>] [-Metadata <IDictionary>] [-IncludeTotalCount] [-Skip <UInt64>] [-First <UInt64>] [<CommonParameters>]
```
