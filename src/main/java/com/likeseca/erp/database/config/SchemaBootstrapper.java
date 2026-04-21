package com.likeseca.erp.database.config;

import com.likeseca.erp.database.exception.LocalExceptionHandler;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

public final class SchemaBootstrapper {
    private static final String SCHEMA_RESOURCE = "sql/01-schema.sql";
    private static final Set<String> CORE_TABLES = Set.of("integration_registry", "permission_matrix", "data_ownership", "users");
    private static final ConcurrentMap<String, Object> LOCKS = new ConcurrentHashMap<>();
    private static final LocalExceptionHandler EXCEPTIONS = new LocalExceptionHandler();

    private SchemaBootstrapper() {
    }

    public static void ensureSchemaInitialized() {
        DatabaseConfig config = DatabaseConfig.load();
        String key = config.host() + ":" + config.port() + "/" + config.schema();
        Object lock = LOCKS.computeIfAbsent(key, ignored -> new Object());
        synchronized (lock) {
            try (Connection connection = DriverManager.getConnection(config.serverUrl(), config.username(), config.password())) {
                if (isSchemaReady(connection, config.schema())) {
                    return;
                }
                resetSchema(connection, config.schema());
                applySchema(config);
            } catch (SQLException | IOException exception) {
                throw EXCEPTIONS.bootstrapFailure("Unable to initialize the local ERP schema.", exception);
            }
        }
    }

    private static boolean isSchemaReady(Connection connection, String schema) throws SQLException {
        String sql = """
                SELECT COUNT(*) AS table_count
                FROM information_schema.tables
                WHERE table_schema = ?
                  AND table_name IN (?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, schema);
            int index = 2;
            for (String table : CORE_TABLES) {
                statement.setString(index++, table);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                return resultSet.getInt("table_count") == CORE_TABLES.size();
            }
        }
    }

    private static void resetSchema(Connection connection, String schema) throws SQLException {
        try (Statement statement = connection.createStatement()) {
            statement.execute("DROP DATABASE IF EXISTS `" + schema.replace("`", "``") + "`");
            statement.execute("CREATE DATABASE IF NOT EXISTS `" + schema.replace("`", "``") + "`");
        }
    }

    private static void applySchema(DatabaseConfig config) throws IOException, SQLException {
        try (Connection connection = DriverManager.getConnection(config.jdbcUrl(), config.username(), config.password())) {
            String delimiter = ";";
            StringBuilder statementBuffer = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(openSchemaStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String trimmed = line.trim();
                    if (trimmed.isEmpty() || trimmed.startsWith("--")) {
                        continue;
                    }
                    if (trimmed.regionMatches(true, 0, "DELIMITER ", 0, "DELIMITER ".length())) {
                        delimiter = trimmed.substring("DELIMITER ".length()).trim();
                        continue;
                    }
                    statementBuffer.append(line).append(System.lineSeparator());
                    if (trimmed.endsWith(delimiter)) {
                        executeStatement(connection, statementBuffer.toString(), delimiter);
                        statementBuffer.setLength(0);
                    }
                }
            }
        }
    }

    private static InputStream openSchemaStream() throws IOException {
        InputStream inputStream = SchemaBootstrapper.class.getClassLoader().getResourceAsStream(SCHEMA_RESOURCE);
        if (inputStream == null) {
            throw new IOException("Bundled schema resource is missing: " + SCHEMA_RESOURCE);
        }
        return inputStream;
    }

    private static void executeStatement(Connection connection, String rawStatement, String delimiter) throws SQLException {
        String statementText = rawStatement.trim();
        if (statementText.endsWith(delimiter)) {
            statementText = statementText.substring(0, statementText.length() - delimiter.length()).trim();
        }
        if (statementText.isEmpty()) {
            return;
        }
        String upper = statementText.toUpperCase();
        if (upper.startsWith("CREATE DATABASE ") || upper.startsWith("USE ")) {
            return;
        }
        if (shouldSkipCreateView(connection, statementText, upper)) {
            return;
        }
        try (Statement statement = connection.createStatement()) {
            statement.execute(statementText);
        }
    }

    private static boolean shouldSkipCreateView(Connection connection, String statementText, String upper) throws SQLException {
        if (!upper.startsWith("CREATE VIEW ")) {
            return false;
        }
        String[] parts = statementText.split("\\s+");
        if (parts.length < 3) {
            return false;
        }
        String viewName = parts[2].replace("`", "").trim();
        String sql = """
                SELECT COUNT(*) AS collision_count
                FROM information_schema.tables
                WHERE table_schema = DATABASE()
                  AND LOWER(table_name) = LOWER(?)
                  AND table_type = 'BASE TABLE'
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, viewName);
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                return resultSet.getInt("collision_count") > 0;
            }
        }
    }
}
