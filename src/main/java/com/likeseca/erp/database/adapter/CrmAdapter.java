package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class CrmAdapter extends AbstractSubsystemAdapter {
    public CrmAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.CRM, operations);
    }
}
