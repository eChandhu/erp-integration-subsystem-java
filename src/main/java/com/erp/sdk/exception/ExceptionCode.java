package com.erp.sdk.exception;

/**
 * Local replacement for the separate exception subsystem used by the reference
 * project. Keeping these codes in this JAR means teams do not need any external
 * exception-handler dependency to understand common database failures.
 */
public enum ExceptionCode {
    DB_CONNECTION_FAILED,
    DB_TIMEOUT,
    DB_HOST_NOT_FOUND,
    DB_AUTHENTICATION_FAILED,
    DATABASE_NOT_FOUND,
    TABLE_NOT_FOUND,
    MAX_CONNECTIONS_EXCEEDED,
    SQL_OPERATION_FAILED
}
