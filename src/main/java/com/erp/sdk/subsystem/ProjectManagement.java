package com.erp.sdk.subsystem;

import com.erp.sdk.backup.BackupAdapter;
import com.erp.sdk.db.ConnectionManager;
import com.erp.sdk.logging.AuditLogger;
import com.erp.sdk.security.PermissionService;

public final class ProjectManagement extends AbstractSubsystem {
    public ProjectManagement(ConnectionManager connectionManager, PermissionService permissionService, AuditLogger auditLogger, BackupAdapter backupAdapter) {
        super(SubsystemName.PROJECT_MANAGEMENT, connectionManager, permissionService, auditLogger, backupAdapter);
    }
}
