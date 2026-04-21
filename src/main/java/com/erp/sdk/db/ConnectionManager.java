package com.erp.sdk.db;

import com.erp.sdk.config.DatabaseConfig;
import com.erp.sdk.exception.LocalExceptionHandler;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public final class ConnectionManager implements AutoCloseable {
    private final HikariDataSource dataSource;

    public ConnectionManager(DatabaseConfig config) {
        SchemaBootstrapper.ensureSchemaInitialized(config);

        HikariConfig hikariConfig = new HikariConfig();
        hikariConfig.setJdbcUrl(config.jdbcUrl());
        hikariConfig.setUsername(config.username());
        hikariConfig.setPassword(config.password());
        hikariConfig.setMaximumPoolSize(config.maximumPoolSize());
        hikariConfig.setMinimumIdle(Math.min(2, config.maximumPoolSize()));
        hikariConfig.setPoolName("erp-subsystem-pool");
        hikariConfig.setAutoCommit(false);
        hikariConfig.setConnectionTimeout(15_000);
        this.dataSource = new HikariDataSource(hikariConfig);
    }

    public Connection getConnection() {
        try {
            return dataSource.getConnection();
        } catch (SQLException exception) {
            throw LocalExceptionHandler.mapSqlException("Unable to acquire a database connection", exception);
        }
    }

    @Override
    public void close() {
        dataSource.close();
    }
}
