# ERP Subsystem Database SDK

This project is the local-first database SDK for the ERP integration scope.
Each team runs the jar on its own machine, points it at its own local MySQL
server, and creates the facade object. The facade constructor bootstraps the
schema, creates the required tables, and seeds the access-control data that the
team is allowed to use.

## What Changed From The Old Setup

- no centralized RDS database
- no shared remote database dependency
- no exception-handler jar for other teams to distribute
- one local MySQL database per machine

## Canonical Files

Only these three markdown files are kept in the repository:

- [README.md](README.md)
- [INTEGRATION.md](INTEGRATION.md)
- [DATABASE_SCHEMA_REFERENCE.md](DATABASE_SCHEMA_REFERENCE.md)

The visible schema copy is at the repository root as [schema.sql](schema.sql).
The runtime copy used by the jar lives in `src/main/resources/schema.sql`.

## Build

```powershell
mvn package
```

This produces:

- `target/erp-subsystem-sdk-1.0.0.jar`
- `target/erp-subsystem-sdk-1.0.0-standalone.jar`

## Distribution Folder

For circulation, use the files in `distribution/`:

- `erp-subsystem-sdk-1.0.0.jar`
- `erp-subsystem-sdk-1.0.0-standalone.jar`
- `application-example.properties`
- `application-local.properties`
- `application-local-template.properties`
- `schema.sql`

## Local Defaults

```properties
db.host=127.0.0.1
db.port=3306
db.name=erp_subsystem
db.username=erp_user
db.password=erp_password
```

These values can be overridden through the local properties files, JVM system
properties, or environment variables.

## How Teams Use It

```java
import com.erp.sdk.facade.ErpDatabaseFacade;
import com.erp.sdk.subsystem.SubsystemName;

try (ErpDatabaseFacade facade = new ErpDatabaseFacade(SubsystemName.CRM)) {
    // use the facade methods here
}
```

Creating the facade is the important step. That is what initializes the local
database and applies the permission matrix for the team that owns the jar.

## Sharing With Other Teams

When you circulate the project, send:

1. the standalone jar
2. one properties file that matches their local MySQL setup
3. `schema.sql`
4. this README
5. `INTEGRATION.md`
6. `DATABASE_SCHEMA_REFERENCE.md`

