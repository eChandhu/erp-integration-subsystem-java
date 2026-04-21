package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class SupplyChainAdapter extends AbstractSubsystemAdapter {
    public SupplyChainAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.SUPPLY_CHAIN, operations);
    }
}
