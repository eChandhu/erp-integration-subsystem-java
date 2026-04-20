# Database Integration Subsystem 

This folder is a clean, submission-ready version of the Database Integration subsystem. It is designed to satisfy the OOAD requirements using Java, MySQL, JDBC, HikariCP connection pooling, permission-controlled CRUD access, audit logging, backup/restore, and subsystem-specific facade classes that other teams can compile against.

## What This Delivers

- A live MySQL-ready canonical schema in `sql/01-schema.sql`
- A Java SDK/JAR that other teams can compile with
- Subsystem facade classes named after each subsystem such as `Integration`, `CRM`, `UI`, `HR`, `Manufacturing`, and `SupplyChain`
- Access control enforcement through `permission_matrix`
- Audit logging for success and failure
- Connection pooling using HikariCP for concurrent access
- Admin-only backup and restore
- Compatibility views so teams with slightly different table names can still work against the shared schema
- Full execution notes, requirement mapping, and work tracking

## Project Structure

- `src/main/java/com/erp/sdk`: Java SDK
- `sql/01-schema.sql`: canonical schema, seed data, compatibility views
- `sql/02-verification.sql`: post-setup verification queries
- `scripts/setup-local-db.ps1`: starts local MySQL through Docker
- `scripts/reload-schema.ps1`: reloads schema into the running container
- `scripts/run-demo-checks.ps1`: runs demo modes
- `docs/ARCHITECTURE.md`: architecture and pattern explanation
- `docs/DEPLOYED_DATABASE_USAGE.md`: how other subsystems should use the deployed live database
- `docs/REQUIREMENT_MAPPING.md`: traceability from requirement to implementation
- `docs/TEAM_DATA_ANALYSIS.md`: what was read from team SQL/files and how it was used
- `WORK_DONE_AND_REMAINING.txt`: clear done/remaining tracker

## Architecture

Layered design:

1. `subsystem`
   Facade layer. Other teams use classes like `Integration`, `CRM`, `UI`, `SalesManagement`, and so on.
2. `security`
   Permission lookup and enforcement. Unauthorized access raises exceptions.
3. `db`
   Pooled JDBC connection management with HikariCP.
4. `logging`
   Audit trail insertion into `audit_logs`.
5. `backup`
   Adapter that wraps MySQL backup and restore commands.
6. `sql`
   Safe SQL generation and join request modeling.

## Design Patterns Used

- Creational: `SubsystemFactory`
- Structural: subsystem facades, `MySqlBackupAdapter`
- Behavioral: common execution flow in `AbstractSubsystem.execute(...)`

These choices also support SOLID and GRASP:

- Single Responsibility: connection, security, backup, logging, and subsystem access are separated
- Open/Closed: new subsystems can be added without rewriting the core
- Dependency Inversion: callers use subsystem APIs instead of raw JDBC
- Information Expert and Controller: logic lives in the classes closest to the responsibility

## Database Highlights

The schema was reconciled against the SQL files in `DbOfTeams` and the extracted UI data requirements in `_xlsx_teamui`.

For Business Intelligence specifically, the canonical model in `try 2` now follows the supplied file `C:\Users\harsh\Downloads\bi_phase3_database_schema.sql` instead of relying on the older spreadsheet-style interpretation.

Important shared tables include:

- `integration_registry`
- `permission_matrix`
- `data_ownership`
- `users`, `roles`, `user_sessions`
- `audit_logs`
- `customers`, `leads`, `interactions`, `campaigns`
- `orders`, `payments`, `shipments`
- `production_orders`, `quality_inspections`
- `project`, `task`, `resource`, `milestone`, `dependency`, `risk`, `budget`, `expense`
- `accounts`, `ledger`, `transactions`, `receivables`, `payables`
- `dashboards`, `kpis`, `report_runs`, `alerts`

Compatibility views were also added for names used by different teams, including:

- `user`, `customer`, `report`, `filter`
- `projects`, `project_tasks`, `project_resources`, `project_milestones`
- `crm_leads`, `sales_opportunities`, `sales_quotations`, `customer_interactions`
- `materials`, `automation_orders`, `bom_header`, `po_line_items`, `quality_checks`

## How To Run Locally

### 1. Build the Java project

From inside `try 2`:

```powershell
$env:MAVEN_OPTS='-Dmaven.repo.local=.m2\repository'
mvn package
```

Expected result:

- `target/erp-subsystem-sdk-1.0.0.jar` is created
- Maven ends with `BUILD SUCCESS`

### 2. Start local MySQL with Docker

Start Docker Desktop first, then run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup-local-db.ps1
```

If the container already existed and the schema did not refresh, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\reload-schema.ps1
```

### 3. Validate the schema

```powershell
Get-Content .\sql\02-verification.sql | docker exec -i erp-subsystem-mysql mysql -uroot -proot_password --binary-mode=1 erp_subsystem
```

### 4. Check the config file

Default configuration:

`src/main/resources/application-example.properties`

Default values:

- Host: `127.0.0.1`
- Port: `3306`
- Database: `erp_subsystem`
- User: `erp_user`
- Password: `erp_password`

## Demo Commands

### Smoke

```powershell
mvn exec:java "-Dexec.mainClass=com.erp.sdk.IntegrationDemoMain" "-Dexec.args=smoke"
```

### CRUD

```powershell
mvn exec:java "-Dexec.mainClass=com.erp.sdk.IntegrationDemoMain" "-Dexec.args=crud"
```

### Permission

```powershell
mvn exec:java "-Dexec.mainClass=com.erp.sdk.IntegrationDemoMain" "-Dexec.args=permission"
```

### Logging

```powershell
mvn exec:java "-Dexec.mainClass=com.erp.sdk.IntegrationDemoMain" "-Dexec.args=logging"
```

### All checks together

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run-demo-checks.ps1 -Mode all
```

This script runs the compiled classes directly with `java -cp ...`, so it also works when Maven plugin downloads are blocked.

## How Other Teams Use This

1. Build this folder and share `target/erp-subsystem-sdk-1.0.0.jar`
2. Other teams add that JAR to their Java project
3. They instantiate their allowed facade using `SubsystemFactory`
4. They call CRUD/join methods exposed by the subsystem class
5. They do not connect to MySQL directly

Example:

```java
DatabaseConfig config = DatabaseConfig.fromProperties(Path.of("application.properties"));
CRM crm = (CRM) SubsystemFactory.create(SubsystemName.CRM, config);
crm.readAll("customers", Map.of("status", "ACTIVE"), "crm_user");
```

## Backup And Restore

Only admin users can back up or restore.

Code path:

- `AbstractSubsystem.backupDatabase(...)`
- `AbstractSubsystem.restoreDatabase(...)`
- `MySqlBackupAdapter`

Important note:

- Backup/restore needs `mysqldump` and `mysql` CLI tools available in `PATH`
- Restore is intentionally restricted to admin users because it affects the full database

## Suggested Demo Flow

1. Explain your subsystem scope
2. Show `integration_registry`, `permission_matrix`, and `audit_logs`
3. Run `smoke`
4. Run `permission`
5. Run `logging`
6. Show the built JAR
7. Explain patterns and layered architecture

