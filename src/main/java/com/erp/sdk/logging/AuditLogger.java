package com.erp.sdk.logging;

import com.erp.sdk.context.AccessContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public final class AuditLogger {
    private static final Logger LOGGER = LoggerFactory.getLogger(AuditLogger.class);

    public void log(Connection connection,
                    AccessContext context,
                    String action,
                    String resourceTable,
                    boolean success,
                    String details,
                    String errorMessage) {
        String sql = """
                INSERT INTO audit_logs
                (action, performed_by, subsystem_name, resource_table, success, details, error_message)
                VALUES (?, (SELECT user_id FROM users WHERE username = ?), ?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, action);
            statement.setString(2, context.username());
            statement.setString(3, context.subsystem().dbValue());
            statement.setString(4, resourceTable);
            statement.setBoolean(5, success);
            statement.setString(6, details);
            statement.setString(7, errorMessage);
            statement.executeUpdate();
        } catch (SQLException exception) {
            LOGGER.error("Unable to write audit log for {} on {}", action, resourceTable, exception);
        }
    }
}
