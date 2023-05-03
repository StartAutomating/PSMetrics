describe PSMetrics {
    it 'Makes it easy to describe metrics' {
        Get-Metric
    }

    it 'Can get a metric by name' {
        Get-Metric -MetricName FilesByExtension
    }

    it 'Can calculate metrics' {
        Get-Module PSMetrics | 
            Split-Path | 
            Get-ChildItem -File -Recurse |
            FilesByExtension |
            Select-Object -First 1 -ExpandProperty Extension |
            Should -Be .ps1
    }

    context 'Graphs' {
        it 'Can show a metric as a 📈 graph' {
            Get-Module PSMetrics | 
                Split-Path | 
                Get-ChildItem -File -Recurse |
                FilesByExtension📈 |
                Should -BeLike '*<*>*line*'
        }

        it 'Can show a metric as a 📊 graph' {
            Get-Module PSMetrics | 
                Split-Path | 
                Get-ChildItem -File -Recurse |
                FilesByExtension📊 |
                Should -BeLike '*<*>*bar*'
        }
        
        it 'Can show a metric as a ◔ graph' {
            Get-Module PSMetrics |
                Split-Path |
                Get-ChildItem -File -Recurse |
                FilesByExtension◔ |
                Should -BeLike '*<*>*pie*'

        }        
    }        
}
