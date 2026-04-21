# ERP Subsystem Database SDK

This project is the local-first database SDK for the ERP integration module.
Each team receives the JAR, runs MySQL on their own machine, and creates the
facade object. The constructor bootstraps the local database, creates the ERP
schema if needed, and loads the permission matrix seed data.

The important design change is simple:

- no centralized RDS database
- no shared remote database dependency
- no separate Exception subsystem JAR for other teams
- one local MySQL instance per team machine

## What ships in the JAR

- `ErpDatabaseFacade` as the single entry point for other teams
- `SchemaBootstrapper` to create the database and tables on first use
- `permission_matrix` and `integration_registry` seed data
- audit logging through `audit_logs`

## Canonical schema source

The runtime schema that gets packaged into the JAR lives in
`src/main/resources/schema.sql`.

The same schema is also mirrored at the repository root as `schema.sql` so
other teams can see the exact bootstrap file immediately.

## Build

```powershell
mvn package
```

This produces:

- `target/erp-subsystem-sdk-1.0.0.jar`
- `target/erp-subsystem-sdk-1.0.0-standalone.jar`

The circulation files are collected in [distribution/](distribution/README.md).
Send the standalone JAR from that folder to other teams if they do not want to
manage Maven dependencies themselves.

## Local Defaults

```properties
db.host=127.0.0.1
db.port=3306
db.name=erp_subsystem
db.username=erp_user
db.password=erp_password
```

These values can be overridden with `application.properties`,
`application-local.properties`, JVM system properties, or environment
variables.

## How Other Teams Use It

```java
import com.erp.sdk.facade.ErpDatabaseFacade;
import com.erp.sdk.subsystem.SubsystemName;

import java.util.Map;

try (ErpDatabaseFacade facade = new ErpDatabaseFacade(SubsystemName.CRM)) {
    var rows = facade.readAll("customers", Map.of(), "admin_main");
    System.out.println(rows);
}
```

Creating the facade is the important step. That is what creates the local
schema and starts enforcing the subsystem permission matrix.

## Root Documentation

The explanation files live in the repository root so they are easy to share
with teams:

- `DATABASE_ARCHITECTURE.md`
- `DATABASE_SCHEMA_REFERENCE.md`
- `INTEGRATION.md`
- `QUICK_START.md`
- `README_FOR_OTHER_TEAMS_LOCAL.md`
- `LOCAL_DATABASE_USAGE.md`
- `schema.sql`
- `distribution/README.md`
