# Quick Start

## Prerequisites

- Java 21
- Maven 3.9+
- MySQL running locally on the same machine

## Build

```powershell
mvn package
```

The ready-to-share artifacts are collected under
[`distribution/`](distribution/README.md).

## Configure Local MySQL

Use these defaults unless your local MySQL setup is different:

```properties
db.host=127.0.0.1
db.port=3306
db.name=erp_subsystem
db.username=erp_user
db.password=erp_password
```

## First Run

```java
import com.erp.sdk.facade.ErpDatabaseFacade;
import com.erp.sdk.subsystem.SubsystemName;

try (ErpDatabaseFacade facade = new ErpDatabaseFacade(SubsystemName.CRM)) {
    System.out.println("Schema created or verified locally.");
}
```

The constructor is what matters. It ensures the database exists and then loads
the packaged schema into the local MySQL server.

## What To Expect

- All ERP tables are created on the local machine
- Permission rows are seeded into `permission_matrix`
- Audit logging is enabled through `audit_logs`
- Permission failures raise `UnauthorizedResourceAccessException`
- JDBC and SQL failures raise `DatabaseOperationException`
