# Distribution Package

This folder contains the files meant to be handed to other ERP teams.

## Contents

- `erp-subsystem-sdk-1.0.0.jar`
- `erp-subsystem-sdk-1.0.0-standalone.jar`
- `application-example.properties`
- `application-local.properties`
- `application-local-template.properties`
- `schema.sql`

## How To Use

1. Copy the JAR and one properties file into the consuming team's project.
2. Point the properties file at that team's local MySQL server.
3. Create `ErpDatabaseFacade` with the correct `SubsystemName`.
4. The SDK bootstraps the schema locally on first use.
5. `schema.sql` is the visible copy of the exact schema used by the JAR.
