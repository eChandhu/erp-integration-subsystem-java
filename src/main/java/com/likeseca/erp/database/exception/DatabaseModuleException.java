package com.likeseca.erp.database.exception;

public class DatabaseModuleException extends RuntimeException {
    private final ExceptionCode code;

    public DatabaseModuleException(ExceptionCode code, String message) {
        super(message);
        this.code = code;
    }

    public DatabaseModuleException(ExceptionCode code, String message, Throwable cause) {
        super(message, cause);
        this.code = code;
    }

    public ExceptionCode getCode() {
        return code;
    }
}
