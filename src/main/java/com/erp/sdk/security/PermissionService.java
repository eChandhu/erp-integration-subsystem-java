package com.erp.sdk.security;

import com.erp.sdk.context.AccessContext;
import com.erp.sdk.exception.UnauthorizedResourceAccessException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Collections;
import java.util.Locale;
import java.util.Set;
import java.util.stream.Collectors;

public final class PermissionService {
    public CrudPermission loadPermission(Connection connection, AccessContext context, String tableName) throws SQLException {
        String sql = """
                SELECT can_create, can_read, can_update, can_delete, readable_columns, writable_columns
                FROM permission_matrix pm
                JOIN integration_registry ir ON ir.subsystem_id = pm.subsystem_id
                WHERE ir.subsystem_name = ? AND pm.resource_table = ?
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, context.subsystem().dbValue());
            statement.setString(2, tableName);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw new UnauthorizedResourceAccessException(
                            "Subsystem %s cannot access table %s.".formatted(context.subsystem().dbValue(), tableName)
                    );
                }
                return new CrudPermission(
                        resultSet.getBoolean("can_create"),
                        resultSet.getBoolean("can_read"),
                        resultSet.getBoolean("can_update"),
                        resultSet.getBoolean("can_delete"),
                        parseJsonArray(resultSet.getString("readable_columns")),
                        parseJsonArray(resultSet.getString("writable_columns"))
                );
            }
        }
    }

    public void assertTableAccess(CrudPermission permission, AccessContext context, String tableName, CrudAction action) {
        if (!permission.allows(action)) {
            throw new UnauthorizedResourceAccessException(
                    "Subsystem %s is not allowed to %s on %s."
                            .formatted(context.subsystem().dbValue(), action.name().toLowerCase(Locale.ROOT), tableName)
            );
        }
    }

    public boolean isAdmin(Connection connection, String username) throws SQLException {
        String sql = """
                SELECT COUNT(*) AS count_value
                FROM users u
                JOIN roles r ON r.role_id = u.role_id
                WHERE u.username = ? AND LOWER(r.role_name) LIKE '%admin%'
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                return resultSet.getInt("count_value") > 0;
            }
        }
    }

    private Set<String> parseJsonArray(String json) {
        if (json == null || json.isBlank() || "[]".equals(json.trim())) {
            return Collections.emptySet();
        }
        String normalized = json.trim().replace("[", "").replace("]", "").replace("\"", "");
        if (normalized.isBlank()) {
            return Collections.emptySet();
        }
        return Arrays.stream(normalized.split(","))
                .map(String::trim)
                .filter(value -> !value.isEmpty())
                .collect(Collectors.toUnmodifiableSet());
    }
}
