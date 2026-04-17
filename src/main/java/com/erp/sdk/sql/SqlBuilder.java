package com.erp.sdk.sql;

import java.util.List;
import java.util.Map;
import java.util.StringJoiner;

public final class SqlBuilder {
    private SqlBuilder() {
    }

    public static String buildInsert(String table, List<String> columns) {
        StringJoiner columnJoiner = new StringJoiner(", ");
        StringJoiner valueJoiner = new StringJoiner(", ");
        for (String column : columns) {
            columnJoiner.add(column);
            valueJoiner.add("?");
        }
        return "INSERT INTO %s (%s) VALUES (%s)".formatted(table, columnJoiner, valueJoiner);
    }

    public static String buildUpdate(String table, List<String> columns, String idColumn) {
        StringJoiner joiner = new StringJoiner(", ");
        for (String column : columns) {
            joiner.add(column + " = ?");
        }
        return "UPDATE %s SET %s WHERE %s = ?".formatted(table, joiner, idColumn);
    }

    public static String buildSelectById(String table, List<String> columns, String idColumn) {
        return "SELECT %s FROM %s WHERE %s = ?".formatted(String.join(", ", columns), table, idColumn);
    }

    public static String buildSelectAll(String table, List<String> columns, Map<String, Object> filters) {
        String base = "SELECT %s FROM %s".formatted(String.join(", ", columns), table);
        if (filters.isEmpty()) {
            return base;
        }
        StringJoiner joiner = new StringJoiner(" AND ");
        filters.keySet().forEach(key -> joiner.add(key + " = ?"));
        return base + " WHERE " + joiner;
    }

    public static String buildDelete(String table, String idColumn) {
        return "DELETE FROM %s WHERE %s = ?".formatted(table, idColumn);
    }
}
