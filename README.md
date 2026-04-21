# LikeSecA Local ERP Database Module

`LikeSecA` is a new local-first database integration module modeled after the layered structure used in `database_module-main`, but implemented for your ERP system, your canonical schema, and your subsystem access rules.

It uses:

- bundled schema bootstrap
- local MySQL only
- a shared top-level facade
- subsystem-specific adapters
- permission-controlled CRUD and joins
- internal exception handling in code

## What Was Implemented

The module is based on your ERP schema and permission model from:

- `sql/01-schema.sql`
- `DbOfTeams`

The canonical schema is bundled into the JAR and is bootstrapped locally on first use.

Important delivery choice:

- `LikeSecA` now favors reliability over strict least-privilege for local handoff use
- every subsystem is granted access to all base tables
- compatibility views are readable by every subsystem
- this is intentional so teams do not fail later because of missing permission rows

## Architecture

The project follows the same style of layered modular design as the reference project:

- `config`
  Database configuration, local connection management, schema bootstrap
- `exception`
  Internal database exception classification and logging
- `security`
  Permission lookup from `permission_matrix`
- `service`
  JDBC operations and permission-aware CRUD/join execution
- `adapter`
  One adapter per subsystem
- `facade`
  One top-level facade that exposes subsystem facades and adapters

Patterns and principles used:

- Facade
- Adapter
- Subsystem facade layer
- Singleton connection manager
- Factory-style bootstrap through `ErpDatabaseFacade`
- Template-style shared CRUD execution through `PermissionAwareOperations`
- layered separation of concerns
- SOLID-friendly structure

## 17 Subsystem Adapters

The module exposes adapters for these 17 subsystems:

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

Important note:

- `AccountingAdapter` is provided as a local integration alias and maps to the canonical Financial Management permission scope, because your canonical permission model uses `Financial Management`.

## Files To Send To Other Teams

Send the contents of:

`LikeSecA/dist`

Specifically:

1. `local-database-module-1.0.0.jar`
2. `database-template.properties`
3. `README_FOR_OTHER_TEAMS.md`
4. `lib/mysql-connector-j-9.3.0.jar`
5. `lib/slf4j-api-2.0.17.jar`
6. `lib/slf4j-simple-2.0.17.jar`

That is the handoff bundle.

Do not send source code folders.
Do not ask teams to rebuild the JAR.
Send the prebuilt `dist` bundle only.

## What You Should Test On Your Machine

Before sending anything, do this on your own machine.

### 1. Make sure local MySQL is running

Use normal local MySQL.

You do not need Docker.

Expected local connection style:

- host: `127.0.0.1`
- port: `3306`

Your local MySQL user must be able to:

- create databases
- drop databases
- create tables
- create views
- create procedures
- insert seed data

### 2. Edit the local config

File:

`LikeSecA/src/main/resources/database.properties`

Set:

```properties
db.host=127.0.0.1
db.port=3306
db.name=erp_subsystem
db.username=your_local_mysql_username
db.password=your_local_mysql_password
db.pool.size=4
```

If you want to keep your source file unchanged, you can also pass these at runtime through JVM properties:

```powershell
-Ddb.host=127.0.0.1 -Ddb.port=3306 -Ddb.name=erp_subsystem -Ddb.username=your_local_mysql_username -Ddb.password=your_local_mysql_password
```

### 3. Build the module

From inside `LikeSecA`:

```powershell
cd "C:\Users\harsh\OneDrive\Desktop\try 2\LikeSecA"
$env:MAVEN_OPTS='-Dmaven.repo.local=.m2\repository'
mvn package
```

Expected result:

- `target/local-database-module-1.0.0.jar`
- `BUILD SUCCESS`

### 4. Run the demo

From inside `LikeSecA`:

```powershell
cd "C:\Users\harsh\OneDrive\Desktop\try 2\LikeSecA"
mvn exec:java
```

What should happen:

- the module connects to local MySQL
- it creates `erp_subsystem` if needed
- it bootstraps the full canonical schema from the bundled SQL
- it seeds integration and permission data
- it prints a small demo summary

If you prefer running the built JAR directly after `mvn package`, use:

```powershell
cd "C:\Users\harsh\OneDrive\Desktop\try 2\LikeSecA"
java -cp "target\local-database-module-1.0.0.jar;dist\lib\*" com.likeseca.erp.database.facade.DemoApplication
```

If you want to pass DB settings without editing `database.properties`, use:

```powershell
cd "C:\Users\harsh\OneDrive\Desktop\try 2\LikeSecA"
java -Ddb.host=127.0.0.1 -Ddb.port=3306 -Ddb.name=erp_subsystem -Ddb.username=your_local_mysql_username -Ddb.password=your_local_mysql_password -cp "target\local-database-module-1.0.0.jar;dist\lib\*" com.likeseca.erp.database.facade.DemoApplication
```

