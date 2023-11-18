#Requires -Modules Pester

$PesterConfig = New-PesterConfiguration
$PesterConfig.Run.Path = ".\Tests"
$PesterConfig.TestResult.Enabled = $true
$PesterConfig.TestResult.OutputFile = ".\Tests\TestResults.xml"
$PesterConfig.TestResult.OutputFormat = "NUnitXml"

Invoke-Pester -Configuration $PesterConfig
