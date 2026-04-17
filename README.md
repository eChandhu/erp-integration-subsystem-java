# ERP Integration Subsystem 

This workspace contains a MySQL-ready OOAD Integration subsystem SDK plus the local database setup files.

## Main files

- Main runnable class:
  [IntegrationDemoMain.java]
- Main subsystem class:
  [Integration.java]
- Generic CRUD/security layer:
  [AbstractSubsystem.java]
- Schema:
  [sql/01-schema.sql]
- Config template:
  [src/main/resources/application-example.properties]
- Built JAR:
  [target/erp-subsystem-sdk-1.0.0.jar]

## Architecture

- `subsystem`: subsystem facade classes such as `Integration`, `CRM`, `Manufacturing`
- `security`: permission lookup and access denial
- `db`: HikariCP connection pooling
- `logging`: audit trail for success and failure
- `backup`: admin-only backup and restore adapter
- `sql`: SQL builders and join request model

## Patterns used

- Creational: `SubsystemFactory`
- Structural: Facade via subsystem classes, Adapter via `MySqlBackupAdapter`
- Behavioral: command-style execution flow inside `AbstractSubsystem.execute(...)`

## Setup

### 1. Build the project

Run:

```powershell
mvn package
```

Expected output at the end:

```text
[INFO] BUILD SUCCESS
```

### 2. Start local MySQL with Docker

Start Docker Desktop first, then run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup-local-db.ps1
```

Expected output:

```text
Connection: jdbc:mysql://127.0.0.1:3306/erp_subsystem
User: erp_user
```

### 3. Apply the schema manually if needed

If the container does not auto-load the SQL file, run:

```powershell
Get-Content .\sql\01-schema.sql | docker exec -i erp-subsystem-mysql mysql -uroot -proot_password --binary-mode=1 erp_subsystem
```

Expected output:

```text
No error output from MySQL
```

### 4. Check the config file

Default config file used by the demo:

```text
src/main/resources/application-example.properties
```

## Run the Integration subsystem demo

Use PowerShell-safe Maven commands:

```powershell
mvn exec:java "-Dexec.mainClass=com.erp.sdk.IntegrationDemoMain" "-Dexec.args=smoke"
```

If PowerShell still parses badly on your machine:

```powershell
mvn --% exec:java -Dexec.mainClass=com.erp.sdk.IntegrationDemoMain -Dexec.args=smoke
```

## Exact test commands

### Smoke test

Command:

```powershell
mvn exec:java "-Dexec.mainClass=com.erp.sdk.IntegrationDemoMain" "-Dexec.args=smoke"
```

What it checks:

- DB connection works
- `integration_registry` can be read
- `permission_matrix` can be read
- `data_ownership` can be read

Expected output pattern:

```text
Integration subsystem demo started. Mode = smoke
SMOKE CHECK
Registered subsystems: 16
Permission rules loaded: ...
Data ownership entries: ...
Integration subsystem demo completed successfully.
```

### CRUD test

Command:

```powershell
mvn exec:java "-Dexec.mainClass=com.erp.sdk.IntegrationDemoMain" "-Dexec.args=crud"
```

What it checks:

- create on `integration_registry`
- read back the created row
- update the created row
- delete the created row

Expected output pattern:

```text
Integration subsystem demo started. Mode = crud
CRUD CHECK
CREATE OK. Generated key: ...
READ OK. Matching rows: 1
UPDATE OK. Rows updated: 1
DELETE OK. Rows deleted: 1
Integration subsystem demo completed successfully.
```

### Permission test

Command:

```powershell
mvn exec:java "-Dexec.mainClass=com.erp.sdk.IntegrationDemoMain" "-Dexec.args=permission"
```

What it checks:

- tries to access a table not granted to Integration
- confirms that `UnauthorizedResourceAccessException` is raised

Expected output pattern:

```text
Integration subsystem demo started. Mode = permission
PERMISSION CHECK
PERMISSION OK. Exception raised as expected:
Subsystem Integration cannot access table customers.
Integration subsystem demo completed successfully.
```

### Logging test

Command:

```powershell
mvn exec:java "-Dexec.mainClass=com.erp.sdk.IntegrationDemoMain" "-Dexec.args=logging"
```

What it checks:

- reads `audit_logs`
- confirms log rows are present

Expected output pattern:

```text
Integration subsystem demo started. Mode = logging
LOGGING CHECK
Audit log rows available: ...
Most recent accessible log sample: {...}
Integration subsystem demo completed successfully.
```

### Run all checks together

Command:

```powershell
mvn exec:java "-Dexec.mainClass=com.erp.sdk.IntegrationDemoMain" "-Dexec.args=all"
```

Expected output pattern:

```text
Integration subsystem demo started. Mode = all
SMOKE CHECK
...
CRUD CHECK
...
PERMISSION CHECK
...
LOGGING CHECK
...
Integration subsystem demo completed successfully.
```

## Requirement mapping

1. CRUD per subsystem: provided by each subsystem class through inherited CRUD methods.
2. Unauthorized table access exception: `PermissionService` throws `UnauthorizedResourceAccessException`.
3. Backup and restore for admin: `backupDatabase()` and `restoreDatabase()`.
4. Interface class named after subsystem: `Integration`, `CRM`, `Manufacturing`, and so on.
5. Joins handled in code: `join(JoinRequest, username)`.
6. Factory, Adapter, SOLID, GRASP: implemented in the SDK structure.
7. Behavioral, structural, creational patterns: included.
8. MySQL: schema and JDBC driver are MySQL-specific.
9. Connection pool and concurrency: HikariCP.
10. No direct DB access by subsystems: only facade methods are exposed.
11. Separate live DB server: use local Docker for dev and move the same schema to Amazon RDS for deployment.
12. Java class/JAR handoff: `mvn package` produces the shared artifact.
13. Success and failure logging: `audit_logs` table plus `AuditLogger`.

