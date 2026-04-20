param(
    [string]$Mode = "all",
    [string]$ConfigPath = "src/main/resources/application-example.properties"
)

$jars = Get-ChildItem -Recurse .m2\repository -Filter *.jar |
    Where-Object { $_.Name -notlike 'slf4j-api-1.7.*.jar' } |
    ForEach-Object { $_.FullName }
$classpath = @("target\classes") + $jars
java -cp ($classpath -join ';') com.erp.sdk.IntegrationDemoMain $Mode $ConfigPath
