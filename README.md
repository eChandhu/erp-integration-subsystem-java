# Local ERP Database Module

A local-first Java database module for a multi-subsystem ERP system.

This project packages the full ERP schema, bootstraps it into a local MySQL instance on first use, seeds subsystem access metadata, and exposes a shared Java facade that other subsystem teams can consume through a JAR.

## Overview

This module is designed for a distributed academic or team ERP setup where each subsystem runs on its own machine with a local MySQL server instead of a shared hosted database.

When a client application creates the main database facade:

- the module connects to local MySQL
- creates the ERP schema if needed
- loads the bundled SQL schema
- seeds integration and permission metadata
- exposes subsystem-specific facades for CRUD and join operations

The project currently supports 17 ERP subsystems:

1. Database Integration
2. UI
3. CRM
4. Marketing
5. Sales Management
6. Order Processing
7. Supply Chain
8. Manufacturing
9. HR
10. Project Management
11. Reporting
12. Data Analytics
13. Business Intelligence
14. Automation
15. Business Control
16. Financial Management
17. Accounting

## Key Features

- Local MySQL bootstrap on first use
- Bundled canonical ERP schema
- Shared top-level Java facade
- Subsystem-specific facades and adapters
- Permission-aware CRUD and join operations
- Internal exception handling
- Maven build and test support
- Prebuilt handoff bundle for other teams

## Project Structure

```text
src/main/java/com/.../config
src/main/java/com/.../exception
src/main/java/com/.../security
src/main/java/com/.../service
src/main/java/com/.../adapter
src/main/java/com/.../facade
src/main/resources/sql
src/test/java
dist/
IntegrationDB/
```

Main areas:

- `config`: database configuration, connection management, schema bootstrap
- `exception`: internal exception mapping and logging
- `security`: permission lookup from `permission_matrix`
- `service`: JDBC execution and permission-aware operations
- `adapter`: subsystem-specific adapters
- `facade`: top-level facade and subsystem facades
- `src/main/resources/sql`: bundled schema and verification SQL
- `dist`: prebuilt distribution bundle
- `IntegrationDB`: ready-to-share delivery bundle

## Design Approach

This project is structured with a strong focus on separation of concerns, maintainability, and handoff simplicity, and it reflects a solid grasp of reusable design patterns for a multi-subsystem ERP environment.

The design follows SOLID-oriented thinking:

- `Single Responsibility Principle`
  - `config` handles database setup and schema bootstrap
  - `security` handles permission lookup and permission checks
  - `service` handles SQL execution and CRUD/join behavior
  - `adapter` binds each subsystem to the shared operations layer
  - `facade` exposes a clean API for consuming teams
- `Open/Closed Principle`
  - new subsystem adapters and subsystem facades can be added without rewriting the core CRUD engine
- `Liskov Substitution Principle`
  - subsystem facades share the same behavior contract through the common facade and adapter structure
- `Interface Segregation Principle`
  - consumers use focused subsystem-facing entry points instead of dealing with one large low-level API surface
- `Dependency Inversion Principle`
  - higher-level subsystem APIs depend on shared abstractions and service layers instead of embedding raw JDBC logic everywhere

Patterns used in the project:

- `Facade`
  - where: `ErpDatabaseFacade` and subsystem facade classes
  - why: gives other teams one simple entry point instead of making them work directly with bootstrap, permission, and SQL internals
- `Adapter`
  - where: subsystem adapter classes such as CRM, HR, Supply Chain, and others
  - why: maps each subsystem to the same underlying permission-aware operations layer while keeping subsystem entry points clean
- `Singleton`
  - where: database connection manager
  - why: centralizes connection lifecycle and avoids uncontrolled connection creation across the module
- `Template-style shared operation flow`
  - where: the permission-aware operations service
  - why: keeps create, read, update, delete, and join flows consistent by always following the same sequence of permission check, column filtering, SQL execution, and exception handling
- `Layered architecture`
  - where: `config -> security -> service -> adapter -> facade`
  - why: reduces coupling and makes the project easier to test, extend, and hand off to other teams

This combination is especially useful for this project because the module has to act like a reusable local database platform for many subsystems, not just a one-off application.


## Requirements

- Java 21
- Maven 3.9+
- MySQL 8+ running locally
- A MySQL user with permission to create databases, tables, views, and seed data

## Configuration

The module reads configuration from:

1. JVM system properties
2. environment variables
3. `database.properties` on the classpath

Typical configuration:

```properties
db.host=127.0.0.1
db.port=3306
db.name=erp_subsystem
db.username=root
db.password=your_local_mysql_password
db.pool.size=4
```

Supported environment variables:

- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USERNAME`
- `DB_PASSWORD`
- `DB_POOL_SIZE`

## Build

```powershell
cd "C:\Path\To\Project"
$env:MAVEN_OPTS='-Dmaven.repo.local=.m2\repository'
mvn package
```

Expected output:

- `target/local-database-module-1.0.0.jar`

## Run The Demo

```powershell
cd "C:\Path\To\Project"
mvn exec:java
```

Or run the built JAR directly:

```powershell
cd "C:\Path\To\Project"
java -cp "target\local-database-module-1.0.0.jar;dist\lib\*" com.likeseca.erp.database.facade.DemoApplication
```

If you prefer passing DB settings at runtime:

```powershell
cd "C:\Path\To\Project"
java -Ddb.host=127.0.0.1 -Ddb.port=3306 -Ddb.name=erp_subsystem -Ddb.username=your_mysql_username -Ddb.password=your_mysql_password -cp "target\local-database-module-1.0.0.jar;dist\lib\*" com.likeseca.erp.database.facade.DemoApplication
```

## Run Tests

Full suite:

```powershell
cd "C:\Path\To\Project"
$env:MAVEN_OPTS='-Dmaven.repo.local=.m2\repository'
mvn "-Ddb.host=127.0.0.1" "-Ddb.port=3306" "-Ddb.name=erp_subsystem" "-Ddb.username=your_mysql_username" "-Ddb.password=your_mysql_password" test
```

Subsystem behavior suite only:

```powershell
cd "C:\Path\To\Project"
$env:MAVEN_OPTS='-Dmaven.repo.local=.m2\repository'
mvn "-Ddb.host=127.0.0.1" "-Ddb.port=3306" "-Ddb.name=erp_subsystem" "-Ddb.username=your_mysql_username" "-Ddb.password=your_mysql_password" "-Dtest=AllSubsystemBehaviorSmokeTest" test
```

The current test coverage includes:

- schema bootstrap smoke checks
- seeded metadata validation
- facade API surface checks
- behavior smoke coverage for all 17 subsystems

## Usage Example

```java
import com.likeseca.erp.database.facade.ErpDatabaseFacade;

import java.util.Map;

public class TeamApp {
    public static void main(String[] args) {
        try (ErpDatabaseFacade facade = new ErpDatabaseFacade()) {
            System.out.println(
                    facade.crmSubsystem().readAll("customers", Map.of())
            );
        }
    }
}
```

Available subsystem entry points include:

- `databaseIntegrationSubsystem()`
- `uiSubsystem()`
- `crmSubsystem()`
- `marketingSubsystem()`
- `salesManagementSubsystem()`
- `orderProcessingSubsystem()`
- `supplyChainSubsystem()`
- `manufacturingSubsystem()`
- `hrSubsystem()`
- `projectManagementSubsystem()`
- `reportingSubsystem()`
- `dataAnalyticsSubsystem()`
- `businessIntelligenceSubsystem()`
- `automationSubsystem()`
- `businessControlSubsystem()`
- `financialManagementSubsystem()`
- `accountingSubsystem()`

## How Bootstrap Works

On first run, the module loads the bundled schema from `src/main/resources/sql/01-schema.sql` and creates the local ERP schema automatically.

If the module detects a broken or partial initialization, it may recreate the target schema to recover to a clean state. Because of that:

- use the configured schema only for this project
- do not store unrelated data in the same schema

## Permissions Model

The module seeds and uses a `permission_matrix` table for subsystem access checks.

For the current handoff version, the permission setup is intentionally broad to reduce cross-team integration failures on local machines. That means the module prioritizes reliable access over strict least-privilege during handoff and demo use.

## Distribution

The repository includes a prebuilt delivery bundle under `dist/` and a ready-to-share handoff folder under `IntegrationDB/`.

The bundle contains:

- `local-database-module-1.0.0.jar`
- `database-template.properties`
- `README_FOR_OTHER_TEAMS.md`
- `lib/mysql-connector-j-9.3.0.jar`
- `lib/slf4j-api-2.0.17.jar`
- `lib/slf4j-simple-2.0.17.jar`

## Recommended Team Handoff Flow

If another subsystem team needs to use this module locally:

1. Place the `IntegrationDB` folder inside their project folder.
2. Copy `IntegrationDB\database-template.properties` to `database.properties` in their project root.
3. Update MySQL credentials in `database.properties`.
4. Compile their project with the JAR and dependency JARs from `IntegrationDB`.
5. Run their own main class with the same classpath.

## Quick Verification

After the first successful run, verify in MySQL:

```sql
SHOW DATABASES;
USE erp_subsystem;
SHOW TABLES;
SELECT subsystem_name FROM integration_registry;
```

## Notes

- This project is intended for local use, not hosted deployment.
- It assumes each team runs its own local MySQL-backed copy.
- Environment setup still matters: Java version, MySQL permissions, and classpath configuration must be correct on each machine.
