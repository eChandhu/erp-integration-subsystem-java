package com.erp.sdk.exception;

import java.sql.SQLException;
import java.util.Locale;

/**
 * Converts JDBC driver messages into stable SDK exceptions. The older sample
 * project delegated this responsibility to an external exception subsystem JAR;
 * this ERP SDK owns the mapping locally because no separate exception JAR will
 * be distributed to other teams.
 */
public final class LocalExceptionHandler {
    private LocalExceptionHandler() {
    }

    public static DatabaseOperationException mapSqlException(String operation, SQLException exception) {
        ExceptionCode code = classify(exception);
        String message = "%s [%s]: %s".formatted(operation, code, exception.getMessage());
        return new DatabaseOperationException(message, exception, code);
    }

    private static ExceptionCode classify(SQLException exception) {
        String message = exception.getMessage() == null
                ? ""
                : exception.getMessage().toLowerCase(Locale.ROOT);
        String sqlState = exception.getSQLState() == null ? "" : exception.getSQLState();

        if (message.contains("access denied") || sqlState.startsWith("28")) {
            return ExceptionCode.DB_AUTHENTICATION_FAILED;
        }
        if (message.contains("unknown host") || message.contains("host not found")) {
            return ExceptionCode.DB_HOST_NOT_FOUND;
        }
        if (message.contains("unknown database")) {
            return ExceptionCode.DATABASE_NOT_FOUND;
        }
        if (message.contains("doesn't exist") || message.contains("unknown table")) {
            return ExceptionCode.TABLE_NOT_FOUND;
        }
        if (message.contains("max_connections") || message.contains("too many connections")) {
            return ExceptionCode.MAX_CONNECTIONS_EXCEEDED;
        }
        if (message.contains("timeout") || message.contains("timed out")) {
            return ExceptionCode.DB_TIMEOUT;
        }
        if (message.contains("connection refused") || message.contains("communications link failure")) {
            return ExceptionCode.DB_CONNECTION_FAILED;
        }
        return ExceptionCode.SQL_OPERATION_FAILED;
    }
}
