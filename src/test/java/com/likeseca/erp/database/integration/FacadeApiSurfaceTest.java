package com.likeseca.erp.database.integration;

import com.likeseca.erp.database.facade.ErpDatabaseFacade;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertNotNull;

class FacadeApiSurfaceTest {

    @BeforeAll
    static void configureDefaults() {
        TestDatabaseDefaults.configureFreshSchema();
    }

    @Test
    void facadeExposesSubsystemFacadeEntryPoints() {
        try (ErpDatabaseFacade facade = new ErpDatabaseFacade()) {
            assertNotNull(facade.databaseIntegrationSubsystem());
            assertNotNull(facade.uiSubsystem());
            assertNotNull(facade.crmSubsystem());
            assertNotNull(facade.marketingSubsystem());
            assertNotNull(facade.salesManagementSubsystem());
            assertNotNull(facade.orderProcessingSubsystem());
            assertNotNull(facade.supplyChainSubsystem());
            assertNotNull(facade.manufacturingSubsystem());
            assertNotNull(facade.hrSubsystem());
            assertNotNull(facade.projectManagementSubsystem());
            assertNotNull(facade.reportingSubsystem());
            assertNotNull(facade.dataAnalyticsSubsystem());
            assertNotNull(facade.businessIntelligenceSubsystem());
            assertNotNull(facade.automationSubsystem());
            assertNotNull(facade.businessControlSubsystem());
            assertNotNull(facade.financialManagementSubsystem());
            assertNotNull(facade.accountingSubsystem());
        }
    }
}
