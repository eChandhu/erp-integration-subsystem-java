package com.likeseca.erp.database.service;

import com.likeseca.erp.database.exception.ExceptionCode;
import com.likeseca.erp.database.exception.LocalExceptionHandler;
import com.likeseca.erp.database.model.JoinSpec;
import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.security.CrudAction;
import com.likeseca.erp.database.security.CrudPermission;
import com.likeseca.erp.database.security.PermissionService;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

public class PermissionAwareOperations {
    private final PermissionService permissionService;
    private final JdbcOperations jdbcOperations;
    private final LocalExceptionHandler exceptions;

    public PermissionAwareOperations(PermissionService permissionService, JdbcOperations jdbcOperations) {
        this.permissionService = permissionService;
        this.jdbcOperations = jdbcOperations;
        this.exceptions = new LocalExceptionHandler();
    }

    public long create(SubsystemId subsystem, String tableName, Map<String, Object> payload) {
        Connection connection = null;
        try {
            connection = com.likeseca.erp.database.config.DatabaseConnectionManager.getInstance().getConnection();
            CrudPermission permission = permissionService.loadPermission(connection, subsystem, tableName);
            permissionService.assertTableAccess(permission, subsystem, tableName, CrudAction.CREATE);
            assertAllowedColumns(subsystem, payload.keySet(), permission.writableColumns(), "write");

            Map<String, Object> writablePayload = filterAllowedColumns(payload, permission.writableColumns());
            String sql = buildInsert(tableName, new ArrayList<>(writablePayload.keySet()));
            try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                bind(statement, writablePayload.values().stream().toList(), 1);
                statement.executeUpdate();
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getLong(1);
                    }
                    return -1L;
                }
            }
        } catch (SQLException exception) {
            throw exceptions.sqlFailure("CREATE", exception, tableName);
        } finally {
            com.likeseca.erp.database.config.DatabaseConnectionManager.getInstance().releaseConnection(connection);
        }
    }

    public List<Map<String, Object>> readAll(SubsystemId subsystem, String tableName, Map<String, Object> filters) {
        Connection connection = null;
        try {
            connection = com.likeseca.erp.database.config.DatabaseConnectionManager.getInstance().getConnection();
            CrudPermission permission = permissionService.loadPermission(connection, subsystem, tableName);
            permissionService.assertTableAccess(permission, subsystem, tableName, CrudAction.READ);
            assertAllowedColumns(subsystem, filters.keySet(), permission.readableColumns(), "filter");
            String sql = buildSelect(tableName, permission.readableColumns().stream().sorted().toList(), filters);
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                bind(statement, filters.values().stream().toList(), 1);
                try (ResultSet resultSet = statement.executeQuery()) {
                    return jdbcOperations.mapRows(resultSet);
                }
            }
        } catch (SQLException exception) {
            throw exceptions.sqlFailure("READ_ALL", exception, tableName);
        } finally {
            com.likeseca.erp.database.config.DatabaseConnectionManager.getInstance().releaseConnection(connection);
        }
    }

    public Map<String, Object> readById(SubsystemId subsystem, String tableName, String idColumn, Object idValue) {
        List<Map<String, Object>> results = readAll(subsystem, tableName, Map.of(idColumn, idValue));
        return results.isEmpty() ? Map.of() : results.get(0);
    }

    public int update(SubsystemId subsystem, String tableName, String idColumn, Object idValue, Map<String, Object> payload) {
        Connection connection = null;
        try {
            connection = com.likeseca.erp.database.config.DatabaseConnectionManager.getInstance().getConnection();
            CrudPermission permission = permissionService.loadPermission(connection, subsystem, tableName);
            permissionService.assertTableAccess(permission, subsystem, tableName, CrudAction.UPDATE);
            assertAllowedColumns(subsystem, payload.keySet(), permission.writableColumns(), "write");
            assertAllowedColumns(subsystem, Set.of(idColumn), permission.readableColumns(), "read");
            Map<String, Object> writablePayload = filterAllowedColumns(payload, permission.writableColumns());
            String sql = buildUpdate(tableName, new ArrayList<>(writablePayload.keySet()), idColumn);
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                int next = bind(statement, writablePayload.values().stream().toList(), 1);
                statement.setObject(next, idValue);
                return statement.executeUpdate();
            }
        } catch (SQLException exception) {
            throw exceptions.sqlFailure("UPDATE", exception, tableName);
        } finally {
            com.likeseca.erp.database.config.DatabaseConnectionManager.getInstance().releaseConnection(connection);
        }
    }

    public int delete(SubsystemId subsystem, String tableName, String idColumn, Object idValue) {
        Connection connection = null;
        try {
            connection = com.likeseca.erp.database.config.DatabaseConnectionManager.getInstance().getConnection();
            CrudPermission permission = permissionService.loadPermission(connection, subsystem, tableName);
            permissionService.assertTableAccess(permission, subsystem, tableName, CrudAction.DELETE);
            assertAllowedColumns(subsystem, Set.of(idColumn), permission.readableColumns(), "read");
            try (PreparedStatement statement = connection.prepareStatement("DELETE FROM " + tableName + " WHERE " + idColumn + " = ?")) {
                statement.setObject(1, idValue);
                return statement.executeUpdate();
            }
        } catch (SQLException exception) {
            throw exceptions.sqlFailure("DELETE", exception, tableName);
        } finally {
            com.likeseca.erp.database.config.DatabaseConnectionManager.getInstance().releaseConnection(connection);
        }
    }

    public List<Map<String, Object>> join(SubsystemId subsystem, JoinSpec joinSpec) {
        Connection connection = null;
        try {
            connection = com.likeseca.erp.database.config.DatabaseConnectionManager.getInstance().getConnection();
            CrudPermission leftPermission = permissionService.loadPermission(connection, subsystem, joinSpec.leftTable());
            CrudPermission rightPermission = permissionService.loadPermission(connection, subsystem, joinSpec.rightTable());
            permissionService.assertTableAccess(leftPermission, subsystem, joinSpec.leftTable(), CrudAction.READ);
            permissionService.assertTableAccess(rightPermission, subsystem, joinSpec.rightTable(), CrudAction.READ);
            assertJoinColumnsAllowed(subsystem, joinSpec, leftPermission, rightPermission);

            String selectedColumns = String.join(", ", joinSpec.selectedColumns());
            StringBuilder sql = new StringBuilder("""
                    SELECT %s
                    FROM %s l
                    JOIN %s r ON l.%s = r.%s
                    """.formatted(
                    selectedColumns,
                    joinSpec.leftTable(),
                    joinSpec.rightTable(),
                    joinSpec.leftJoinColumn(),
                    joinSpec.rightJoinColumn()
            ));
            if (!joinSpec.filters().isEmpty()) {
                sql.append(" WHERE ");
                sql.append(joinSpec.filters().keySet().stream().map(key -> key + " = ?").collect(Collectors.joining(" AND ")));
            }
            try (PreparedStatement statement = connection.prepareStatement(sql.toString())) {
                bind(statement, joinSpec.filters().values().stream().toList(), 1);
                try (ResultSet resultSet = statement.executeQuery()) {
                    return jdbcOperations.mapRows(resultSet);
                }
            }
        } catch (SQLException exception) {
            throw exceptions.sqlFailure("JOIN", exception, joinSpec.leftTable() + "_join_" + joinSpec.rightTable());
        }
    }

    private void assertJoinColumnsAllowed(SubsystemId subsystem, JoinSpec request, CrudPermission leftPermission, CrudPermission rightPermission) {
        if (!leftPermission.readableColumns().contains(request.leftJoinColumn())) {
            throw exceptions.accessFailure(ExceptionCode.UNAUTHORIZED_COLUMN_ACCESS, "Left join column is not readable for " + subsystem.displayName());
        }
        if (!rightPermission.readableColumns().contains(request.rightJoinColumn())) {
            throw exceptions.accessFailure(ExceptionCode.UNAUTHORIZED_COLUMN_ACCESS, "Right join column is not readable for " + subsystem.displayName());
        }
        assertAllowedColumns(
                subsystem,
                request.filters().keySet(),
                union(leftPermission.readableColumns(), rightPermission.readableColumns()),
                "filter"
        );
    }

    private Set<String> union(Set<String> left, Set<String> right) {
        return java.util.stream.Stream.concat(left.stream(), right.stream()).collect(Collectors.toSet());
    }

    private Map<String, Object> filterAllowedColumns(Map<String, Object> payload, Set<String> allowedColumns) {
        Objects.requireNonNull(payload, "payload");
        return payload.entrySet().stream()
                .filter(entry -> allowedColumns.contains(entry.getKey()))
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (left, right) -> right,
                        LinkedHashMap::new
                ));
    }

    private void assertAllowedColumns(SubsystemId subsystem, Set<String> requestedColumns, Set<String> allowedColumns, String operation) {
        if (requestedColumns == null || requestedColumns.isEmpty()) {
            return;
        }
        List<String> disallowed = requestedColumns.stream()
                .filter(column -> !allowedColumns.contains(column))
                .sorted()
                .toList();
        if (!disallowed.isEmpty()) {
            throw exceptions.accessFailure(
                    ExceptionCode.UNAUTHORIZED_COLUMN_ACCESS,
                    "Subsystem %s is not allowed to %s columns %s.".formatted(subsystem.displayName(), operation, disallowed)
            );
        }
    }

    private int bind(PreparedStatement statement, List<Object> values, int startIndex) throws SQLException {
        int index = startIndex;
        for (Object value : values) {
            statement.setObject(index++, value);
        }
        return index;
    }

    private String buildInsert(String tableName, List<String> columns) {
        String joinedColumns = String.join(", ", columns);
        String placeholders = columns.stream().map(column -> "?").collect(Collectors.joining(", "));
        return "INSERT INTO " + tableName + " (" + joinedColumns + ") VALUES (" + placeholders + ")";
    }

    private String buildSelect(String tableName, List<String> columns, Map<String, Object> filters) {
        StringBuilder sql = new StringBuilder("SELECT ")
                .append(String.join(", ", columns))
                .append(" FROM ")
                .append(tableName);
        if (!filters.isEmpty()) {
            sql.append(" WHERE ");
            sql.append(filters.keySet().stream().map(key -> key + " = ?").collect(Collectors.joining(" AND ")));
        }
        return sql.toString();
    }

    private String buildUpdate(String tableName, List<String> columns, String idColumn) {
        String assignments = columns.stream()
                .map(column -> column + " = ?")
                .collect(Collectors.joining(", "));
        return "UPDATE " + tableName + " SET " + assignments + " WHERE " + idColumn + " = ?";
    }
}
