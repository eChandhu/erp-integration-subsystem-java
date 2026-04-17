package com.erp.sdk.config;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Objects;
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
    public static DatabaseConfig fromProperties(Path propertiesPath) throws IOException {
        Properties properties = new Properties();
        try (InputStream inputStream = Files.newInputStream(propertiesPath)) {
            properties.load(inputStream);
        }

        return new DatabaseConfig(
                required(properties, "db.host"),
                Integer.parseInt(properties.getProperty("db.port", "3306")),
                required(properties, "db.name"),
                required(properties, "db.username"),
                required(properties, "db.password"),
                Integer.parseInt(properties.getProperty("db.pool.maxSize", "10")),
                Path.of(properties.getProperty("db.backup.dir", "backups")),
                properties.getProperty("db.dump.command", "mysqldump"),
                properties.getProperty("db.restore.command", "mysql")
        );
    }

    public String jdbcUrl() {
        return "jdbc:mysql://%s:%d/%s?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
                .formatted(host, port, database);
    }

    private static String required(Properties properties, String key) {
        return Objects.requireNonNull(properties.getProperty(key), "Missing property: " + key);
    }
}
