package com.erp.sdk.facade;

import com.erp.sdk.config.DatabaseConfig;
import com.erp.sdk.factory.SubsystemFactory;
import com.erp.sdk.sql.JoinRequest;
import com.erp.sdk.subsystem.AbstractSubsystem;
import com.erp.sdk.subsystem.SubsystemName;

import java.nio.file.Path;
import java.util.List;
import java.util.Map;

/**
 * Single facade class intended for other ERP teams. Constructing this class
 * creates the local database/schema on first use, then exposes CRUD methods that
 * are filtered by the caller's subsystem permissions in permission_matrix.
 */
public final class ErpDatabaseFacade implements AutoCloseable {
    private final AbstractSubsystem subsystem;

    public ErpDatabaseFacade(SubsystemName subsystemName) {
        this(subsystemName, DatabaseConfig.load());
    }

    public ErpDatabaseFacade(SubsystemName subsystemName, DatabaseConfig config) {
        this.subsystem = SubsystemFactory.create(subsystemName, config);
    }

    public long create(String tableName, Map<String, Object> payload, String username) {
        return subsystem.create(tableName, payload, username);
    }

    public List<Map<String, Object>> readAll(String tableName, Map<String, Object> filters, String username) {
        return subsystem.readAll(tableName, filters, username);
    }

    public Map<String, Object> readById(String tableName, String idColumn, Object idValue, String username) {
        return subsystem.readById(tableName, idColumn, idValue, username);
    }

    public int update(String tableName, String idColumn, Object idValue, Map<String, Object> payload, String username) {
        return subsystem.update(tableName, idColumn, idValue, payload, username);
    }

    public int delete(String tableName, String idColumn, Object idValue, String username) {
        return subsystem.delete(tableName, idColumn, idValue, username);
    }

    public List<Map<String, Object>> join(JoinRequest request, String username) {
        return subsystem.join(request, username);
    }

    public Path backupDatabase(String username) {
        return subsystem.backupDatabase(username);
    }

    public void restoreDatabase(String username, Path backupPath) {
        subsystem.restoreDatabase(username, backupPath);
    }

    @Override
    public void close() {
        subsystem.close();
    }
}
