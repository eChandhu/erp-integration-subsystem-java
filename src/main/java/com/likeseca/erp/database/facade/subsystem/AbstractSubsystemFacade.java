package com.likeseca.erp.database.facade.subsystem;

import com.likeseca.erp.database.adapter.AbstractSubsystemAdapter;
import com.likeseca.erp.database.model.JoinSpec;

import java.util.List;
import java.util.Map;

public abstract class AbstractSubsystemFacade {
    private final AbstractSubsystemAdapter adapter;

    protected AbstractSubsystemFacade(AbstractSubsystemAdapter adapter) {
        this.adapter = adapter;
    }

    public long create(String tableName, Map<String, Object> payload) {
        return adapter.create(tableName, payload);
    }

    public List<Map<String, Object>> readAll(String tableName, Map<String, Object> filters) {
        return adapter.readAll(tableName, filters);
    }

    public Map<String, Object> readById(String tableName, String idColumn, Object idValue) {
        return adapter.readById(tableName, idColumn, idValue);
    }

    public int update(String tableName, String idColumn, Object idValue, Map<String, Object> payload) {
        return adapter.update(tableName, idColumn, idValue, payload);
    }

    public int delete(String tableName, String idColumn, Object idValue) {
        return adapter.delete(tableName, idColumn, idValue);
    }

    public List<Map<String, Object>> join(JoinSpec joinSpec) {
        return adapter.join(joinSpec);
    }

    protected AbstractSubsystemAdapter adapter() {
        return adapter;
    }
}
