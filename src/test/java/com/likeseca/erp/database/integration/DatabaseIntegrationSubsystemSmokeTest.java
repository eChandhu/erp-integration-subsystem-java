package com.likeseca.erp.database.integration;

import com.likeseca.erp.database.facade.ErpDatabaseFacade;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class DatabaseIntegrationSubsystemSmokeTest {

    @BeforeAll
    static void configureDefaults() {
        TestDatabaseDefaults.configureFreshSchema();
    }

    @Test
    void bootstrapAndReadIntegrationRegistryWithoutCrashing() {
        try (ErpDatabaseFacade facade = new ErpDatabaseFacade()) {
            var rows = facade.databaseIntegrationSubsystem().readAll("integration_registry", Map.of());
            assertNotNull(rows);
            assertFalse(rows.isEmpty(), "integration_registry should be seeded during bootstrap");
        }
    }

    @Test
    void bootstrapAndReadPermissionMatrixWithoutCrashing() {
        try (ErpDatabaseFacade facade = new ErpDatabaseFacade()) {
            var rows = facade.databaseIntegrationSubsystem().readAll("permission_matrix", Map.of());
            assertNotNull(rows);
            assertFalse(rows.isEmpty(), "permission_matrix should be populated during bootstrap");
        }
    }

    @Test
    void allSubsystemsAreRegisteredAfterBootstrap() {
        try (ErpDatabaseFacade facade = new ErpDatabaseFacade()) {
            var rows = facade.databaseIntegrationSubsystem().readAll("integration_registry", Map.of());
            assertTrue(rows.size() >= 17, "expected all subsystem registrations to be present");
        }
    }

    @Test
    void crossSubsystemReadsWorkFromIntegrationFacade() {
        try (ErpDatabaseFacade facade = new ErpDatabaseFacade()) {
            var customerRows = facade.databaseIntegrationSubsystem().readAll("customers", Map.of());
            var supplierRows = facade.databaseIntegrationSubsystem().readAll("suppliers", Map.of());
            assertNotNull(customerRows);
            assertNotNull(supplierRows);
        }
    }
}
