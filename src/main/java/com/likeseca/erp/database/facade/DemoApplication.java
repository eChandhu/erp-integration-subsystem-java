package com.likeseca.erp.database.facade;

import java.util.Map;

public final class DemoApplication {
    private DemoApplication() {
    }

    public static void main(String[] args) {
        try (ErpDatabaseFacade facade = new ErpDatabaseFacade()) {
            System.out.println("LikeSecA local ERP database module started.");
            System.out.println("Integration registry rows: " + facade.databaseIntegration().readAll("integration_registry", Map.of()).size());
            System.out.println("CRM customers rows visible through adapter: " + facade.crm().readAll("customers", Map.of()).size());
            System.out.println("Supply chain suppliers rows visible through adapter: " + facade.supplyChain().readAll("suppliers", Map.of()).size());
            System.out.println("LikeSecA demo completed.");
        }
    }
}
