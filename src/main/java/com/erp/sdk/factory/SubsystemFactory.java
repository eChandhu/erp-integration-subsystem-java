package com.erp.sdk.factory;

import com.erp.sdk.backup.MySqlBackupAdapter;
import com.erp.sdk.config.DatabaseConfig;
import com.erp.sdk.db.ConnectionManager;
import com.erp.sdk.logging.AuditLogger;
import com.erp.sdk.security.PermissionService;
import com.erp.sdk.subsystem.*;

public final class SubsystemFactory {
    private SubsystemFactory() {
    }

    /**
     * Convenience entry point for teams using only the distributed JAR. It uses
     * local MySQL defaults or a nearby application.properties file and still
     * bootstraps the schema before the subsystem object is returned.
     */
    public static AbstractSubsystem create(SubsystemName subsystemName) {
        return create(subsystemName, DatabaseConfig.load());
    }

    public static AbstractSubsystem create(SubsystemName subsystemName, DatabaseConfig config) {
        ConnectionManager connectionManager = new ConnectionManager(config);
        PermissionService permissionService = new PermissionService();
        AuditLogger auditLogger = new AuditLogger();
        MySqlBackupAdapter backupAdapter = new MySqlBackupAdapter(config);

        return switch (subsystemName) {
            case INTEGRATION -> new Integration(connectionManager, permissionService, auditLogger, backupAdapter);
            case UI -> new UI(connectionManager, permissionService, auditLogger, backupAdapter);
            case CRM -> new CRM(connectionManager, permissionService, auditLogger, backupAdapter);
            case MARKETING -> new Marketing(connectionManager, permissionService, auditLogger, backupAdapter);
            case SALES_MANAGEMENT -> new SalesManagement(connectionManager, permissionService, auditLogger, backupAdapter);
            case ORDER_PROCESSING -> new OrderProcessing(connectionManager, permissionService, auditLogger, backupAdapter);
            case SUPPLY_CHAIN -> new SupplyChain(connectionManager, permissionService, auditLogger, backupAdapter);
            case MANUFACTURING -> new Manufacturing(connectionManager, permissionService, auditLogger, backupAdapter);
            case HR -> new HR(connectionManager, permissionService, auditLogger, backupAdapter);
            case PROJECT_MANAGEMENT -> new ProjectManagement(connectionManager, permissionService, auditLogger, backupAdapter);
            case REPORTING -> new Reporting(connectionManager, permissionService, auditLogger, backupAdapter);
            case DATA_ANALYTICS -> new DataAnalytics(connectionManager, permissionService, auditLogger, backupAdapter);
            case BUSINESS_INTELLIGENCE -> new BusinessIntelligence(connectionManager, permissionService, auditLogger, backupAdapter);
            case AUTOMATION -> new Automation(connectionManager, permissionService, auditLogger, backupAdapter);
            case BUSINESS_CONTROL -> new BusinessControl(connectionManager, permissionService, auditLogger, backupAdapter);
            case FINANCIAL_MANAGEMENT -> new FinancialManagement(connectionManager, permissionService, auditLogger, backupAdapter);
        };
    }
}
