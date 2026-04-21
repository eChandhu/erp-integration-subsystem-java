package com.likeseca.erp.database.integration;

import com.likeseca.erp.database.facade.ErpDatabaseFacade;
import com.likeseca.erp.database.facade.subsystem.AbstractSubsystemFacade;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class AllSubsystemBehaviorSmokeTest {

    @BeforeAll
    static void configureDefaults() {
        TestDatabaseDefaults.configureFreshSchema();
    }

    @Test
    void databaseIntegrationSubsystemBehavior() {
        assertSubsystemBehavior(
                "Database Integration",
                ErpDatabaseFacade::databaseIntegrationSubsystem,
                List.of("integration_registry", "permission_matrix")
        );
    }

    @Test
    void uiSubsystemBehavior() {
        assertSubsystemBehavior(
                "UI",
                ErpDatabaseFacade::uiSubsystem,
                List.of("users", "orders")
        );
    }

    @Test
    void crmSubsystemBehavior() {
        assertSubsystemBehavior(
                "CRM",
                ErpDatabaseFacade::crmSubsystem,
                List.of("customers", "leads")
        );
    }

    @Test
    void marketingSubsystemBehavior() {
        assertSubsystemBehavior(
                "Marketing",
                ErpDatabaseFacade::marketingSubsystem,
                List.of("campaigns", "customer_segments")
        );
    }

    @Test
    void salesManagementSubsystemBehavior() {
        assertSubsystemBehavior(
                "Sales Management",
                ErpDatabaseFacade::salesManagementSubsystem,
                List.of("deals", "quotes")
        );
    }

    @Test
    void orderProcessingSubsystemBehavior() {
        assertSubsystemBehavior(
                "Order Processing",
                ErpDatabaseFacade::orderProcessingSubsystem,
                List.of("orders", "shipments")
        );
    }

    @Test
    void supplyChainSubsystemBehavior() {
        assertSubsystemBehavior(
                "Supply Chain",
                ErpDatabaseFacade::supplyChainSubsystem,
                List.of("suppliers", "purchase_orders")
        );
    }

    @Test
    void manufacturingSubsystemBehavior() {
        assertSubsystemBehavior(
                "Manufacturing",
                ErpDatabaseFacade::manufacturingSubsystem,
                List.of("manufactured_cars", "production_orders")
        );
    }

    @Test
    void hrSubsystemBehavior() {
        assertSubsystemBehavior(
                "HR",
                ErpDatabaseFacade::hrSubsystem,
                List.of("employees", "leave_requests")
        );
    }

    @Test
    void projectManagementSubsystemBehavior() {
        assertSubsystemBehavior(
                "Project Management",
                ErpDatabaseFacade::projectManagementSubsystem,
                List.of("project", "milestone")
        );
    }

    @Test
    void reportingSubsystemBehavior() {
        assertSubsystemBehavior(
                "Reporting",
                ErpDatabaseFacade::reportingSubsystem,
                List.of("reports", "report_templates")
        );
    }

    @Test
    void dataAnalyticsSubsystemBehavior() {
        assertSubsystemBehavior(
                "Data Analytics",
                ErpDatabaseFacade::dataAnalyticsSubsystem,
                List.of("kpis", "da_reports")
        );
    }

    @Test
    void businessIntelligenceSubsystemBehavior() {
        assertSubsystemBehavior(
                "Business Intelligence",
                ErpDatabaseFacade::businessIntelligenceSubsystem,
                List.of("dashboards", "dashboard_kpis")
        );
    }

    @Test
    void automationSubsystemBehavior() {
        assertSubsystemBehavior(
                "Automation",
                ErpDatabaseFacade::automationSubsystem,
                List.of("workflows", "customer_invoices")
        );
    }

    @Test
    void businessControlSubsystemBehavior() {
        assertSubsystemBehavior(
                "Business Control",
                ErpDatabaseFacade::businessControlSubsystem,
                List.of("approval_requests", "risk_records")
        );
    }

    @Test
    void financialManagementSubsystemBehavior() {
        assertSubsystemBehavior(
                "Financial Management",
                ErpDatabaseFacade::financialManagementSubsystem,
                List.of("accounts", "ledger")
        );
    }

    @Test
    void accountingSubsystemBehavior() {
        assertSubsystemBehavior(
                "Accounting",
                ErpDatabaseFacade::accountingSubsystem,
                List.of("ledger", "transactions")
        );
    }

    private void assertSubsystemBehavior(
            String subsystemName,
            Function<ErpDatabaseFacade, AbstractSubsystemFacade> accessor,
            List<String> representativeTables
    ) {
        try (ErpDatabaseFacade facade = new ErpDatabaseFacade()) {
            AbstractSubsystemFacade subsystemFacade = accessor.apply(facade);
            assertNotNull(subsystemFacade, subsystemName + " facade should be available");

            for (String table : representativeTables) {
                var rows = subsystemFacade.readAll(table, Map.of());
                assertNotNull(rows, subsystemName + " should return a list for " + table);
            }

            Map<String, Object> payload = new LinkedHashMap<>();
            payload.put("name", subsystemName + " Smoke Customer " + System.nanoTime());
            payload.put("email", subsystemName.replace(" ", "").toLowerCase() + "@likeseca.local");
            payload.put("status", "ACTIVE");

            long customerId = subsystemFacade.create("customers", payload);
            assertTrue(customerId > 0, subsystemName + " should be able to create a customer");

            Map<String, Object> created = subsystemFacade.readById("customers", "customer_id", customerId);
            assertFalse(created.isEmpty(), subsystemName + " should be able to read back its created customer");

            int updated = subsystemFacade.update(
                    "customers",
                    "customer_id",
                    customerId,
                    Map.of("status", "UPDATED")
            );
            assertEquals(1, updated, subsystemName + " should be able to update its customer");

            Map<String, Object> updatedRow = subsystemFacade.readById("customers", "customer_id", customerId);
            assertEquals("UPDATED", String.valueOf(updatedRow.get("status")));

            int deleted = subsystemFacade.delete("customers", "customer_id", customerId);
            assertEquals(1, deleted, subsystemName + " should be able to delete its customer");
        }
    }
}
