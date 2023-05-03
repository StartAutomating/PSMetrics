#requires -Module PSSVG


Push-Location ($psScriptRoot | Split-Path)
$psChevron = Invoke-RestMethod https://pssvg.start-automating.com/Examples/PowerShellChevron.svg

$assetsPath = Join-Path $psScriptRoot Assets
if (-not (Test-Path $assetsPath)) {
    $null = New-Item -ItemType Directory -Path $assetsPath
}

$fontName = 'Montserrat'
svg -ViewBox 1920,1080 @(    
    svg.defs @(
        SVG.GoogleFont -FontName $fontName
    )
    $psChevron.svg.symbol
 
    SVG.text -Content "PSMetrics" -Style "font-family: '$FontName', sans-serif" -X 50% -Y 50% -TextAnchor 'middle' -AlignmentBaseline 'middle' -DominantBaseline 'middle' -FontSize 15em -Fill '#4488ff' -Class 'foreground-fill'
    SVG.use -Href '#psChevron' -Fill '#4488ff' -Height 7.5% -X -26.5% -Y 42%
) -OutputPath (Join-Path $assetsPath "PSMetrics.svg")
Pop-Location