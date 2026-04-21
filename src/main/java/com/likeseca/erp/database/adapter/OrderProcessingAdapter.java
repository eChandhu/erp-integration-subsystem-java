package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class OrderProcessingAdapter extends AbstractSubsystemAdapter {
    public OrderProcessingAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.ORDER_PROCESSING, operations);
    }
}
