param(
    [string]$ComposeFile = "docker-compose.yml"
)

docker compose -f $ComposeFile up -d
Write-Host "If this is the first startup, MySQL will initialize and load sql/01-schema.sql automatically."
Write-Host "Connection: jdbc:mysql://127.0.0.1:3307/erp_subsystem"
Write-Host "User: erp_user"
Write-Host "If Docker already had an older volume, run scripts\\reload-schema.ps1 to force a fresh schema load."
