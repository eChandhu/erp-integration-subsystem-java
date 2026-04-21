package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class UiAdapter extends AbstractSubsystemAdapter {
    public UiAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.UI, operations);
    }
}
