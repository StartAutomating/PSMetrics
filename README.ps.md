<div align='center'>
<img src='Assets/PSMetrics.png' alt='PSMetrics' />
</div>


PSMetrics is a module for metrics in PowerShell.

It lets us describe a metric in a simple script, named `*.metric.ps1`.

Once we've described a metric, it's easy to calculate it from any appropriate input.

Once we've calculated a metric, it's easy to format that metric any way we'd like.

PSMetrics includes formatters for ChartJS and PowerShell Universal.

## Using PSMetrics

You import metrics with Import-Metric.  Once you have done this, you can use the metric a number of different ways.

~~~PowerShell
# You can run the metric directly and get back it's data
Get-ChildItem -File -Recurse | FileSizeByExtension

# You can run the metric with an emoji alias to render it as a graph 
Get-ChildItem -File -Recurse | FileSizeByExtension📊

# You can provide an -OutputPath to export the HTML
Get-ChildItem -File -Recurse | FileSizeByExtension📊 -OutputPath .\FileSizeByExtension.html

# You can provide an -OutputPath that is a CSV or CLIXML to export the data
Get-ChildItem -File -Recurse | FileSizeByExtension📊 -OutputPath .\FileSizeByExtension.Clixml
~~~

## PSMetrics Action

You can use PSMetrics in a GitHub action.  Simply create a `*.psmetrics.ps1` file and use the github action in your YAML.

~~~yaml
- name: UsePSMetrics
  uses: StartAutomating/PSMetrics@main
~~~

Any files you output from the action will be checked into your repo (please make sure your github access token allows you to write to the repository)

## Example Metrics

PSMetrics comes with a few example metrics you can use out of the box.

~~~PipeScript {
    Import-Module .\PSMetrics.psd1 -Global
    [PSCustomObject]@{
        Table = Get-Metric | Select MetricName, Synopsis
    }
}
~~~

## Tools that use PSMetrics

[GitLogger](https://gitlogger.com/GitLogger-Metrics/) uses PSMetrics to standardize the data you can visualize from a repository.