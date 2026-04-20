package com.erp.sdk.sql;

import java.util.List;
import java.util.Map;

public record JoinRequest(
        String leftTable,
        String rightTable,
        String leftJoinColumn,
        String rightJoinColumn,
        List<String> selectedColumns,
        Map<String, Object> filters
) {
}
