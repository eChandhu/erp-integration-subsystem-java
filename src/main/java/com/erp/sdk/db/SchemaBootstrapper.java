package com.erp.sdk.db;

import com.erp.sdk.config.DatabaseConfig;
import com.erp.sdk.exception.DatabaseOperationException;
import com.erp.sdk.exception.LocalExceptionHandler;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Creates the local ERP database and loads the canonical schema from the JAR.
 * The class intentionally runs before the Hikari pool is created because the
 * database itself may not exist yet on a teammate's laptop.
 */
public final class SchemaBootstrapper {
    private static final AtomicBoolean INITIALIZED = new AtomicBoolean(false);
    private static final Object INITIALIZATION_MONITOR = new Object();
    private static final String CORE_TABLE = "permission_matrix";
    private static final String SCHEMA_RESOURCE = "schema.sql";

    private SchemaBootstrapper() {
    }

    public static void ensureSchemaInitialized(DatabaseConfig config) {
        if (INITIALIZED.get()) {
            return;
        }

        synchronized (INITIALIZATION_MONITOR) {
            if (INITIALIZED.get()) {
                return;
            }
            initializeSchema(config);
            INITIALIZED.set(true);
        }
    }

    private static void initializeSchema(DatabaseConfig config) {
        try {
            ensureDatabaseExists(config);
            try (Connection connection = DriverManager.getConnection(
                    config.jdbcUrl(),
                    config.username(),
                    config.password())) {
                if (!hasTable(connection, CORE_TABLE)) {
                    applySchema(connection);
                }
            }
        } catch (SQLException exception) {
            throw LocalExceptionHandler.mapSqlException(
                    "Unable to initialize local ERP schema from " + SCHEMA_RESOURCE,
                    exception
            );
        } catch (IOException exception) {
            throw new DatabaseOperationException("Unable to read " + SCHEMA_RESOURCE + " from the SDK JAR.", exception);
        }
    }

    private static void ensureDatabaseExists(DatabaseConfig config) throws SQLException {
        String sql = "CREATE DATABASE IF NOT EXISTS `" + escapeIdentifier(config.database()) + "`";
        try (Connection connection = DriverManager.getConnection(
                config.serverJdbcUrl(),
                config.username(),
                config.password());
             Statement statement = connection.createStatement()) {
            statement.execute(sql);
        }
    }

    private static boolean hasTable(Connection connection, String tableName) throws SQLException {
        try (ResultSet resultSet = connection.getMetaData().getTables(
                connection.getCatalog(),
                null,
                tableName,
                new String[]{"TABLE"})) {
            return resultSet.next();
        }
    }

    private static void applySchema(Connection connection) throws IOException, SQLException {
        String delimiter = ";";
        StringBuilder statementBuffer = new StringBuilder();

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(openSchemaStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String trimmed = line.trim();
                if (trimmed.toUpperCase().startsWith("DELIMITER ")) {
                    delimiter = trimmed.substring("DELIMITER ".length()).trim();
                    continue;
                }
                if (trimmed.isEmpty() || trimmed.startsWith("--")) {
                    continue;
                }

                statementBuffer.append(line).append(System.lineSeparator());
                if (trimmed.endsWith(delimiter)) {
                    executeStatement(connection, statementBuffer.toString(), delimiter);
                    statementBuffer.setLength(0);
                }
            }
        }

        if (!statementBuffer.isEmpty()) {
            executeStatement(connection, statementBuffer.toString(), delimiter);
        }
    }

    private static InputStream openSchemaStream() throws IOException {
        InputStream inputStream = SchemaBootstrapper.class.getClassLoader().getResourceAsStream(SCHEMA_RESOURCE);
        if (inputStream == null) {
            throw new IOException(SCHEMA_RESOURCE + " is missing from the classpath.");
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

        // The bootstrapper creates and connects to the configured local database
        // itself, so schema scripts may keep these deployment lines harmlessly.
        String upperStatement = statementText.toUpperCase();
        if (upperStatement.startsWith("CREATE DATABASE ") || upperStatement.startsWith("USE ")) {
            return;
        }

        try (Statement statement = connection.createStatement()) {
            statement.execute(statementText);
        }
    }

    private static String escapeIdentifier(String identifier) {
        return identifier.replace("`", "``");
    }
}
