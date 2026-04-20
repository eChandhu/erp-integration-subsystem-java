package com.erp.sdk.subsystem;

public enum SubsystemName {
    INTEGRATION("Integration"),
    UI("UI"),
    CRM("CRM"),
    MARKETING("Marketing"),
    SALES_MANAGEMENT("Sales Management"),
    ORDER_PROCESSING("Order Processing"),
    SUPPLY_CHAIN("Supply Chain"),
    MANUFACTURING("Manufacturing"),
    HR("HR"),
    PROJECT_MANAGEMENT("Project Management"),
    REPORTING("Reporting"),
    DATA_ANALYTICS("Data Analytics"),
    BUSINESS_INTELLIGENCE("Business Intelligence"),
    AUTOMATION("Automation"),
    BUSINESS_CONTROL("Business Control"),
    FINANCIAL_MANAGEMENT("Financial Management");

    private final String dbValue;

    SubsystemName(String dbValue) {
        this.dbValue = dbValue;
    }

    public String dbValue() {
        return dbValue;
    }
}
