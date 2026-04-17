package com.erp.sdk.subsystem;

import com.erp.sdk.backup.BackupAdapter;
import com.erp.sdk.db.ConnectionManager;
import com.erp.sdk.logging.AuditLogger;
import com.erp.sdk.security.PermissionService;

public final class BusinessControl extends AbstractSubsystem {
    public BusinessControl(ConnectionManager connectionManager, PermissionService permissionService, AuditLogger auditLogger, BackupAdapter backupAdapter) {
        super(SubsystemName.BUSINESS_CONTROL, connectionManager, permissionService, auditLogger, backupAdapter);
    }
}
