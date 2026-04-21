package com.likeseca.erp.database.service;

import com.likeseca.erp.database.config.DatabaseConnectionManager;
import com.likeseca.erp.database.exception.LocalExceptionHandler;
import com.likeseca.erp.database.util.RowMapper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class JdbcOperations {
    private final LocalExceptionHandler exceptions = new LocalExceptionHandler();

    public <T> List<T> query(String sql, RowMapper<T> mapper, SqlConsumer<PreparedStatement> binder) {
        Connection connection = null;
        try {
            connection = DatabaseConnectionManager.getInstance().getConnection();
            return query(connection, sql, mapper, binder);
        } catch (SQLException exception) {
            throw exceptions.sqlFailure("QUERY", exception, sql);
        } finally {
            DatabaseConnectionManager.getInstance().releaseConnection(connection);
        }
    }

    public <T> List<T> query(String sql, RowMapper<T> mapper) {
        return query(sql, mapper, statement -> {
        });
    }

    public <T> Optional<T> queryOne(String sql, RowMapper<T> mapper, SqlConsumer<PreparedStatement> binder) {
        return query(sql, mapper, binder).stream().findFirst();
    }

    public void update(String sql, SqlConsumer<PreparedStatement> binder) {
        Connection connection = null;
        try {
            connection = DatabaseConnectionManager.getInstance().getConnection();
            update(connection, sql, binder);
        } catch (SQLException exception) {
            throw exceptions.sqlFailure("UPDATE", exception, sql);
        } finally {
            DatabaseConnectionManager.getInstance().releaseConnection(connection);
        }
    }

    public void inTransaction(SqlConsumer<Connection> work) {
        Connection connection = null;
        boolean originalAutoCommit = true;
        try {
            connection = DatabaseConnectionManager.getInstance().getConnection();
            originalAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            work.accept(connection);
            connection.commit();
        } catch (SQLException exception) {
            rollbackQuietly(connection);
            throw exceptions.sqlFailure("TRANSACTION", exception, "transaction");
        } finally {
            restoreAutoCommit(connection, originalAutoCommit);
            DatabaseConnectionManager.getInstance().releaseConnection(connection);
        }
    }

    public Map<String, Object> mapSingleRow(ResultSet resultSet) throws SQLException {
        ResultSetMetaData metadata = resultSet.getMetaData();
        Map<String, Object> row = new LinkedHashMap<>();
        for (int index = 1; index <= metadata.getColumnCount(); index++) {
            row.put(metadata.getColumnLabel(index), resultSet.getObject(index));
        }
        return row;
    }

    public List<Map<String, Object>> mapRows(ResultSet resultSet) throws SQLException {
        List<Map<String, Object>> rows = new ArrayList<>();
        while (resultSet.next()) {
            rows.add(mapSingleRow(resultSet));
        }
        return rows;
    }

    public void update(Connection connection, String sql, SqlConsumer<PreparedStatement> binder) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            binder.accept(statement);
            statement.executeUpdate();
        }
    }

    public <T> List<T> query(Connection connection, String sql, RowMapper<T> mapper,
                             SqlConsumer<PreparedStatement> binder) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            binder.accept(statement);
            try (ResultSet resultSet = statement.executeQuery()) {
                List<T> results = new ArrayList<>();
                while (resultSet.next()) {
                    results.add(mapper.map(resultSet));
                }
                return results;
            }
        }
    }

    private void rollbackQuietly(Connection connection) {
        if (connection == null) {
            return;
        }
        try {
            connection.rollback();
        } catch (SQLException ignored) {
        }
    }

    private void restoreAutoCommit(Connection connection, boolean originalAutoCommit) {
        if (connection == null) {
            return;
        }
        try {
            connection.setAutoCommit(originalAutoCommit);
        } catch (SQLException ignored) {
        }
    }

    @FunctionalInterface
    public interface SqlConsumer<T> {
        void accept(T input) throws SQLException;
    }
}
