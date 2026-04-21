package com.erp.sdk.db;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * LocalDatabaseConfig - Configuration manager for local MySQL database setup
 * 
 * Handles multiple configuration sources in order of precedence:
 * 1. JVM System Properties (-Ddb.url, -Ddb.username, etc.)
 * 2. Environment Variables (DB_URL, DB_USERNAME, etc.)
 * 3. application-local-template.properties file
 * 4. Default hardcoded values for local development
 * 
 * This ensures flexibility for different deployment scenarios while providing sensible defaults
 * for local development where MySQL is typically running on localhost:3306.
 * 
 * @author ERP Team
 * @version 2.0
 */
public class LocalDatabaseConfig {
    
    // Configuration keys
    private static final String DB_URL_KEY = "db.url";
    private static final String DB_USERNAME_KEY = "db.username";
    private static final String DB_PASSWORD_KEY = "db.password";
    private static final String DB_POOL_SIZE_KEY = "db.pool.size";
    private static final String AUTO_SCHEMA_INIT_KEY = "db.auto.schema.init";
    
    // Default values for local setup
    private static final String DEFAULT_DB_URL = "jdbc:mysql://localhost:3306/erp_subsystem";
    private static final String DEFAULT_DB_USERNAME = "root";
    private static final String DEFAULT_DB_PASSWORD = "";
    private static final int DEFAULT_POOL_SIZE = 10;
    private static final boolean DEFAULT_AUTO_SCHEMA_INIT = true;
    
    // Configuration properties
    private final String dbUrl;
    private final String dbUsername;
    private final String dbPassword;
    private final int dbPoolSize;
    private final boolean autoSchemaInit;
    
    /**
     * Constructor - Initializes configuration from multiple sources
     * Configuration precedence:
     * 1. JVM System Properties (highest priority)
     * 2. Environment Variables
     * 3. Properties file
     * 4. Hardcoded defaults (lowest priority)
     */
    public LocalDatabaseConfig() {
        this.dbUrl = resolveProperty(DB_URL_KEY, DEFAULT_DB_URL);
        this.dbUsername = resolveProperty(DB_USERNAME_KEY, DEFAULT_DB_USERNAME);
        this.dbPassword = resolveProperty(DB_PASSWORD_KEY, DEFAULT_DB_PASSWORD);
        this.dbPoolSize = resolveIntProperty(DB_POOL_SIZE_KEY, DEFAULT_POOL_SIZE);
        this.autoSchemaInit = resolveBooleanProperty(AUTO_SCHEMA_INIT_KEY, DEFAULT_AUTO_SCHEMA_INIT);
        
        logConfiguration();
    }
    
    /**
     * Resolves a configuration property from multiple sources
     * 
     * @param key the property key to resolve
     * @param defaultValue the default value if not found anywhere
     * @return the resolved property value
     */
    private String resolveProperty(String key, String defaultValue) {
        // First check JVM system properties (highest priority)
        String value = System.getProperty(key);
        if (value != null && !value.isEmpty()) {
            return value;
        }
        
        // Then check environment variables
        String envKey = key.replace(".", "_").toUpperCase();
        value = System.getenv(envKey);
        if (value != null && !value.isEmpty()) {
            return value;
        }
        
        // Finally check properties file and defaults
        Properties props = loadPropertiesFile();
        value = props.getProperty(key);
        if (value != null && !value.isEmpty()) {
            return value;
        }
        
        return defaultValue;
    }
    
    /**
     * Resolves an integer property from configuration sources
     * 
     * @param key the property key to resolve
     * @param defaultValue the default value if not found
     * @return the resolved integer value
     */
    private int resolveIntProperty(String key, int defaultValue) {
        String value = resolveProperty(key, null);
        if (value != null) {
            try {
                return Integer.parseInt(value);
            } catch (NumberFormatException e) {
                System.err.println("Invalid integer value for key: " + key);
            }
        }
        return defaultValue;
    }
    
    /**
     * Resolves a boolean property from configuration sources
     * 
     * @param key the property key to resolve
     * @param defaultValue the default value if not found
     * @return the resolved boolean value
     */
    private boolean resolveBooleanProperty(String key, boolean defaultValue) {
        String value = resolveProperty(key, null);
        if (value != null) {
            return "true".equalsIgnoreCase(value) || "yes".equalsIgnoreCase(value) || "1".equals(value);
        }
        return defaultValue;
    }
    
    /**
     * Loads properties from application-local-template.properties file
     * 
     * @return Properties object loaded from file, or empty Properties if file not found
     */
    private Properties loadPropertiesFile() {
        Properties props = new Properties();
        try (InputStream input = getClass().getClassLoader()
                .getResourceAsStream("application-local-template.properties")) {
            if (input != null) {
                props.load(input);
            }
        } catch (IOException e) {
            System.err.println("Error loading properties file: " + e.getMessage());
        }
        return props;
    }
    
    /**
     * Logs the active configuration (masks password for security)
     */
    private void logConfiguration() {
        System.out.println("=== ERP Local Database Configuration ===");
        System.out.println("Database URL: " + dbUrl);
        System.out.println("Username: " + dbUsername);
        System.out.println("Password: " + (dbPassword.isEmpty() ? "[empty]" : "***"));
        System.out.println("Connection Pool Size: " + dbPoolSize);
        System.out.println("Auto Schema Initialization: " + autoSchemaInit);
        System.out.println("=========================================");
    }
    
    // Getters
    public String getDbUrl() { return dbUrl; }
    public String getDbUsername() { return dbUsername; }
    public String getDbPassword() { return dbPassword; }
    public int getDbPoolSize() { return dbPoolSize; }
    public boolean isAutoSchemaInit() { return autoSchemaInit; }
}
