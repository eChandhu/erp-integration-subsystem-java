package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class ReportingAdapter extends AbstractSubsystemAdapter {
    public ReportingAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.REPORTING, operations);
    }
}
