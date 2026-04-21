package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class DatabaseIntegrationAdapter extends AbstractSubsystemAdapter {
    public DatabaseIntegrationAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.DATABASE_INTEGRATION, operations);
    }
}
