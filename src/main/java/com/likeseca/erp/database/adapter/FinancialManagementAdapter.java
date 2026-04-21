package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class FinancialManagementAdapter extends AbstractSubsystemAdapter {
    public FinancialManagementAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.FINANCIAL_MANAGEMENT, operations);
    }
}
