package com.likeseca.erp.database.config;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import com.likeseca.erp.database.exception.LocalExceptionHandler;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

public final class DatabaseConnectionManager {
    private static volatile DatabaseConnectionManager instance;

    private final DatabaseConfig config;
    private final BlockingQueue<Connection> pool;
    private final LocalExceptionHandler exceptions = new LocalExceptionHandler();

    private DatabaseConnectionManager(DatabaseConfig config) {
        this.config = config;
        this.pool = new ArrayBlockingQueue<>(config.poolSize());
    }

    public static DatabaseConnectionManager getInstance() {
        if (instance == null) {
            synchronized (DatabaseConnectionManager.class) {
                if (instance == null) {
                    instance = new DatabaseConnectionManager(DatabaseConfig.load());
                }
            }
        }
        return instance;
    }

    public Connection getConnection() throws SQLException {
        Connection pooled = pool.poll();
        if (pooled != null && !pooled.isClosed()) {
            return pooled;
        }
        try {
            return DriverManager.getConnection(config.jdbcUrl(), config.username(), config.password());
        } catch (SQLException exception) {
            throw exceptions.sqlFailure("GET_CONNECTION", exception, config.jdbcUrl());
        }
    }

    public void releaseConnection(Connection connection) {
        if (connection == null) {
            return;
        }
        try {
            if (connection.isClosed()) {
                return;
            }
            if (!pool.offer(connection)) {
                connection.close();
            }
        } catch (SQLException ignored) {
        }
    }

    public synchronized void shutdown() {
        List<Connection> connections = new ArrayList<>();
        pool.drainTo(connections);
        for (Connection connection : connections) {
            try {
                connection.close();
            } catch (SQLException ignored) {
            }
        }
        AbandonedConnectionCleanupThread.checkedShutdown();
    }

    public DatabaseConfig config() {
        return config;
    }
}
