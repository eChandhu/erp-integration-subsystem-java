param(
    [string]$ContainerName = "erp-subsystem-mysql",
    [string]$Database = "erp_subsystem",
    [string]$RootPassword = "root_password",
    [string]$SchemaFile = ".\sql\01-schema.sql"
)

if (-not (Test-Path $SchemaFile)) {
    throw "Schema file not found: $SchemaFile"
}

Get-Content $SchemaFile | docker exec -i $ContainerName mysql -uroot -p$RootPassword --binary-mode=1 $Database
Write-Host "Schema reloaded into $Database on container $ContainerName."
