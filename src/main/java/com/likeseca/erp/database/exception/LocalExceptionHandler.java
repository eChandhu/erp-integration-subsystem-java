package com.likeseca.erp.database.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.SQLException;

public final class LocalExceptionHandler {
    private static final Logger LOGGER = LoggerFactory.getLogger(LocalExceptionHandler.class);

    public void log(String operation, ExceptionCode code, String message, Throwable cause) {
        if (cause == null) {
            LOGGER.error("[{}] {} - {}", code, operation, message);
        } else {
            LOGGER.error("[{}] {} - {}", code, operation, message, cause);
        }
    }

    public DatabaseModuleException configurationFailure(String message) {
        log("CONFIGURATION", ExceptionCode.INVALID_CONFIGURATION, message, null);
        return new DatabaseModuleException(ExceptionCode.INVALID_CONFIGURATION, message);
    }

    public DatabaseModuleException bootstrapFailure(String message, Throwable cause) {
        log("BOOTSTRAP", ExceptionCode.SCHEMA_BOOTSTRAP_FAILED, message, cause);
        return new DatabaseModuleException(ExceptionCode.SCHEMA_BOOTSTRAP_FAILED, message, cause);
    }

    public DatabaseModuleException accessFailure(ExceptionCode code, String message) {
        log("ACCESS", code, message, null);
        return new DatabaseModuleException(code, message);
    }

    public DatabaseModuleException sqlFailure(String operation, SQLException exception, String subject) {
        ExceptionCode code = classify(exception);
        String message = switch (code) {
            case DB_AUTHENTICATION_FAILED -> "MySQL authentication failed for " + subject + ".";
            case DB_HOST_NOT_FOUND -> "MySQL host could not be reached for " + subject + ".";
            case DB_TIMEOUT -> "MySQL operation timed out for " + subject + ".";
            case MAX_CONNECTIONS_EXCEEDED -> "MySQL refused the connection because the connection limit was exceeded.";
            case TABLE_NOT_FOUND -> "Required table or view was not found while processing " + subject + ".";
            case DUPLICATE_KEY -> "Duplicate key detected while processing " + subject + ".";
            case FOREIGN_KEY_VIOLATION -> "Foreign key constraint failed while processing " + subject + ".";
            case NULL_CONSTRAINT_VIOLATION -> "A required value was null while processing " + subject + ".";
            case DB_CONNECTION_FAILED -> "Unable to connect to MySQL for " + subject + ".";
            default -> "Database operation failed while processing " + subject + ".";
        };
        log(operation, code, message, exception);
        return new DatabaseModuleException(code, message, exception);
    }

    private ExceptionCode classify(SQLException exception) {
        String message = exception.getMessage();
        if (message == null) {
            return ExceptionCode.GENERIC_SQL_FAILURE;
        }
        String normalized = message.toLowerCase();
        if (normalized.contains("access denied")) {
            return ExceptionCode.DB_AUTHENTICATION_FAILED;
        }
        if (normalized.contains("unknown host") || normalized.contains("host not found")) {
            return ExceptionCode.DB_HOST_NOT_FOUND;
        }
        if (normalized.contains("timeout") || normalized.contains("timed out")) {
            return ExceptionCode.DB_TIMEOUT;
        }
        if (normalized.contains("too many connections") || normalized.contains("max_connections")) {
            return ExceptionCode.MAX_CONNECTIONS_EXCEEDED;
        }
        if (normalized.contains("doesn't exist") || normalized.contains("unknown table") || normalized.contains("unknown database")) {
            return ExceptionCode.TABLE_NOT_FOUND;
        }
        if (normalized.contains("duplicate entry") || normalized.contains("duplicate key")) {
            return ExceptionCode.DUPLICATE_KEY;
        }
        if (normalized.contains("foreign key")) {
            return ExceptionCode.FOREIGN_KEY_VIOLATION;
        }
        if (normalized.contains("cannot be null") || normalized.contains("not null")) {
            return ExceptionCode.NULL_CONSTRAINT_VIOLATION;
        }
        if (normalized.contains("connection") || normalized.contains("communications link failure")) {
            return ExceptionCode.DB_CONNECTION_FAILED;
        }
        return ExceptionCode.GENERIC_SQL_FAILURE;
    }
}