### 5. Run the test suite

From inside `LikeSecA`:

```powershell
cd "C:\Users\harsh\OneDrive\Desktop\try 2\LikeSecA"
$env:MAVEN_OPTS='-Dmaven.repo.local=.m2\repository'
mvn "-Ddb.host=127.0.0.1" "-Ddb.port=3306" "-Ddb.name=erp_subsystem" "-Ddb.username=your_local_mysql_username" "-Ddb.password=your_local_mysql_password" test
```

This test suite now checks:

- schema bootstrap does not crash
- `integration_registry` is seeded
- `permission_matrix` is seeded
- all subsystem registrations exist
- your database-integration subsystem can read shared tables
- the new subsystem-facade API is available
- all 17 subsystem facades can read representative tables
- all 17 subsystem facades can complete a safe customer CRUD cycle

If you want to run only the subsystem behavior suite:

```powershell
cd "C:\Users\harsh\OneDrive\Desktop\try 2\LikeSecA"
$env:MAVEN_OPTS='-Dmaven.repo.local=.m2\repository'
mvn "-Ddb.host=127.0.0.1" "-Ddb.port=3306" "-Ddb.name=erp_subsystem" "-Ddb.username=your_local_mysql_username" "-Ddb.password=your_local_mysql_password" "-Dtest=AllSubsystemBehaviorSmokeTest" test
```

### 6. Verify in MySQL Workbench

Check:

- schema `erp_subsystem` exists
- `integration_registry` exists
- `permission_matrix` exists
- `users` exists
- shared ERP tables exist
- compatibility views exist

## Important Bootstrap Behavior

The bootstrapper checks whether the schema is ready.

If it sees a partial or broken initialization, it resets the local `erp_subsystem` database and recreates it cleanly.

So:

- use `erp_subsystem` only for this ERP project
- do not store unrelated work inside that schema

## How Other Teams Should Use It

Other teams should:

1. add the JAR and the `lib` jars to their project classpath
2. copy `database-template.properties` into their project
3. fill in their own local MySQL username/password
4. instantiate `ErpDatabaseFacade`
5. use their subsystem facade entry point first

Recommended rule for teams:

- use their own adapter first
- prefer their own subsystem facade method such as `facade.crmSubsystem()`
- if they need cross-subsystem data, they can still read the required local tables through the same facade
- they should not create their own direct JDBC layer around the schema

They should not:

- connect directly to the ERP schema using JDBC
- manually run the schema in normal usage
- modify the permission matrix manually

## Example Usage

```java
import com.likeseca.erp.database.facade.ErpDatabaseFacade;

import java.util.Map;

public class CrmClientApp {
    public static void main(String[] args) {
        try (ErpDatabaseFacade facade = new ErpDatabaseFacade()) {
            System.out.println(
                    facade.crmSubsystem().readAll("customers", Map.of())
            );
        }
    }
}
```

The older adapter-style calls such as `facade.crm()` still work, but the newer subsystem-facade methods match the reference project structure more closely.

## What I Can And Cannot Guarantee

What is true:

- the new `LikeSecA` module was created
- it follows the same general layered implementation style as the reference project
- it builds successfully in this workspace
- the canonical ERP schema is bundled into the new module
- local bootstrap, permission-aware CRUD, joins, and subsystem adapters are implemented

What I cannot honestly guarantee:

- zero runtime errors on every team machine without testing their actual local MySQL setup
- success if a team uses wrong credentials or insufficient MySQL privileges
- success if they wire the classpath incorrectly

## Final Checklist Before Sending

1. set your real local MySQL username and password in `LikeSecA/src/main/resources/database.properties`
2. run `mvn package`
3. run `mvn exec:java` once on your machine
4. run `mvn test` once on your machine
5. verify `erp_subsystem` in MySQL Workbench
6. confirm a few subsystem facades can read data without permission failures
7. send only the `LikeSecA/dist` bundle to the teams

## Exactly What You Should Send

Create a folder named:

`IntegrationDB`

Inside that folder, keep these files exactly:

1. `local-database-module-1.0.0.jar`
2. `database-template.properties`
3. `README_FOR_OTHER_TEAMS.md`
4. `lib/mysql-connector-j-9.3.0.jar`
5. `lib/slf4j-api-2.0.17.jar`
6. `lib/slf4j-simple-2.0.17.jar`

The easiest way is:

```powershell
cd "C:\Users\harsh\OneDrive\Desktop\try 2\LikeSecA"
Copy-Item -LiteralPath ".\dist" -Destination ".\IntegrationDB" -Recurse -Force
```

Then send that `IntegrationDB` folder to the other teams.
