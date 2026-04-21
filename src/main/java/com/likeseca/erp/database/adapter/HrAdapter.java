package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class HrAdapter extends AbstractSubsystemAdapter {
    public HrAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.HR, operations);
    }
}
