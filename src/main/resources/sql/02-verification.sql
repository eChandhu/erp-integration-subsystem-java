USE erp_subsystem;

SELECT subsystem_name, is_active
FROM integration_registry
ORDER BY subsystem_name;

SELECT resource_table, stewardship_notes
FROM data_ownership
ORDER BY resource_table;

SELECT subsystem_name, resource_table, can_create, can_read, can_update, can_delete
FROM permission_matrix pm
JOIN integration_registry ir ON ir.subsystem_id = pm.subsystem_id
ORDER BY subsystem_name, resource_table;

SELECT action, subsystem_name, resource_table, success, log_timestamp
FROM audit_logs
ORDER BY log_id DESC
LIMIT 20;
