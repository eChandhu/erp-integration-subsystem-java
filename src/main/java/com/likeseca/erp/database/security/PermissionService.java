package com.likeseca.erp.database.security;

import com.likeseca.erp.database.exception.ExceptionCode;
import com.likeseca.erp.database.exception.LocalExceptionHandler;
import com.likeseca.erp.database.model.SubsystemId;

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
    private final LocalExceptionHandler exceptions = new LocalExceptionHandler();

    public CrudPermission loadPermission(Connection connection, SubsystemId subsystem, String tableName) throws SQLException {
        String sql = """
                SELECT can_create, can_read, can_update, can_delete, readable_columns, writable_columns
                FROM permission_matrix pm
                JOIN integration_registry ir ON ir.subsystem_id = pm.subsystem_id
                WHERE ir.subsystem_name = ? AND pm.resource_table = ?
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, subsystem.permissionName());
            statement.setString(2, tableName);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    throw exceptions.accessFailure(
                            ExceptionCode.UNAUTHORIZED_TABLE_ACCESS,
                            "Subsystem %s cannot access table %s.".formatted(subsystem.displayName(), tableName)
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

    public void assertTableAccess(CrudPermission permission, SubsystemId subsystem, String tableName, CrudAction action) {
        if (!permission.allows(action)) {
            throw exceptions.accessFailure(
                    ExceptionCode.UNAUTHORIZED_TABLE_ACCESS,
                    "Subsystem %s is not allowed to %s on %s.".formatted(
                            subsystem.displayName(),
                            action.name().toLowerCase(Locale.ROOT),
                            tableName
                    )
            );
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
