package com.erp.sdk.exception;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Local exception logger used by this SDK.
 *
 * The reference project delegated exception handling to a separate subsystem
 * JAR. That is intentionally not part of this ERP distribution, so this class
 * records exception events inside the same local MySQL database that already
 * stores the business tables and audit logs.
 *
 * The logger keeps two layers of visibility:
 * 1. A concise System.err message for immediate feedback during local runs.
 * 2. A database row in {@code audit_logs} so the failure is visible beside the
 *    rest of the subsystem activity.
 */
public class ExceptionLogger {
    private static final String EXCEPTION_ACTION_PREFIX = "EXCEPTION:";
    
    /**
     * Logs an exception to the console and to {@code audit_logs}.
     *
     * The method is intentionally defensive: if database logging fails, the
     * console message still survives so developers do not lose the original
     * error context during local debugging.
     */
    public static void logException(Connection connection, int exceptionCode, 
                                   String subsystemName, String operation, 
                                   String tableName, String details, 
                                   String stackTrace) {
        logToSystemErr(exceptionCode, subsystemName, operation, tableName, details);

        try {
            logToDatabase(connection, exceptionCode, subsystemName, operation, 
                         tableName, details, stackTrace);
        } catch (SQLException e) {
            System.err.println("Failed to log exception to database: " + e.getMessage());
        }
    }

    private static void logToSystemErr(int exceptionCode, String subsystemName, 
                                       String operation, String tableName, String details) {
        String message = String.format(
            "[ERP-%04d] %s | Subsystem: %s | Operation: %s | Table: %s | %s",
            exceptionCode, 
            ExceptionSeverity.get(exceptionCode),
            subsystemName,
            operation,
            tableName,
            details
        );
        System.err.println(message);
    }

    private static void logToDatabase(Connection connection, int exceptionCode,
                                     String subsystemName, String operation,
                                     String tableName, String details,
                                     String stackTrace) throws SQLException {

        // Reuse the shipped audit table instead of inventing a separate schema
        // branch for exceptions. This keeps the SDK self-contained.
        String sql = """
                INSERT INTO audit_logs
                (action, performed_by, subsystem_name, resource_table, success, details, error_message, error_code)
                VALUES (?, NULL, ?, ?, FALSE, ?, ?, ?)
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, EXCEPTION_ACTION_PREFIX + operation);
            stmt.setString(2, subsystemName);
            stmt.setString(3, tableName);
            stmt.setString(4, details);
            stmt.setString(5, stackTrace);
            stmt.setString(6, String.valueOf(exceptionCode));
            stmt.executeUpdate();
        }
    }

    private static class ExceptionSeverity {
        static String get(int code) {
            if (code >= 100 && code < 200) return "CRITICAL";
            if (code >= 200 && code < 300) return "HIGH";
            if (code >= 300 && code < 400) return "HIGH";
            if (code >= 400 && code < 500) return "MEDIUM";
            if (code >= 500 && code < 600) return "MEDIUM";
            return "UNKNOWN";
        }
    }
}
