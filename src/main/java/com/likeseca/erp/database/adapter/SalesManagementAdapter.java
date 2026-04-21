package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class SalesManagementAdapter extends AbstractSubsystemAdapter {
    public SalesManagementAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.SALES_MANAGEMENT, operations);
    }
}
