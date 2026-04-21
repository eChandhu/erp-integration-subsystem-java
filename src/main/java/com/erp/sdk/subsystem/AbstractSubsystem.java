package com.erp.sdk.subsystem;

import com.erp.sdk.backup.BackupAdapter;
import com.erp.sdk.context.AccessContext;
import com.erp.sdk.db.ConnectionManager;
import com.erp.sdk.exception.DatabaseOperationException;
import com.erp.sdk.exception.LocalExceptionHandler;
import com.erp.sdk.logging.AuditLogger;
import com.erp.sdk.security.CrudAction;
import com.erp.sdk.security.CrudPermission;
import com.erp.sdk.security.PermissionService;
import com.erp.sdk.sql.JoinRequest;
import com.erp.sdk.sql.SqlBuilder;

import java.nio.file.Path;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

public abstract class AbstractSubsystem implements AutoCloseable {
    private final SubsystemName subsystemName;
    private final ConnectionManager connectionManager;
    private final PermissionService permissionService;
    private final AuditLogger auditLogger;
    private final BackupAdapter backupAdapter;

    protected AbstractSubsystem(SubsystemName subsystemName,
                                ConnectionManager connectionManager,
                                PermissionService permissionService,
                                AuditLogger auditLogger,
                                BackupAdapter backupAdapter) {
        this.subsystemName = subsystemName;
        this.connectionManager = connectionManager;
        this.permissionService = permissionService;
        this.auditLogger = auditLogger;
        this.backupAdapter = backupAdapter;
    }

