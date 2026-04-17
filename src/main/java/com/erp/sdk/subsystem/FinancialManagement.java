package com.erp.sdk.subsystem;

import com.erp.sdk.backup.BackupAdapter;
import com.erp.sdk.db.ConnectionManager;
import com.erp.sdk.logging.AuditLogger;
import com.erp.sdk.security.PermissionService;

public final class FinancialManagement extends AbstractSubsystem {
    public FinancialManagement(ConnectionManager connectionManager, PermissionService permissionService, AuditLogger auditLogger, BackupAdapter backupAdapter) {
        super(SubsystemName.FINANCIAL_MANAGEMENT, connectionManager, permissionService, auditLogger, backupAdapter);
    }
}
