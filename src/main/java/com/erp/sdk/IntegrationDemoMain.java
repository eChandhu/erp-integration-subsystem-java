package com.erp.sdk;

import com.erp.sdk.config.DatabaseConfig;
import com.erp.sdk.exception.UnauthorizedResourceAccessException;
import com.erp.sdk.factory.SubsystemFactory;
import com.erp.sdk.subsystem.Integration;
import com.erp.sdk.subsystem.SubsystemName;

import java.nio.file.Path;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public final class IntegrationDemoMain {
    private IntegrationDemoMain() {
    }

    public static void main(String[] args) throws Exception {
        String mode = args.length > 0 ? args[0] : "smoke";
        Path configPath = args.length > 1
                ? Path.of(args[1])
                : Path.of("src", "main", "resources", "application-example.properties");

        DatabaseConfig config = DatabaseConfig.fromProperties(configPath);

        try (Integration integration = (Integration) SubsystemFactory.create(SubsystemName.INTEGRATION, config)) {
            System.out.println("Integration subsystem demo started. Mode = " + mode);
            System.out.println("Using config file: " + configPath.toAbsolutePath());

            switch (mode.toLowerCase()) {
                case "smoke" -> runSmoke(integration);
                case "crud" -> runCrud(integration);
                case "permission" -> runPermission(integration);
                case "logging" -> runLogging(integration);
                case "all" -> {
                    runSmoke(integration);
                    runCrud(integration);
                    runPermission(integration);
                    runLogging(integration);
                }
                default -> {
                    System.out.println("Unknown mode. Use one of: smoke, crud, permission, logging, all");
                    return;
                }
            }
            System.out.println("Integration subsystem demo completed successfully.");
        }
    }

    private static void runSmoke(Integration integration) {
        List<Map<String, Object>> subsystems =
                integration.readAll("integration_registry", Map.of(), "admin_main");
        List<Map<String, Object>> permissions =
                integration.readAll("permission_matrix", Map.of(), "admin_main");
        List<Map<String, Object>> ownership =
                integration.readAll("data_ownership", Map.of(), "admin_main");

        System.out.println("SMOKE CHECK");
        System.out.println("Registered subsystems: " + subsystems.size());
        System.out.println("Permission rules loaded: " + permissions.size());
        System.out.println("Data ownership entries: " + ownership.size());
    }

    private static void runCrud(Integration integration) {
        String subsystemName = "Temp Integration Test " + UUID.randomUUID();
        String apiKeyHash = "temp_hash_" + UUID.randomUUID();

        System.out.println("CRUD CHECK");

        long createdId = integration.create("integration_registry", Map.of(
                "subsystem_name", subsystemName,
                "api_key_hash", apiKeyHash,
                "is_active", true
        ), "admin_main");
        if (createdId >= 0) {
            System.out.println("CREATE OK. Generated key: " + createdId);
        } else {
            System.out.println("CREATE OK. Row inserted into integration_registry.");
        }

        List<Map<String, Object>> createdRows = integration.readAll(
                "integration_registry",
                Map.of("subsystem_name", subsystemName),
                "admin_main"
        );
        System.out.println("READ OK. Matching rows: " + createdRows.size());

        int updated = integration.update(
                "integration_registry",
                "subsystem_id",
                createdRows.get(0).get("subsystem_id"),
                Map.of("is_active", false, "api_key_hash", apiKeyHash + "_updated"),
                "admin_main"
        );
        System.out.println("UPDATE OK. Rows updated: " + updated);

        int deleted = integration.delete(
                "integration_registry",
                "subsystem_id",
                createdRows.get(0).get("subsystem_id"),
                "admin_main"
        );
        System.out.println("DELETE OK. Rows deleted: " + deleted);
    }

    private static void runPermission(Integration integration) {
        System.out.println("PERMISSION CHECK");
        try {
            integration.readAll("customers", Map.of(), "admin_main");
            System.out.println("UNEXPECTED: permission test failed because access was allowed.");
        } catch (UnauthorizedResourceAccessException exception) {
            System.out.println("PERMISSION OK. Exception raised as expected:");
            System.out.println(exception.getMessage());
        }
    }

    private static void runLogging(Integration integration) {
        System.out.println("LOGGING CHECK");
        List<Map<String, Object>> logs = integration.readAll("audit_logs", Map.of(), "admin_main");
        System.out.println("Audit log rows available: " + logs.size());
        if (!logs.isEmpty()) {
            System.out.println("Most recent accessible log sample: " + logs.get(logs.size() - 1));
        }
    }
}
