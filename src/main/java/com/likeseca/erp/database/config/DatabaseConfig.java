package com.likeseca.erp.database.config;

import com.likeseca.erp.database.exception.LocalExceptionHandler;

import java.io.IOException;
import java.io.InputStream;
import java.util.Objects;
import java.util.Properties;

public final class DatabaseConfig {
    private static final String PLACEHOLDER_PREFIX = "CHANGE_ME";
    private static final LocalExceptionHandler EXCEPTIONS = new LocalExceptionHandler();

    private final String host;
    private final int port;
    private final String schema;
    private final String username;
    private final String password;
    private final int poolSize;

    private DatabaseConfig(String host, int port, String schema, String username, String password, int poolSize) {
        this.host = Objects.requireNonNull(host, "host");
        this.port = port;
        this.schema = Objects.requireNonNull(schema, "schema");
        this.username = Objects.requireNonNull(username, "username");
        this.password = Objects.requireNonNull(password, "password");
        this.poolSize = poolSize;
    }

    public static DatabaseConfig load() {
        Properties properties = new Properties();
        try (InputStream inputStream = DatabaseConfig.class.getClassLoader().getResourceAsStream("database.properties")) {
            if (inputStream != null) {
                properties.load(inputStream);
            }
        } catch (IOException exception) {
            throw EXCEPTIONS.configurationFailure("Unable to load database.properties from the classpath.");
        }

        String host = resolve("db.host", "DB_HOST", properties, "127.0.0.1");
        String portValue = resolve("db.port", "DB_PORT", properties, "3306");
        String schema = resolve("db.name", "DB_NAME", properties, "erp_subsystem");
        String username = resolve("db.username", "DB_USERNAME", properties, null);
        String password = resolve("db.password", "DB_PASSWORD", properties, null);
        String poolSizeValue = resolve("db.pool.size", "DB_POOL_SIZE", properties, "4");

        if (username == null || username.isBlank()) {
            throw EXCEPTIONS.configurationFailure("Database username is required. Set db.username or DB_USERNAME.");
        }
        if (password == null) {
            throw EXCEPTIONS.configurationFailure("Database password is required. Set db.password or DB_PASSWORD.");
        }

        return new DatabaseConfig(host, Integer.parseInt(portValue), schema, username, password, Integer.parseInt(poolSizeValue));
    }

    private static String resolve(String propertyKey, String envKey, Properties properties, String defaultValue) {
        String systemValue = System.getProperty(propertyKey);
        if (configured(systemValue)) {
            return systemValue;
        }

        String environmentValue = System.getenv(envKey);
        if (configured(environmentValue)) {
            return environmentValue;
        }

        String propertyValue = properties.getProperty(propertyKey);
        if (configured(propertyValue)) {
            return propertyValue;
        }
        return defaultValue;
    }

    private static boolean configured(String value) {
        return value != null && !value.isBlank() && !value.startsWith(PLACEHOLDER_PREFIX);
    }

    public String jdbcUrl() {
        return "jdbc:mysql://%s:%d/%s?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC".formatted(host, port, schema);
    }

    public String serverUrl() {
        return "jdbc:mysql://%s:%d/?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC".formatted(host, port);
    }

    public String host() {
        return host;
    }

    public int port() {
        return port;
    }

    public String schema() {
        return schema;
    }

    public String username() {
        return username;
    }

    public String password() {
        return password;
    }

    public int poolSize() {
        return Math.max(1, poolSize);
    }
}
