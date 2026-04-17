package com.erp.sdk.subsystem;

import com.erp.sdk.backup.BackupAdapter;
import com.erp.sdk.db.ConnectionManager;
import com.erp.sdk.logging.AuditLogger;
import com.erp.sdk.security.PermissionService;

public final class OrderProcessing extends AbstractSubsystem {
    public OrderProcessing(ConnectionManager connectionManager, PermissionService permissionService, AuditLogger auditLogger, BackupAdapter backupAdapter) {
        super(SubsystemName.ORDER_PROCESSING, connectionManager, permissionService, auditLogger, backupAdapter);
    }
}
