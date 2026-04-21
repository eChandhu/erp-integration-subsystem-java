# How Other Teams Integrate Locally

This JAR is meant to be dropped into another team'"'"'s ERP subsystem project.
They do not connect to a central database. They run MySQL on their own
machine, create the facade, and the SDK creates the schema locally.

## What Each Team Needs

- `distribution/erp-subsystem-sdk-1.0.0-standalone.jar`
- `distribution/application-example.properties`
- `distribution/application-local.properties`
- `distribution/application-local-template.properties`
- a local MySQL server
- a database user that can create the `erp_subsystem` schema on first run

## Minimal Integration

```java
import com.erp.sdk.facade.ErpDatabaseFacade;
import com.erp.sdk.subsystem.SubsystemName;

try (ErpDatabaseFacade facade = new ErpDatabaseFacade(SubsystemName.CRM)) {
    // Use CRUD methods here
}
```

The constructor is the bootstrap point. It creates the database if it is
missing, loads `schema.sql` from the JAR, and seeds `integration_registry`,
`permission_matrix`, and the other shared ERP tables.

If teams want a single folder to circulate, point them to
[`distribution/`](distribution/README.md).

## How Access Control Works

- Every machine gets the full set of ERP tables locally.
- Each subsystem is limited by `permission_matrix`.
- If a subsystem is not granted access, `UnauthorizedResourceAccessException`
  is thrown.
- If MySQL or JDBC fails, the SDK throws `DatabaseOperationException`.

## Exception Handling

No external Exception subsystem JAR is distributed. The SDK owns exception
mapping locally through `ExceptionCode`, `LocalExceptionHandler`, and the
`ExceptionLogger` helper.

## Default Connection Settings

```properties
db.host=127.0.0.1
db.port=3306
db.name=erp_subsystem
db.username=erp_user
db.password=erp_password
```

If teams use the bundled Docker Compose file, they should point `db.port` to
the mapped host port instead.
