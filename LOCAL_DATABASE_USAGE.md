# Local Database Usage

This repository now runs with local MySQL only. The goal is that every team
can receive the JAR, create the facade, and get the full ERP schema on their
own laptop.

## Runtime Flow

1. A team starts MySQL on the local machine.
2. The team creates `ErpDatabaseFacade` or uses `SubsystemFactory.create(...)`.
3. `ConnectionManager` calls `SchemaBootstrapper.ensureSchemaInitialized(...)`.
4. The SDK creates `erp_subsystem` if it is missing.
5. The packaged `schema.sql` file is loaded from the JAR.
6. The requested subsystem facade starts enforcing permissions from
   `permission_matrix`.

The same schema file is also present at the repository root as `schema.sql`
for quick inspection and handoff.

For circulation, use the prepared [`distribution/`](distribution/README.md)
folder. It contains the JAR files and the application properties files that
other teams need.

## Configuration Lookup

`DatabaseConfig.load()` checks these locations in order:

- `application.properties`
- `application-local.properties`
- `src/main/resources/application.properties`
- `src/main/resources/application-local.properties`
- `src/main/resources/application-example.properties`

If no file is present, the SDK falls back to the local defaults:

```properties
db.host=127.0.0.1
db.port=3306
db.name=erp_subsystem
db.username=erp_user
db.password=erp_password
```

## Team Responsibilities

- Each team runs its own local MySQL server.
- Each team creates the facade in its own JVM process.
- Each team gets the same ERP tables locally.
- Access is controlled by the permission matrix seeded at bootstrap time.

## Exception Behavior

- Permission issues raise `UnauthorizedResourceAccessException`.
- JDBC and SQL issues raise `DatabaseOperationException`.
- No separate Exception subsystem JAR is distributed.
