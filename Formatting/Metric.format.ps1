Write-FormatView -TypeName Metric -Property MetricName, Synopsis, InputProperties -VirtualProperty @{
    InputProperties = { $_.InputProperties -join [Environment]::NewLine } 
}
