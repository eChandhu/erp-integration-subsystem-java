package com.erp.sdk.exception;

public class DatabaseOperationException extends RuntimeException {
    private final ExceptionCode code;

    public DatabaseOperationException(String message, Throwable cause) {
        super(message, cause);
        this.code = ExceptionCode.SQL_OPERATION_FAILED;
    }

    public DatabaseOperationException(String message, Throwable cause, ExceptionCode code) {
        super(message, cause);
        this.code = code;
    }

    public ExceptionCode code() {
        return code;
    }
}
