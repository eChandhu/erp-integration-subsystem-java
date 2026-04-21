# ERP Integration Guide

This guide explains how another ERP team uses the database SDK locally.

## What The Team Receives

- `erp-subsystem-sdk-1.0.0-standalone.jar`
- the local MySQL configuration template
- the root markdown documentation in this repository

## How Integration Starts

```java
import com.erp.sdk.facade.ErpDatabaseFacade;
import com.erp.sdk.subsystem.SubsystemName;

try (ErpDatabaseFacade facade = new ErpDatabaseFacade(SubsystemName.CRM)) {
    // CRUD goes here
}
```

The constructor bootstraps the local schema. That means the team does not need
to create tables by hand before they run the JAR.

## What The SDK Does Automatically

- creates the local `erp_subsystem` database if needed
- loads `schema.sql` from inside the JAR
- creates all ERP tables for the distributed subsystems
- seeds `integration_registry`, `permission_matrix`, `data_ownership`, and
  related shared tables
- enforces table and column access from the permission matrix

## Security And Access

- `UnauthorizedResourceAccessException` is thrown for blocked table access
- `DatabaseOperationException` is thrown for SQL or connection failures
- local exception codes are handled by `ExceptionCode`
- no external exception subsystem JAR is distributed

## Build Output

```powershell
mvn package
```

The jar files are created under `target/`:

- `erp-subsystem-sdk-1.0.0.jar`
- `erp-subsystem-sdk-1.0.0-standalone.jar`

