package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class AccountingAdapter extends AbstractSubsystemAdapter {
    public AccountingAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.ACCOUNTING, operations);
    }
}
