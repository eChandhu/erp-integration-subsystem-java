package com.erp.sdk.sql;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.StringJoiner;
import java.util.regex.Pattern;

public final class SqlBuilder {
    private static final Pattern IDENTIFIER = Pattern.compile("[A-Za-z_][A-Za-z0-9_]*");

    private SqlBuilder() {
    }

    public static String buildInsert(String table, List<String> columns) {
        validateIdentifier(table, "table");
        requireColumns(columns);
        StringJoiner columnJoiner = new StringJoiner(", ");
        StringJoiner valueJoiner = new StringJoiner(", ");
        for (String column : columns) {
            columnJoiner.add(validatedIdentifier(column, "column"));
            valueJoiner.add("?");
        }
        return "INSERT INTO %s (%s) VALUES (%s)".formatted(table, columnJoiner, valueJoiner);
    }

    public static String buildUpdate(String table, List<String> columns, String idColumn) {
        validateIdentifier(table, "table");
        validateIdentifier(idColumn, "id column");
        requireColumns(columns);
        StringJoiner joiner = new StringJoiner(", ");
        for (String column : columns) {
            joiner.add(validatedIdentifier(column, "column") + " = ?");
        }
        return "UPDATE %s SET %s WHERE %s = ?".formatted(table, joiner, idColumn);
    }

    public static String buildSelectById(String table, List<String> columns, String idColumn) {
        validateIdentifier(table, "table");
        validateIdentifier(idColumn, "id column");
        requireColumns(columns);
        return "SELECT %s FROM %s WHERE %s = ?".formatted(String.join(", ", columns), table, idColumn);
    }

    public static String buildSelectAll(String table, List<String> columns, Map<String, Object> filters) {
        validateIdentifier(table, "table");
        requireColumns(columns);
        String base = "SELECT %s FROM %s".formatted(String.join(", ", columns), table);
        if (filters.isEmpty()) {
            return base;
        }
        StringJoiner joiner = new StringJoiner(" AND ");
        filters.keySet().forEach(key -> joiner.add(validatedIdentifier(key, "filter column") + " = ?"));
        return base + " WHERE " + joiner;
    }

    public static String buildDelete(String table, String idColumn) {
        validateIdentifier(table, "table");
        validateIdentifier(idColumn, "id column");
        return "DELETE FROM %s WHERE %s = ?".formatted(table, idColumn);
    }

    public static String validatedIdentifier(String identifier, String label) {
        validateIdentifier(identifier, label);
        return identifier;
    }

    private static void validateIdentifier(String identifier, String label) {
        Objects.requireNonNull(identifier, label + " cannot be null.");
        if (!IDENTIFIER.matcher(identifier).matches()) {
            throw new IllegalArgumentException("Invalid %s: %s".formatted(label, identifier));
        }
    }

    private static void requireColumns(List<String> columns) {
        if (columns == null || columns.isEmpty()) {
            throw new IllegalArgumentException("At least one column is required for this SQL operation.");
        }
        columns.forEach(column -> validateIdentifier(column, "column"));
    }
}
