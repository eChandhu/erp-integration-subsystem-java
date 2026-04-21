package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class AutomationAdapter extends AbstractSubsystemAdapter {
    public AutomationAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.AUTOMATION, operations);
    }
}
