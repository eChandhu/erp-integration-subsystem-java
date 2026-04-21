package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class BusinessControlAdapter extends AbstractSubsystemAdapter {
    public BusinessControlAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.BUSINESS_CONTROL, operations);
    }
}
