# OOAD Requirement Mapping

| Requirement | Implemented In | Proof / Notes |
|---|---|---|
| Every subsystem has CRUD interface | `com.erp.sdk.subsystem.*`, especially `AbstractSubsystem` | All subsystem facades inherit CRUD methods |
| Raise exception for inaccessible tables | `PermissionService`, `UnauthorizedResourceAccessException` | Access denied if `permission_matrix` has no matching permission |
| Admin backup and restore | `AbstractSubsystem.backupDatabase`, `AbstractSubsystem.restoreDatabase`, `MySqlBackupAdapter` | Admin role check before backup/restore |
| Interface class should be subsystem name | `Integration`, `CRM`, `UI`, `HR`, etc. | Matches subsystem names |
| Joins handled by code | `join(JoinRequest, username)` in `AbstractSubsystem` | Teams do not write SQL joins directly |
| Adapter, Factory, SOLID, GRASP | `MySqlBackupAdapter`, `SubsystemFactory`, layered classes | Architectural separation included |
| Use behavioral, structural, creational patterns | `AbstractSubsystem.execute`, facade classes, `MySqlBackupAdapter`, `SubsystemFactory` | All three categories present |
| Use MySQL DB | `sql/01-schema.sql`, JDBC config | MySQL-specific setup and Docker image |
| Keep pool of connections, allow concurrency | `ConnectionManager` with HikariCP | Pool is configured and reusable |
| Subsystems cannot directly access DB | Design of SDK | Teams are expected to use only subsystem facade methods |
| DB server should be separate and live | Docker for local, RDS-ready for cloud | Config supports external MySQL endpoint |
| Provide Java class/JAR to teams | `mvn package` -> `target/erp-subsystem-sdk-1.0.0.jar` | Shareable artifact |
| Log success or failure of DB access | `AuditLogger`, `audit_logs` table | Success/failure rows recorded |

## Execution Proof You Should Collect

After running on your machine, keep:

1. `mvn package` success output
2. Docker MySQL startup output
3. `smoke` run output
4. `permission` run output
5. `logging` run output
6. A screenshot of `audit_logs`
