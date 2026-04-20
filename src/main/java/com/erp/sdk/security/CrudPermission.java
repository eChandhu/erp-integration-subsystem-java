package com.erp.sdk.security;

import java.util.Set;

public record CrudPermission(
        boolean canCreate,
        boolean canRead,
        boolean canUpdate,
        boolean canDelete,
        Set<String> readableColumns,
        Set<String> writableColumns
) {
    public boolean allows(CrudAction action) {
        return switch (action) {
            case CREATE -> canCreate;
            case READ -> canRead;
            case UPDATE -> canUpdate;
            case DELETE -> canDelete;
        };
    }
}
