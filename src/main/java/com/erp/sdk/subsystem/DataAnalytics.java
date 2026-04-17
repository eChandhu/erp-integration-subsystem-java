package com.erp.sdk.subsystem;

import com.erp.sdk.backup.BackupAdapter;
import com.erp.sdk.db.ConnectionManager;
import com.erp.sdk.logging.AuditLogger;
import com.erp.sdk.security.PermissionService;

public final class DataAnalytics extends AbstractSubsystem {
    public DataAnalytics(ConnectionManager connectionManager, PermissionService permissionService, AuditLogger auditLogger, BackupAdapter backupAdapter) {
        super(SubsystemName.DATA_ANALYTICS, connectionManager, permissionService, auditLogger, backupAdapter);
    }
}