    public long create(String tableName, Map<String, Object> payload, String username) {
        return execute(tableName, "INSERT", username, connection -> {
            AccessContext context = new AccessContext(subsystemName, username);
            CrudPermission permission = permissionService.loadPermission(connection, context, tableName);
            permissionService.assertTableAccess(permission, context, tableName, CrudAction.CREATE);
            assertAllowedColumns(payload.keySet(), permission.writableColumns(), "write");
            Map<String, Object> writablePayload = filterAllowedColumns(payload, permission.writableColumns());
            String sql = SqlBuilder.buildInsert(tableName, new ArrayList<>(writablePayload.keySet()));
            try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                bindValues(statement, writablePayload.values().stream().toList(), 1);
                statement.executeUpdate();
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    return generatedKeys.next() ? generatedKeys.getLong(1) : -1L;
                }
            }
        });
    }

    public List<Map<String, Object>> readAll(String tableName, Map<String, Object> filters, String username) {
        return execute(tableName, "SELECT_ALL", username, connection -> {
            AccessContext context = new AccessContext(subsystemName, username);
            CrudPermission permission = permissionService.loadPermission(connection, context, tableName);
            permissionService.assertTableAccess(permission, context, tableName, CrudAction.READ);
            assertAllowedColumns(filters.keySet(), permission.readableColumns(), "filter");
            List<String> columns = permission.readableColumns().stream().sorted().toList();
            String sql = SqlBuilder.buildSelectAll(tableName, columns, filters);
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                bindValues(statement, filters.values().stream().toList(), 1);
                try (ResultSet resultSet = statement.executeQuery()) {
                    return toRows(resultSet);
                }
            }
        });
    }

    public Map<String, Object> readById(String tableName, String idColumn, Object idValue, String username) {
        return execute(tableName, "SELECT_BY_ID", username, connection -> {
            AccessContext context = new AccessContext(subsystemName, username);
            CrudPermission permission = permissionService.loadPermission(connection, context, tableName);
            permissionService.assertTableAccess(permission, context, tableName, CrudAction.READ);
            assertAllowedColumns(Set.of(idColumn), permission.readableColumns(), "read");
            String sql = SqlBuilder.buildSelectById(tableName, permission.readableColumns().stream().sorted().toList(), idColumn);
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setObject(1, idValue);
                try (ResultSet resultSet = statement.executeQuery()) {
                    List<Map<String, Object>> rows = toRows(resultSet);
                    return rows.isEmpty() ? Map.of() : rows.get(0);
                }
            }
        });
    }

    public int update(String tableName, String idColumn, Object idValue, Map<String, Object> payload, String username) {
        return execute(tableName, "UPDATE", username, connection -> {
            AccessContext context = new AccessContext(subsystemName, username);
            CrudPermission permission = permissionService.loadPermission(connection, context, tableName);
            permissionService.assertTableAccess(permission, context, tableName, CrudAction.UPDATE);
            assertAllowedColumns(payload.keySet(), permission.writableColumns(), "write");
            assertAllowedColumns(Set.of(idColumn), permission.readableColumns(), "read");
            Map<String, Object> writablePayload = filterAllowedColumns(payload, permission.writableColumns());
            String sql = SqlBuilder.buildUpdate(tableName, new ArrayList<>(writablePayload.keySet()), idColumn);
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                int nextIndex = bindValues(statement, writablePayload.values().stream().toList(), 1);
                statement.setObject(nextIndex, idValue);
                return statement.executeUpdate();
            }
        });
    }

    public int delete(String tableName, String idColumn, Object idValue, String username) {
        return execute(tableName, "DELETE", username, connection -> {
            AccessContext context = new AccessContext(subsystemName, username);
            CrudPermission permission = permissionService.loadPermission(connection, context, tableName);
            permissionService.assertTableAccess(permission, context, tableName, CrudAction.DELETE);
            assertAllowedColumns(Set.of(idColumn), permission.readableColumns(), "read");
            try (PreparedStatement statement = connection.prepareStatement(SqlBuilder.buildDelete(tableName, idColumn))) {
                statement.setObject(1, idValue);
                return statement.executeUpdate();
            }
        });
    }

    public List<Map<String, Object>> join(JoinRequest request, String username) {
        return execute(request.leftTable() + "_join_" + request.rightTable(), "JOIN_READ", username, connection -> {
            AccessContext context = new AccessContext(subsystemName, username);
            CrudPermission leftPermission = permissionService.loadPermission(connection, context, request.leftTable());
            CrudPermission rightPermission = permissionService.loadPermission(connection, context, request.rightTable());
            permissionService.assertTableAccess(leftPermission, context, request.leftTable(), CrudAction.READ);
            permissionService.assertTableAccess(rightPermission, context, request.rightTable(), CrudAction.READ);
            assertJoinColumnsAllowed(request, leftPermission, rightPermission);
            request.selectedColumns().forEach(this::validateQualifiedColumn);

            String selectedColumns = String.join(", ", request.selectedColumns());
            StringBuilder sql = new StringBuilder("""
                    SELECT %s
                    FROM %s l
                    JOIN %s r ON l.%s = r.%s
                    """.formatted(
                    selectedColumns,
                    request.leftTable(),
                    request.rightTable(),
                    request.leftJoinColumn(),
                    request.rightJoinColumn()
            ));
            if (!request.filters().isEmpty()) {
                sql.append(" WHERE ");
                sql.append(request.filters().keySet().stream().map(key -> key + " = ?").collect(Collectors.joining(" AND ")));
            }
            try (PreparedStatement statement = connection.prepareStatement(sql.toString())) {
                bindValues(statement, request.filters().values().stream().toList(), 1);
                try (ResultSet resultSet = statement.executeQuery()) {
                    return toRows(resultSet);
                }
            }
        });
    }

    public Path backupDatabase(String username) {
        return execute("database", "BACKUP", username, connection -> {
            if (!permissionService.isAdmin(connection, username)) {
                throw new SQLException("Only admin users can back up the database.");
            }
            return backupAdapter.backupDatabase(username);
        });
    }

    public void restoreDatabase(String username, Path backupPath) {
        execute("database", "RESTORE", username, connection -> {
            if (!permissionService.isAdmin(connection, username)) {
                throw new SQLException("Only admin users can restore the database.");
            }
            backupAdapter.restoreDatabase(username, backupPath);
            return null;
        });
    }

    private Map<String, Object> filterAllowedColumns(Map<String, Object> payload, Set<String> allowedColumns) {
        Objects.requireNonNull(payload, "payload cannot be null");
        return payload.entrySet().stream()
                .filter(entry -> allowedColumns.contains(entry.getKey()))
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (left, right) -> right,
                        LinkedHashMap::new
                ));
    }

    private void assertAllowedColumns(Set<String> requestedColumns, Set<String> allowedColumns, String operation) {
        if (requestedColumns == null || requestedColumns.isEmpty()) {
            return;
        }
        List<String> disallowed = requestedColumns.stream()
                .filter(column -> !allowedColumns.contains(column))
                .sorted()
                .toList();
        if (!disallowed.isEmpty()) {
            throw new IllegalArgumentException(
                    "Subsystem %s is not allowed to %s columns %s."
                            .formatted(subsystemName.dbValue(), operation, disallowed)
            );
        }
    }

    private void assertJoinColumnsAllowed(JoinRequest request,
                                          CrudPermission leftPermission,
                                          CrudPermission rightPermission) {
        if (!leftPermission.readableColumns().contains(request.leftJoinColumn())) {
            throw new IllegalArgumentException("Left join column is not readable: " + request.leftJoinColumn());
        }
        if (!rightPermission.readableColumns().contains(request.rightJoinColumn())) {
            throw new IllegalArgumentException("Right join column is not readable: " + request.rightJoinColumn());
        }
        assertAllowedColumns(request.filters().keySet(), union(leftPermission.readableColumns(), rightPermission.readableColumns()), "filter");
    }

    private Set<String> union(Set<String> left, Set<String> right) {
        return java.util.stream.Stream.concat(left.stream(), right.stream()).collect(Collectors.toSet());
    }

    private void validateQualifiedColumn(String column) {
        if (column == null || !column.matches("[lr]\\.[A-Za-z_][A-Za-z0-9_]*")) {
            throw new IllegalArgumentException("Invalid selected column in join request: " + column);
        }
    }

    private int bindValues(PreparedStatement statement, List<Object> values, int startIndex) throws SQLException {
        int index = startIndex;
        for (Object value : values) {
            statement.setObject(index++, value);
        }
        return index;
    }

    private List<Map<String, Object>> toRows(ResultSet resultSet) throws SQLException {
        List<Map<String, Object>> rows = new ArrayList<>();
        ResultSetMetaData metadata = resultSet.getMetaData();
        while (resultSet.next()) {
            Map<String, Object> row = new LinkedHashMap<>();
            for (int index = 1; index <= metadata.getColumnCount(); index++) {
                row.put(metadata.getColumnLabel(index), resultSet.getObject(index));
            }
            rows.add(row);
        }
        return rows;
    }

    private <T> T execute(String tableName, String action, String username, SqlWork<T> work) {
        AccessContext context = new AccessContext(subsystemName, username);
        try (Connection connection = connectionManager.getConnection()) {
            try {
                T result = work.apply(connection);
                auditLogger.log(connection, context, action, tableName, true, "Operation completed.", null);
                connection.commit();
                return result;
            } catch (Exception exception) {
                connection.rollback();
                auditLogger.log(connection, context, action, tableName, false, "Operation failed.", exception.getMessage());
                connection.commit();
                throw exception;
            }
        } catch (Exception exception) {
            if (exception instanceof SQLException sqlException) {
                throw LocalExceptionHandler.mapSqlException("Database operation failed for " + action + " on " + tableName, sqlException);
            }
            if (exception instanceof RuntimeException runtimeException) {
                throw runtimeException;
            }
            throw new DatabaseOperationException("Database operation failed.", exception);
        }
    }

    @Override
    public void close() {
        connectionManager.close();
    }

    @FunctionalInterface
    private interface SqlWork<T> {
        T apply(Connection connection) throws Exception;
    }
}
