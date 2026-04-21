package com.likeseca.erp.database.model;

import java.util.List;
import java.util.Map;

public record JoinSpec(
        String leftTable,
        String rightTable,
        String leftJoinColumn,
        String rightJoinColumn,
        List<String> selectedColumns,
        Map<String, Object> filters
) {
}
