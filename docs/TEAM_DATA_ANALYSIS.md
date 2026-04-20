# Team Data Analysis Used For This Subsystem

## Files Read

The subsystem design in this folder was based on the existing project plus the team requirement files available in the parent workspace:

- `DbOfTeams/scm.sql`
- `DbOfTeams/sales_management_schema.sql`
- `DbOfTeams/Reports.sql`
- `DbOfTeams/project_management_schema.sql`
- `DbOfTeams/orderprocessing_runtime_schema.sql`
- `DbOfTeams/marketing_schema.sql`
- `DbOfTeams/manufacturing, supply chain and automation.sql`
- `DbOfTeams/hr_management.sql`
- `DbOfTeams/da_subsystem.sql`
- `DbOfTeams/crmschema.sql`
- `DbOfTeams/business_process_controls.sql`
- `DbOfTeams/AccountingERP.sql`
- `_xlsx_teamui/xl/sharedStrings.xml`
- `C:\Users\harsh\Downloads\bi_phase3_database_schema.sql`

## Business Intelligence Override

For the Business Intelligence subsystem, the file `C:\Users\harsh\Downloads\bi_phase3_database_schema.sql` is now treated as the primary source instead of the earlier spreadsheet-style interpretation. The canonical schema was updated to reflect its lookup tables, repository tables, source fact tables, analytics result tables, and visualization metadata.

## Main Observations

### CRM / Sales / Marketing

These teams need shared access around `customers`, `leads`, `interactions`, `campaigns`, `deals`, `quotes`, and `quote_items`.

### Order Processing

Order processing depends on `customers`, `quotes`, `quote_items`, `deals`, `orders`, `payments`, `shipments`, and `refunds`.

### Supply Chain / Manufacturing / Automation

These SQL files repeatedly referred to `suppliers`, `materials`, `work_centers`, `routing_steps`, `assembly_lines`, `automation_orders`, `bom_header`, `bom_items`, `production_orders`, `quality_checks`, `purchase_orders`, `po_line_items`, `goods_receipts`, `shipments`, `supplier_invoices`, `customer_invoices`, and `automation_expenses`.

### Project Management

Project management needed `project`, `task`, `resource`, `assignment`, `milestone`, `dependency`, `risk`, `budget`, and `expense`.

### Finance / Accounting

Finance and accounting required `roles`, `users`, `sessions`, `invoices`, `expenses`, `payables`, `receivables`, `ledger`, `transactions`, `payments`, `reports`, and `system_config`.

### Business Process Controls

This SQL introduced governance-heavy tables such as `approval_requests`, `audit_logs`, `risk_records`, `users`, and `workflows`.

### Data Analytics / BI / Reports

Reporting and analytics needed `report`, `filter`, `report_template`, `export`, `scheduler`, `report_data`, `data_sources`, `kpis`, `kpi_snapshots`, `dashboards`, `dashboard_kpis`, `da_reports`, `report_runs`, and `alerts`.

The new BI phase 3 file additionally required:

- `source_types`
- `report_formats`
- `chart_types`
- `kpi_statuses`
- `sales_records`
- `hr_records`
- `finance_transactions`
- `data_warehouse`
- `etl_jobs`
- `analysis_results`
- `forecast_results`
- `trend_results`
- `query_logs`
- `filter_sets`
- `visualizations`
- `analytics_engines`

### UI Spreadsheet Extract

The UI extract showed backend-facing requirements for manufacturing, SCM, authentication, dashboards, finance, order management, project management, CRM, sales, and HR. That reinforced the need for subsystem-specific facades, stable shared table names, compatibility views, and centralized CRUD access.
