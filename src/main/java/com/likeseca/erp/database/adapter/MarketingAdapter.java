package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class MarketingAdapter extends AbstractSubsystemAdapter {
    public MarketingAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.MARKETING, operations);
    }
}
