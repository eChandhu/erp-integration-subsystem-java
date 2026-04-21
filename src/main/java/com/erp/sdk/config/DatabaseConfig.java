package com.erp.sdk.config;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

public record DatabaseConfig(
        String host,
        int port,
        String database,
        String username,
        String password,
        int maximumPoolSize,
        Path backupDirectory,
        String dumpCommand,
        String restoreCommand
) {
    private static final String DEFAULT_HOST = "127.0.0.1";
    private static final int DEFAULT_PORT = 3306;
    private static final String DEFAULT_DATABASE = "erp_subsystem";
    private static final String DEFAULT_USERNAME = "erp_user";
    private static final String DEFAULT_PASSWORD = "erp_password";

    /**
     * Loads the first local configuration file that exists. Teams can keep a small
     * application.properties beside their application, while this SDK still works
     * out of the box with the documented local MySQL defaults.
     */
    public static DatabaseConfig load() {
        for (Path candidate : localConfigCandidates()) {
            if (Files.isRegularFile(candidate)) {
                try {
                    return fromProperties(candidate);
                } catch (IOException exception) {
                    throw new IllegalStateException("Unable to load database config from " + candidate, exception);
                }
            }
        }
        return localDefault();
    }

    public static DatabaseConfig fromProperties(Path propertiesPath) throws IOException {
        Properties properties = new Properties();
        try (InputStream inputStream = Files.newInputStream(propertiesPath)) {
            properties.load(inputStream);
        }
        return fromProperties(properties);
    }

    public static DatabaseConfig fromClasspath(String resourceName) throws IOException {
        Properties properties = new Properties();
        try (InputStream inputStream = DatabaseConfig.class.getClassLoader().getResourceAsStream(resourceName)) {
            if (inputStream == null) {
                throw new IOException("Classpath resource not found: " + resourceName);
            }
            properties.load(inputStream);
        }
        return fromProperties(properties);
    }

    private static DatabaseConfig fromProperties(Properties properties) {
        return new DatabaseConfig(
                properties.getProperty("db.host", DEFAULT_HOST),
                Integer.parseInt(properties.getProperty("db.port", String.valueOf(DEFAULT_PORT))),
                properties.getProperty("db.name", DEFAULT_DATABASE),
                properties.getProperty("db.username", DEFAULT_USERNAME),
                properties.getProperty("db.password", DEFAULT_PASSWORD),
                Integer.parseInt(properties.getProperty("db.pool.maxSize", "10")),
                Path.of(properties.getProperty("db.backup.dir", "backups")),
                properties.getProperty("db.dump.command", "mysqldump"),
                properties.getProperty("db.restore.command", "mysql")
        );
    }

    public static DatabaseConfig localDefault() {
        return new DatabaseConfig(
                DEFAULT_HOST,
                DEFAULT_PORT,
                DEFAULT_DATABASE,
                DEFAULT_USERNAME,
                DEFAULT_PASSWORD,
                10,
                Path.of("backups"),
                "mysqldump",
                "mysql"
        );
    }

    public String jdbcUrl() {
        return "jdbc:mysql://%s:%d/%s?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
                .formatted(host, port, database);
    }

    public String serverJdbcUrl() {
        return "jdbc:mysql://%s:%d/?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
                .formatted(host, port);
    }

    private static Path[] localConfigCandidates() {
        return new Path[]{
                Path.of("application.properties"),
                Path.of("application-local.properties"),
                Path.of("src", "main", "resources", "application.properties"),
                Path.of("src", "main", "resources", "application-local.properties"),
                Path.of("src", "main", "resources", "application-example.properties")
        };
    }
}
