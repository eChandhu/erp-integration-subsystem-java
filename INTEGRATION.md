# ERP Database SDK Integration Guide

## What This Module Does

This module is the shared local database layer for the ERP subsystem teams.
Each team uses the jar on its own PC, connects it to a local MySQL server, and
creates the facade object. The facade constructor bootstraps the schema and
prepares the permission data for the subsystem that owns the jar.

Teams should:

- use the database SDK jar
- configure local MySQL credentials
- create the facade object in code
- access tables only through the facade APIs and allowed subsystem tables

Teams should not:

- connect to MySQL directly for normal use
- run `schema.sql` manually every time
- depend on a centralized RDS instance
- distribute a separate exception-handler jar to other teams

## Main Rule

Use the facade class as the single entry point.

```java
com.erp.sdk.facade.ErpDatabaseFacade
```

Do not bypass the facade with direct JDBC code unless you are editing the SDK
itself.

## JAR Files To Use

After building this project, the circulation files are:

```text
distribution/erp-subsystem-sdk-1.0.0.jar
distribution/erp-subsystem-sdk-1.0.0-standalone.jar
distribution/application-example.properties
distribution/application-local.properties
distribution/application-local-template.properties
distribution/schema.sql
```

The standalone jar is the easiest option for other teams because it already
contains the runtime dependencies.

## How Subsystems Should Connect

### 1. Add the jar to the subsystem

If the consuming project is Maven-based, publish or install the SDK jar and add
it as a dependency.

If the consuming project is not Maven-based, add the standalone jar to the
classpath.

### 2. Provide database configuration

The subsystem must point to its local MySQL server.

Supported configuration sources:

1. JVM system properties
2. environment variables
3. `application.properties`
4. `application-local.properties`
5. `application-local-template.properties`

Supported keys:

| Setting | Environment Variable | Required |
|---|---|---|
| `db.host` | `DB_HOST` | Yes |
| `db.port` | `DB_PORT` | Yes |
| `db.name` | `DB_NAME` | Yes |
| `db.username` | `DB_USERNAME` | Yes |
| `db.password` | `DB_PASSWORD` | Yes |
| `db.pool.size` | `DB_POOL_SIZE` | No |

Example values:

```properties
db.host=127.0.0.1
db.port=3306
db.name=erp_subsystem
db.username=erp_user
db.password=erp_password
db.pool.size=5
```

### 3. Instantiate the facade

Example:

```java
import com.erp.sdk.facade.ErpDatabaseFacade;
import com.erp.sdk.subsystem.SubsystemName;

public class CrmSubsystemApp {
    public static void main(String[] args) {
        try (ErpDatabaseFacade facade = new ErpDatabaseFacade(SubsystemName.CRM)) {
            // call the SDK methods required by your subsystem here
        }
    }
}
```

## Schema Setup Behavior

Subsystem teams do not need to create tables manually during normal use.

When `ErpDatabaseFacade` starts, the SDK automatically:

1. reads the MySQL configuration
2. connects to the local MySQL instance
3. creates the database if it does not already exist
4. checks whether the schema is already present
5. applies the embedded `schema.sql` only when bootstrap is needed
6. seeds the permission data for the subsystem

Important:

- the SDK does not need a centralized database
- the SDK does not depend on RDS
- MySQL must still be running and reachable
- the DB user must have enough privileges to create the database and tables

## What Teams Need To Do

Each subsystem team should follow this process:

1. Copy the files from `distribution/`.
2. Choose the correct properties file for their local setup.
3. Set the MySQL host, port, username, and password.
4. Start MySQL on the same machine.
5. Create `ErpDatabaseFacade` in code.
6. Use the exposed SDK methods for their subsystem workflow.

They do not need to:

- open MySQL and run `schema.sql` manually for every machine
- build their own JDBC connection layer
- maintain a shared database server

## Build The JAR

From the project root:

```powershell
mvn package
```

Output:

```text
target/erp-subsystem-sdk-1.0.0.jar
target/erp-subsystem-sdk-1.0.0-standalone.jar
```

## Quick Start For Other Teams

If another subsystem wants to use this SDK, they only need to:

1. take the jar from `distribution/`
2. choose a properties file from `distribution/`
3. point it to their local MySQL server
4. create `ErpDatabaseFacade`
5. use the subsystem methods provided by the SDK

That is all.

