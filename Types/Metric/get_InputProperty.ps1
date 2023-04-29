$cmd = $this
@(foreach ($parameterInfo in ([Management.Automation.CommandMetadata]$cmd).Parameters.Values) {
    if ($parameterInfo.Attributes.ValueFromPipelineByPropertyName) {
        $parameterInfo.Name        
    }
})
