package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class BusinessIntelligenceAdapter extends AbstractSubsystemAdapter {
    public BusinessIntelligenceAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.BUSINESS_INTELLIGENCE, operations);
    }
}
