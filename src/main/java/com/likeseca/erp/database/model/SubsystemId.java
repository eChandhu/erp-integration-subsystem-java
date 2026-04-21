package com.likeseca.erp.database.model;

public enum SubsystemId {
    DATABASE_INTEGRATION("Database Integration", "Integration"),
    UI("UI", "UI"),
    CRM("CRM", "CRM"),
    MARKETING("Marketing", "Marketing"),
    SALES_MANAGEMENT("Sales Management", "Sales Management"),
    ORDER_PROCESSING("Order Processing", "Order Processing"),
    SUPPLY_CHAIN("Supply Chain", "Supply Chain"),
    MANUFACTURING("Manufacturing", "Manufacturing"),
    HR("HR", "HR"),
    PROJECT_MANAGEMENT("Project Management", "Project Management"),
    REPORTING("Reporting", "Reporting"),
    DATA_ANALYTICS("Data Analytics", "Data Analytics"),
    BUSINESS_INTELLIGENCE("Business Intelligence", "Business Intelligence"),
    AUTOMATION("Automation", "Automation"),
    BUSINESS_CONTROL("Business Control", "Business Control"),
    FINANCIAL_MANAGEMENT("Financial Management", "Financial Management"),
    ACCOUNTING("Accounting", "Accounting");

    private final String displayName;
    private final String permissionName;

    SubsystemId(String displayName, String permissionName) {
        this.displayName = displayName;
        this.permissionName = permissionName;
    }

    public String displayName() {
        return displayName;
    }

    public String permissionName() {
        return permissionName;
    }
}
