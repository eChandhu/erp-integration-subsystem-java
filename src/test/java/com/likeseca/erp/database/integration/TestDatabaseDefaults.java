package com.likeseca.erp.database.integration;

final class TestDatabaseDefaults {
    private TestDatabaseDefaults() {
    }

    static void configureFreshSchema() {
        setIfMissing("db.host", "127.0.0.1");
        setIfMissing("db.port", "3306");
        System.setProperty("db.name", "erp_subsystem_test_" + System.nanoTime());
    }

    private static void setIfMissing(String key, String value) {
        if (System.getProperty(key) == null || System.getProperty(key).isBlank()) {
            System.setProperty(key, value);
        }
    }
}
