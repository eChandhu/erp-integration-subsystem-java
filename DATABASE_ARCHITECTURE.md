# ERP Database Architecture

## Summary

The ERP SDK uses a local-first architecture. Each team receives the same JAR,
runs MySQL on their own machine, and creates the facade object. The facade
constructor bootstraps the database schema the first time it runs.

## Core Flow

1. A team creates `ErpDatabaseFacade`.
2. `SubsystemFactory` builds the subsystem object.
3. `ConnectionManager` asks `SchemaBootstrapper` to verify the local schema.
4. `SchemaBootstrapper` creates `erp_subsystem` if it is missing.
5. The packaged `schema.sql` file is loaded from the JAR.
6. `PermissionService` enforces access using `permission_matrix`.
7. `AuditLogger` records the operation in `audit_logs`.
8. `LocalExceptionHandler` maps JDBC problems to local ERP exception codes.

## Main Components

- `ErpDatabaseFacade`: the one class other teams should use
- `SubsystemFactory`: creates the subsystem-specific implementation
- `ConnectionManager`: owns the local HikariCP connection pool
- `SchemaBootstrapper`: creates the local database and tables
- `PermissionService`: validates table and column access
- `AuditLogger`: stores success and failure events
- `ExceptionLogger`: optional local exception persistence helper

## What Is Stored Locally

- the integration registry
- the permission matrix
- ownership metadata
- subsystem business tables
- audit rows for successful and failed operations
- local exception classifications inside the same SDK

## Why This Design Works

- every team can run independently on their own laptop
- no RDS or shared database is required
- the same permission rules are enforced everywhere
- the schema is created from the packaged JAR, so setup is repeatable

