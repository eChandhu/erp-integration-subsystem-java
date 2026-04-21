package com.likeseca.erp.database.adapter;

import com.likeseca.erp.database.model.SubsystemId;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class ProjectManagementAdapter extends AbstractSubsystemAdapter {
    public ProjectManagementAdapter(PermissionAwareOperations operations) {
        super(SubsystemId.PROJECT_MANAGEMENT, operations);
    }
}
