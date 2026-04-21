package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class DataAnalyticsAdapter extends AbstractSubsystemAdapter {
    public DataAnalyticsAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.DATA_ANALYTICS, operations);
    }
}
