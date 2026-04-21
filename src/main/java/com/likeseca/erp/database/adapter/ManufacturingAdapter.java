package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class ManufacturingAdapter extends AbstractSubsystemAdapter {
    public ManufacturingAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.MANUFACTURING, operations);
    }
}
