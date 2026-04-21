# ERP Database Schema Reference

**Database:** `erp_subsystem`  
**Last Updated:** April 21, 2026  
**Purpose:** Reference guide for the local ERP schema packaged with the SDK

This document summarizes the schema that is created automatically when a team
instantiates `ErpDatabaseFacade`. The canonical runtime copy is
`src/main/resources/schema.sql`, and the visible copy in the repository root is
`schema.sql`.

The schema is designed for a local-first ERP setup:

- every team runs the jar on its own machine
- every team points the jar to its own local MySQL server
- the facade bootstraps the database and tables when needed
- access is controlled through `permission_matrix` and `data_ownership`

---

## Table Of Contents

1. [Core Integration Tables](#core-integration-tables)
2. [Security And Identity](#security-and-identity)
3. [CRM And Sales](#crm-and-sales)
4. [Inventory And Supply](#inventory-and-supply)
5. [Orders And Commerce](#orders-and-commerce)
6. [Procurement And Logistics](#procurement-and-logistics)
7. [Manufacturing](#manufacturing)
8. [HR And Workforce](#hr-and-workforce)
9. [Projects And Work Tracking](#projects-and-work-tracking)
10. [Finance And Accounting](#finance-and-accounting)
11. [Reporting And Analytics](#reporting-and-analytics)
12. [Workflow And Notifications](#workflow-and-notifications)
13. [System Configuration And Audit](#system-configuration-and-audit)
14. [Views](#views)

---

## Core Integration Tables

### `integration_registry`
Tracks the ERP subsystems that are allowed to participate in the local schema.

Typical data includes:

- subsystem identifier
- subsystem name
- activation flag
- API key hash or reference value
- created and updated timestamps

This table is used to discover which subsystem owns which data.

### `permission_matrix`
Stores CRUD permissions for each subsystem against each table.

Important fields:

- `subsystem_id`
- `resource_table`
- `can_create`
- `can_read`
- `can_update`
- `can_delete`
- readable and writable column lists
- optional row filter expression

This is the main table that enforces who can see or change what.

### `data_ownership`
Stores the ownership mapping for each table.

Important fields:

- `resource_table`
- `owner_subsystem_id`
- stewardship notes
- audit timestamps

---

## Security And Identity

### `roles`
Defines the application roles used by the ERP UI and supporting subsystems.

### `users`
Stores application users, login details, role reference, active flag, and
timestamps.

### `user_sessions`
Stores session tokens and expiry data for logged-in users.

### `role_permissions`
Maps roles to module-level permissions across the ERP.

These tables support local authentication, authorization, and session control.

---

## CRM And Sales

### `employees`
Employee master records used across CRM, operations, and workflows.

### `accounts`
Customer or business account records.

### `customers`
Core customer profile information.

### `leads`
Lead capture and qualification records.

### `interactions`
Interaction history such as calls, meetings, notes, and follow-ups.

### `deals`
Sales pipeline and opportunity tracking.

### `quotes`
Quote headers for proposals.

### `quote_items`
Line items inside each quote.

### `campaigns`
Marketing campaign definitions and targeting data.

### `customer_segments`
Customer group definitions used for segmentation.

### `segment_members`
Join table mapping customers to segments.

### `message_templates`
Reusable message bodies for campaigns and communication.

### `campaign_messages`
Campaign delivery records and outbound message tracking.

### `campaign_metrics`
Campaign performance metrics such as open rate, response rate, and counts.

### `consent_preferences`
Customer opt-in and opt-out preferences.

---

## Inventory And Supply

### `inventory_items`
Core item master data, including SKU-like information and stock-related
attributes.

### `inventory_locations`
Physical or logical locations where inventory is stored.

### `inventory_transactions`
Movement history for inventory changes.

### `inventory_reorders`
Reorder thresholds and replenishment decisions.

### `suppliers`
Supplier master records used by procurement and supply chain flows.

### `manufactured_cars`
Example manufacturing output table used by the current ERP schema.

These tables hold the stock, location, and item-level data that other modules
read during normal operation.

---

## Orders And Commerce

### `orders`
Customer order headers.

### `order_items`
Line items for each order.

### `invoices`
Customer invoices.

### `payments`
Payment records tied to invoices and orders.

### `receivables`
Outstanding customer receivable records.

### `refunds`
Refund processing data.

These tables support order capture, billing, payment tracking, and return flows.

---

## Procurement And Logistics

### `suppliers_purchase_seed`
Seed data used to bootstrap supplier purchasing flows.

### `purchase_orders`
Purchase order headers.

### `purchase_order_lines`
PO line items.

### `goods_receipts`
Inbound receiving records.

### `shipments`
Shipment planning and dispatch data.

### `supplier_invoices`
Invoices received from suppliers.

### `customer_invoices`
Outbound invoices generated for customers.

### `purchase_requisitions`
Internal requisitions that trigger procurement.

### `supplier_materials`
Supplier-to-material mapping and supply details.

These tables support inbound procurement, shipping, receiving, and purchase
settlement.

---

## Manufacturing

### `components`
Component master data used in product assembly.

### `bills_of_materials`
Bill of materials headers.

### `bom_items`
Component lines inside a BOM.

### `routings`
Routing definitions for manufacturing steps.

### `routing_steps`
Step-by-step routing operations.

### `mrp_plans`
Material requirements planning output.

### `production_orders`
Production execution records.

### `work_centers`
Work center master records.

### `assembly_lines`
Assembly line definitions.

### `assembly_line_work_centers`
Join table between assembly lines and work centers.

### `execution_logs`
Execution history for manufacturing operations.

These tables represent the production side of the ERP schema.

---

## HR And Workforce

### `recruitment_candidates`
Candidate records for hiring.

### `payroll_records`
Payroll output records.

### `attendance_records`
Attendance tracking.

### `leave_requests`
Leave application data.

### `performance_reviews`
Performance review data.

### `appraisal`
Appraisal records for employees.

### `attendance_record`
Legacy or compatibility attendance table.

### `benefit_enrollment`
Employee benefits enrollment.

### `candidate`
Legacy or compatibility candidate table.

### `claim`
Employee claims and reimbursements.

### `leave_balance`
Leave balances by employee.

### `leave_request`
Legacy or compatibility leave request table.

### `payroll`
Legacy or compatibility payroll table.

### `promotion`
Employee promotion tracking.

### `workforce_plan`
Workforce planning and staffing targets.

### `onboarding_record`
Employee onboarding records.

### `onboarding_activity_log`
Activity log for onboarding tasks.

---

## Projects And Work Tracking

### `project`
Project master data.

### `task`
Task definitions and execution status.

### `dependency`
Task dependency relationships.

### `resource`
Project resource definitions.

### `project_team_members`
Project-to-user mapping.

### `assignment`
Task or resource assignments.

### `budget`
Project budget data.

### `milestone`
Project milestone records.

### `expense`
Project expense tracking.

### `risk`
Project risk register.

### `projects`
Compatibility view-style project data set used by the schema.

### `project_tasks`
Compatibility view-style task data set.

### `project_resources`
Compatibility view-style resource data set.

### `project_milestones`
Compatibility view-style milestone data set.

### `task_dependencies`
Compatibility view-style dependency data set.

### `project_risks`
Compatibility view-style risk data set.

### `project_expenses`
Compatibility view-style expense data set.

These tables support planning, assignment, progress tracking, and reporting.

---

## Finance And Accounting

### `assets`
Fixed asset records.

### `expenses`
Financial expense entries.

### `payables`
Accounts payable records.

### `ledger`
Ledger entries.

### `transactions`
Financial transaction records.

### `system_config`
Key-value configuration store used by the ERP runtime.

### `automation_expenses`
Automated expense processing records.

### `finance_transactions`
Finance-side transaction log.

These tables support accounting, balances, and financial traceability.

---

## Reporting And Analytics

### `source_types`
Types of reporting data sources.

### `report_formats`
Supported report output formats.

### `chart_types`
Chart configuration master data.

### `kpi_statuses`
Status definitions for KPI tracking.

### `data_sources`
Registered report and analytics sources.

### `datasets`
Prepared datasets for reporting.

### `metrics`
Metric definitions and calculations.

### `dashboards`
Dashboard definitions.

### `dashboard_widgets`
Widget configuration for dashboards.

### `reports`
Report master records.

### `report_templates`
Reusable report templates.

### `report_filters`
Saved report filter definitions.

### `report_exports`
Export history and generated file records.

### `scheduler`
Scheduled report or analytics job configuration.

### `report_data`
Materialized data used by reports.

### `kpis`
KPI definitions.

### `kpi_snapshots`
Historical KPI readings.

### `dashboard_kpis`
Join table between dashboards and KPIs.

### `da_reports`
Analytics report records.

### `report_runs`
Individual report execution runs.

### `alerts`
Generated alerts from reporting or monitoring logic.

### `visualizations`
Visualization configuration records.

### `analytics_engines`
Configured analytics engine definitions.

### `data_warehouse`
Warehouse-style analytical storage metadata.

### `etl_jobs`
ETL job definitions and execution metadata.

### `analysis_results`
Result data from analytical jobs.

### `forecast_results`
Forecast output used by planning features.

### `trend_results`
Trend analysis outputs.

### `query_logs`
Historical query audit and debugging records.

### `filter_sets`
Saved filter collections for dashboards or reports.

These tables store reporting, analytics, dashboarding, and ETL metadata.

---

## Workflow And Notifications

### `workflows`
Workflow definitions and state tracking.

### `notifications`
Notification records generated by the system.

### `approval_requests`
Approval workflow records for actions that need human approval.

These tables support routed approvals and user-facing messaging.

---

## System Configuration And Audit

### `audit_logs`
Central audit trail for key operations and lifecycle events.

### `system_config`
System-wide configuration entries.

These tables are shared by the SDK and the consuming teams to keep runtime
behavior visible and traceable.

---

## Views

The schema also exposes compatibility and reporting views, including:

- `Roles`
- `Users`
- `Sessions`
- `Invoices`
- `Expenses`
- `Payables`
- `Receivables`
- `Ledger`
- `Transactions`
- `Payments`
- `Reports`
- `SystemConfig`
- `crm_leads`
- `sales_opportunities`
- `sales_quotations`
- `customer_interactions`
- `segments`
- `materials`
- `automation_orders`
- `bom_header`
- `po_line_items`
- `quality_checks`
- `scheduler`
- `report_data`
- `budget`
- `assignment`
- `attendance_record`
- `candidate`
- `leave_request`
- `payroll`

These views provide compatibility with the consuming application code and make
the shared schema easier to read from a business perspective.

---

## Key Notes

- Cross-subsystem references are intentionally kept flexible so each team can
  evolve independently.
- Permission enforcement is done through `permission_matrix`.
- Ownership metadata lives in `data_ownership`.
- The schema is local-first and does not rely on a central RDS database.

---

## Reference Summary

If you need the exact table definitions, constraints, and view SQL, open
`schema.sql`.

