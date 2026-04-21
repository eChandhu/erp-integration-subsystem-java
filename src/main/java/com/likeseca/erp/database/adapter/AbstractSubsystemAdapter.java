package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.JoinSpec;
import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

import java.util.List;
import java.util.Map;

public abstract class AbstractSubsystemAdapter {
    private final SubsystemId subsystem;
    private final PermissionAwareOperations operations;

    protected AbstractSubsystemAdapter(SubsystemId subsystem, PermissionAwareOperations operations) {
        this.subsystem = subsystem;
        this.operations = operations;
    }

    public long create(String tableName, Map<String, Object> payload) {
        return operations.create(subsystem, tableName, payload);
    }

    public List<Map<String, Object>> readAll(String tableName, Map<String, Object> filters) {
        return operations.readAll(subsystem, tableName, filters);
    }

    public Map<String, Object> readById(String tableName, String idColumn, Object idValue) {
        return operations.readById(subsystem, tableName, idColumn, idValue);
    }

    public int update(String tableName, String idColumn, Object idValue, Map<String, Object> payload) {
        return operations.update(subsystem, tableName, idColumn, idValue, payload);
    }

    public int delete(String tableName, String idColumn, Object idValue) {
        return operations.delete(subsystem, tableName, idColumn, idValue);
    }

    public List<Map<String, Object>> join(JoinSpec joinSpec) {
        return operations.join(subsystem, joinSpec);
    }

    public SubsystemId subsystem() {
        return subsystem;
    }
}
