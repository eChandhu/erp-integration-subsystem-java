package com.erp.sdk.exception;

import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.SQLSyntaxErrorException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * ErpExceptionRegistry - Centralized exception code registry for ERP system
 * 
 * This registry defines 32+ exception types that can occur during database operations.
 * Each exception has a unique code, severity level, and recommended action.
 * 
 * Exception Code Structure:
 * 1XX - Connection Level Errors
 * 2XX - Data Integrity Errors
 * 3XX - Transaction/Concurrency Errors
 * 4XX - Validation Errors
 * 5XX - Authorization Errors
 * 6XX - System Errors
 * 
 * Each exception is logged locally without requiring an external system.
 * 
 * @author ERP Team
 * @version 2.0
 */
public class ErpExceptionRegistry {
    
    // Connection Level Exceptions (1XX)
    public static final int CONNECTION_TIMEOUT = 101;
    public static final int CONNECTION_REFUSED = 102;
    public static final int DATABASE_NOT_FOUND = 103;
    public static final int AUTHENTICATION_FAILED = 104;
    public static final int CONNECTION_POOL_EXHAUSTED = 105;
    public static final int NETWORK_ERROR = 106;
    
    // Data Integrity Exceptions (2XX)
    public static final int DUPLICATE_PRIMARY_KEY = 201;
    public static final int DUPLICATE_UNIQUE_KEY = 202;
    public static final int FOREIGN_KEY_VIOLATION = 203;
    public static final int NOT_NULL_VIOLATION = 204;
    public static final int CHECK_CONSTRAINT_VIOLATION = 205;
    public static final int REFERENTIAL_INTEGRITY_ERROR = 206;
    
    // Transaction/Concurrency Exceptions (3XX)
    public static final int DEADLOCK_DETECTED = 301;
    public static final int LOCK_WAIT_TIMEOUT = 302;
    public static final int TRANSACTION_ROLLBACK = 303;
    public static final int SAVEPOINT_ERROR = 304;
    public static final int SERIALIZATION_FAILURE = 305;
    
    // Validation Exceptions (4XX)
    public static final int DATA_TYPE_MISMATCH = 401;
    public static final int VALUE_OUT_OF_RANGE = 402;
    public static final int INVALID_COLUMN_NAME = 403;
    public static final int INVALID_TABLE_NAME = 404;
    public static final int TRUNCATED_INCORRECT_VALUE = 405;
    
    // Authorization/Permission Exceptions (5XX)
    public static final int PERMISSION_DENIED = 501;
    public static final int INSUFFICIENT_PRIVILEGES = 502;
    public static final int RECORD_NOT_FOUND = 503;
    public static final int SUBSYSTEM_NOT_AUTHORIZED = 504;
    public static final int ROW_ACCESS_DENIED = 505;
    
    // System Exceptions (6XX)
    public static final int DISK_FULL = 601;
    public static final int IO_ERROR = 602;
    public static final int SCHEMA_ERROR = 603;
    public static final int SQL_SYNTAX_ERROR = 604;
    public static final int UNKNOWN_ERROR = 605;
    
    /**
     * Exception metadata - code, severity, message, action
     */
    private static final Map<Integer, Map<String, Object>> EXCEPTION_METADATA = new HashMap<>();
    
    static {
        // Initialize exception metadata
        registerException(CONNECTION_TIMEOUT, "CRITICAL", 
            "Database connection timed out",
            "Check MySQL server status and network connectivity");
        
        registerException(CONNECTION_REFUSED, "CRITICAL",
            "Connection to database refused",
            "Verify MySQL server is running and accepting connections");
        
        registerException(DATABASE_NOT_FOUND, "CRITICAL",
            "Database does not exist",
            "Run schema bootstrapper or create database manually");
        
        registerException(AUTHENTICATION_FAILED, "CRITICAL",
            "Username or password incorrect",
            "Verify database credentials in configuration");
        
        registerException(CONNECTION_POOL_EXHAUSTED, "HIGH",
            "Connection pool size exceeded",
            "Increase db.pool.size or check for connection leaks");
        
        registerException(DUPLICATE_PRIMARY_KEY, "HIGH",
            "Duplicate primary key value",
            "Check that record ID is unique before insert");
        
        registerException(FOREIGN_KEY_VIOLATION, "HIGH",
            "Foreign key constraint violation",
            "Ensure referenced record exists in parent table");
        
        registerException(DEADLOCK_DETECTED, "HIGH",
            "Database deadlock detected",
            "Transaction will be retried automatically");
        
        registerException(PERMISSION_DENIED, "MEDIUM",
            "Permission matrix denies operation",
            "Contact administrator to grant subsystem permissions");
        
        registerException(RECORD_NOT_FOUND, "MEDIUM",
            "Requested record does not exist",
            "Verify record ID is correct");
    }
    
    /**
     * Registers an exception type in the registry
     * 
     * @param code Exception code
     * @param severity CRITICAL, HIGH, MEDIUM, LOW
     * @param message Human-readable message
     * @param action Recommended action to resolve
     */
    private static void registerException(int code, String severity, String message, String action) {
        Map<String, Object> metadata = new HashMap<>();
        metadata.put("code", code);
        metadata.put("severity", severity);
        metadata.put("message", message);
        metadata.put("action", action);
        EXCEPTION_METADATA.put(code, metadata);
    }
    
    /**
     * Gets exception metadata by code
     * 
     * @param code Exception code
     * @return Map with exception details
     */
    public static Map<String, Object> getExceptionMetadata(int code) {
        return EXCEPTION_METADATA.getOrDefault(code, getUnknownExceptionMetadata(code));
    }
    
    /**
     * Gets metadata for unknown exception code
     */
    private static Map<String, Object> getUnknownExceptionMetadata(int code) {
        Map<String, Object> metadata = new HashMap<>();
        metadata.put("code", code);
        metadata.put("severity", "UNKNOWN");
        metadata.put("message", "Unknown exception code: " + code);
        metadata.put("action", "Check logs for details");
        return metadata;
    }
    
    /**
     * Classifies SQL exception and returns appropriate ERP exception code
     * 
     * @param sqlException SQLException from database driver
     * @return ERP exception code
     */
    public static int classifyException(SQLException sqlException) {
        String errorMessage = sqlException.getMessage().toUpperCase();
        int vendorCode = sqlException.getErrorCode();
        
        // MySQL specific error codes
        if (vendorCode == 1062) {
            return DUPLICATE_UNIQUE_KEY;
        } else if (vendorCode == 1048) {
            return NOT_NULL_VIOLATION;
        } else if (vendorCode == 1452) {
            return FOREIGN_KEY_VIOLATION;
        } else if (vendorCode == 1213) {
            return DEADLOCK_DETECTED;
        } else if (vendorCode == 1205) {
            return LOCK_WAIT_TIMEOUT;
        } else if (vendorCode == 1366) {
            return DATA_TYPE_MISMATCH;
        }
        
        // Message-based classification
        if (errorMessage.contains("CONNECTION") || errorMessage.contains("TIMEOUT")) {
            return CONNECTION_TIMEOUT;
        } else if (errorMessage.contains("DENIED") || errorMessage.contains("PERMISSION")) {
            return PERMISSION_DENIED;
        } else if (errorMessage.contains("NOT FOUND") || errorMessage.contains("NO SUCH")) {
            return RECORD_NOT_FOUND;
        } else if (errorMessage.contains("SYNTAX")) {
            return SQL_SYNTAX_ERROR;
        } else if (errorMessage.contains("DEADLOCK")) {
            return DEADLOCK_DETECTED;
        }
        
        return UNKNOWN_ERROR;
    }
}
