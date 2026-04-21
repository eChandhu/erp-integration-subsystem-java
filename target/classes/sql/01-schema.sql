CREATE DATABASE IF NOT EXISTS erp_subsystem;
USE erp_subsystem;

SET FOREIGN_KEY_CHECKS = 0;

DELIMITER //
CREATE PROCEDURE drop_object_if_exists(IN obj_name VARCHAR(64))
BEGIN
    DECLARE obj_type VARCHAR(20);

    SELECT TABLE_TYPE
    INTO obj_type
    FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = obj_name
    LIMIT 1;

    IF obj_type = 'VIEW' THEN
        SET @drop_sql = CONCAT('DROP VIEW `', obj_name, '`');
        PREPARE stmt FROM @drop_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    ELSEIF obj_type = 'BASE TABLE' THEN
        SET @drop_sql = CONCAT('DROP TABLE `', obj_name, '`');
        PREPARE stmt FROM @drop_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END //
DELIMITER ;

CALL drop_object_if_exists('crm_leads');
CALL drop_object_if_exists('sales_opportunities');
CALL drop_object_if_exists('sales_quotations');
CALL drop_object_if_exists('customer_interactions');
CALL drop_object_if_exists('project');
CALL drop_object_if_exists('task');
CALL drop_object_if_exists('resource');
CALL drop_object_if_exists('milestone');
CALL drop_object_if_exists('dependency');
CALL drop_object_if_exists('risk');
CALL drop_object_if_exists('expense');
CALL drop_object_if_exists('projects');
CALL drop_object_if_exists('project_tasks');
CALL drop_object_if_exists('project_resources');
CALL drop_object_if_exists('project_milestones');
CALL drop_object_if_exists('project_expenses');
CALL drop_object_if_exists('project_risks');
CALL drop_object_if_exists('task_dependencies');
DROP PROCEDURE drop_object_if_exists;

DROP VIEW IF EXISTS Roles;
DROP VIEW IF EXISTS Users;
DROP VIEW IF EXISTS Sessions;
DROP VIEW IF EXISTS Invoices;
DROP VIEW IF EXISTS Expenses;
DROP VIEW IF EXISTS Payables;
DROP VIEW IF EXISTS Receivables;
DROP VIEW IF EXISTS Ledger;
DROP VIEW IF EXISTS Transactions;
DROP VIEW IF EXISTS Payments;
DROP VIEW IF EXISTS Reports;
DROP VIEW IF EXISTS SystemConfig;
DROP VIEW IF EXISTS user;
DROP VIEW IF EXISTS customer;
DROP VIEW IF EXISTS report;
DROP VIEW IF EXISTS filter;
DROP VIEW IF EXISTS report_template;
DROP VIEW IF EXISTS export;
DROP VIEW IF EXISTS crm_leads;
DROP VIEW IF EXISTS sales_opportunities;
DROP VIEW IF EXISTS sales_quotations;
DROP VIEW IF EXISTS customer_interactions;
DROP VIEW IF EXISTS segments;
DROP VIEW IF EXISTS materials;
DROP VIEW IF EXISTS automation_orders;
DROP VIEW IF EXISTS bom_header;
DROP VIEW IF EXISTS po_line_items;
DROP VIEW IF EXISTS quality_checks;
DROP VIEW IF EXISTS scheduler;
DROP VIEW IF EXISTS report_data;
DROP VIEW IF EXISTS budget;
DROP VIEW IF EXISTS assignment;
DROP VIEW IF EXISTS attendance_record;
DROP VIEW IF EXISTS candidate;
DROP VIEW IF EXISTS leave_request;
DROP VIEW IF EXISTS payroll;

DROP TABLE IF EXISTS inventory_reorders;
DROP TABLE IF EXISTS suppliers_purchase_seed;
DROP TABLE IF EXISTS analytics_engines;
DROP TABLE IF EXISTS visualizations;
DROP TABLE IF EXISTS filter_sets;
DROP TABLE IF EXISTS query_logs;
DROP TABLE IF EXISTS trend_results;
DROP TABLE IF EXISTS forecast_results;
DROP TABLE IF EXISTS analysis_results;
DROP TABLE IF EXISTS etl_jobs;
DROP TABLE IF EXISTS data_warehouse;
DROP TABLE IF EXISTS finance_transactions;
DROP TABLE IF EXISTS hr_records;
DROP TABLE IF EXISTS sales_records;
DROP TABLE IF EXISTS kpi_statuses;
DROP TABLE IF EXISTS chart_types;
DROP TABLE IF EXISTS report_formats;
DROP TABLE IF EXISTS source_types;
DROP TABLE IF EXISTS dashboard_widgets;
DROP TABLE IF EXISTS dashboards;
DROP TABLE IF EXISTS metrics;
DROP TABLE IF EXISTS datasets;
DROP TABLE IF EXISTS data_sources;
DROP TABLE IF EXISTS report_runs;
DROP TABLE IF EXISTS da_reports;
DROP TABLE IF EXISTS dashboard_kpis;
DROP TABLE IF EXISTS alerts;
DROP TABLE IF EXISTS kpi_snapshots;
DROP TABLE IF EXISTS kpis;
DROP TABLE IF EXISTS task_dependencies;
DROP TABLE IF EXISTS project_team_members;
DROP TABLE IF EXISTS refunds;
DROP TABLE IF EXISTS workflows;
DROP TABLE IF EXISTS risk_records;
DROP TABLE IF EXISTS automation_expenses;
DROP TABLE IF EXISTS inventory_transactions;
DROP TABLE IF EXISTS inventory_locations;
DROP TABLE IF EXISTS bom_items;
DROP TABLE IF EXISTS components;
DROP TABLE IF EXISTS execution_logs;
DROP TABLE IF EXISTS routing_steps;
DROP TABLE IF EXISTS assembly_line_work_centers;
DROP TABLE IF EXISTS assembly_lines;
DROP TABLE IF EXISTS work_centers;
DROP TABLE IF EXISTS goods_receipts;
DROP TABLE IF EXISTS purchase_order_lines;
DROP TABLE IF EXISTS purchase_requisitions;
DROP TABLE IF EXISTS supplier_invoices;
DROP TABLE IF EXISTS customer_invoices;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS ledger;
DROP TABLE IF EXISTS system_config;
DROP TABLE IF EXISTS receivables;
DROP TABLE IF EXISTS payables;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS assets;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS campaign_metrics;
DROP TABLE IF EXISTS campaign_messages;
DROP TABLE IF EXISTS message_templates;
DROP TABLE IF EXISTS segment_members;
DROP TABLE IF EXISTS customer_segments;
DROP TABLE IF EXISTS consent_preferences;
DROP TABLE IF EXISTS user_sessions;
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS approval_requests;
DROP TABLE IF EXISTS report_exports;
DROP TABLE IF EXISTS report_filters;
DROP TABLE IF EXISTS report_templates;
DROP TABLE IF EXISTS report_data;
DROP TABLE IF EXISTS scheduler;
DROP TABLE IF EXISTS reports;
DROP TABLE IF EXISTS project_risks;
DROP TABLE IF EXISTS project_expenses;
DROP TABLE IF EXISTS project_milestones;
DROP TABLE IF EXISTS assignment;
DROP TABLE IF EXISTS budget;
DROP TABLE IF EXISTS project_resources;
DROP TABLE IF EXISTS project_tasks;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS quality_inspections;
DROP TABLE IF EXISTS onboarding_activity_log;
DROP TABLE IF EXISTS onboarding_record;
DROP TABLE IF EXISTS workforce_plan;
DROP TABLE IF EXISTS promotion;
DROP TABLE IF EXISTS payroll;
DROP TABLE IF EXISTS leave_request;
DROP TABLE IF EXISTS leave_balance;
DROP TABLE IF EXISTS claim;
DROP TABLE IF EXISTS candidate;
DROP TABLE IF EXISTS benefit_enrollment;
DROP TABLE IF EXISTS attendance_record;
DROP TABLE IF EXISTS appraisal;
DROP TABLE IF EXISTS production_orders;
DROP TABLE IF EXISTS mrp_plans;
DROP TABLE IF EXISTS routings;
DROP TABLE IF EXISTS bills_of_materials;
DROP TABLE IF EXISTS demand_forecasts;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS purchase_orders;
DROP TABLE IF EXISTS supplier_materials;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS quote_items;
DROP TABLE IF EXISTS quotes;
DROP TABLE IF EXISTS deals;
DROP TABLE IF EXISTS interactions;
DROP TABLE IF EXISTS leads;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS manufactured_cars;
DROP TABLE IF EXISTS inventory_items;
DROP TABLE IF EXISTS campaigns;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS attendance_records;
DROP TABLE IF EXISTS leave_requests;
DROP TABLE IF EXISTS performance_reviews;
DROP TABLE IF EXISTS payroll_records;
DROP TABLE IF EXISTS recruitment_candidates;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS role_permissions;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS data_ownership;
DROP TABLE IF EXISTS permission_matrix;
DROP TABLE IF EXISTS integration_registry;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE integration_registry (
    subsystem_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    subsystem_name VARCHAR(80) UNIQUE NOT NULL,
    api_key_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE permission_matrix (
    permission_id INT AUTO_INCREMENT PRIMARY KEY,
    subsystem_id CHAR(36) NOT NULL,
    resource_table VARCHAR(80) NOT NULL,
    can_create BOOLEAN DEFAULT FALSE,
    can_read BOOLEAN DEFAULT FALSE,
    can_update BOOLEAN DEFAULT FALSE,
    can_delete BOOLEAN DEFAULT FALSE,
    readable_columns JSON NOT NULL,
    writable_columns JSON NOT NULL,
    allowed_row_filter TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_permission_subsystem
        FOREIGN KEY (subsystem_id) REFERENCES integration_registry(subsystem_id),
    CONSTRAINT uq_permission UNIQUE (subsystem_id, resource_table)
);

CREATE TABLE data_ownership (
    ownership_id INT AUTO_INCREMENT PRIMARY KEY,
    resource_table VARCHAR(80) NOT NULL UNIQUE,
    owner_subsystem_id CHAR(36) NOT NULL,
    stewardship_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_data_owner_subsystem FOREIGN KEY (owner_subsystem_id) REFERENCES integration_registry(subsystem_id)
);

CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(80) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    department VARCHAR(80),
    is_active BOOLEAN DEFAULT TRUE,
    last_login DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

CREATE TABLE user_sessions (
    session_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    last_access_at TIMESTAMP NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    revoked_at TIMESTAMP NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_sessions_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE role_permissions (
    role_permission_id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL,
    module_name VARCHAR(80) NOT NULL,
    can_create BOOLEAN DEFAULT FALSE,
    can_read BOOLEAN DEFAULT FALSE,
    can_update BOOLEAN DEFAULT FALSE,
    can_delete BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE
);

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    employee_name VARCHAR(120) NOT NULL,
    department VARCHAR(80),
    job_role VARCHAR(100),
    assigned_assembly_line VARCHAR(80),
    shift_schedule VARCHAR(80),
    email VARCHAR(150),
    phone_no VARCHAR(30),
    hire_date DATE,
    salary DECIMAL(15,2),
    employment_status VARCHAR(30),
    CONSTRAINT fk_employee_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    account_code VARCHAR(30) NOT NULL UNIQUE,
    account_name VARCHAR(120) NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    parent_account_id INT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_accounts_parent FOREIGN KEY (parent_account_id) REFERENCES accounts(account_id)
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(150),
    phone VARCHAR(30),
    segment VARCHAR(50),
    region VARCHAR(80),
    interested_car_model VARCHAR(100),
    purchased_vin VARCHAR(50),
    vehicle_model_year VARCHAR(30),
    lifetime_value DECIMAL(15,2),
    status VARCHAR(30),
    last_contact_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE leads (
    lead_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    status VARCHAR(30) DEFAULT 'NEW',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE interactions (
    interaction_id INT AUTO_INCREMENT PRIMARY KEY,
    lead_id INT NULL,
    customer_id INT NULL,
    interaction_type VARCHAR(50) NOT NULL,
    notes TEXT,
    interaction_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_interaction_lead FOREIGN KEY (lead_id) REFERENCES leads(lead_id),
    CONSTRAINT fk_interaction_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE deals (
    deal_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NULL,
    quote_id INT NULL,
    amount DOUBLE NULL,
    stage VARCHAR(50),
    status VARCHAR(50),
    probability DOUBLE NULL,
    expected_close_date DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_deal_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE quotes (
    quote_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NULL,
    deal_id INT NULL,
    total_amount DOUBLE,
    discount DOUBLE,
    final_amount DOUBLE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_quote_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE quote_items (
    quote_item_id INT AUTO_INCREMENT PRIMARY KEY,
    quote_id INT NOT NULL,
    product_name VARCHAR(150),
    quantity INT,
    price DOUBLE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_quote_item_quote FOREIGN KEY (quote_id) REFERENCES quotes(quote_id)
);

ALTER TABLE deals
ADD CONSTRAINT fk_deal_quote FOREIGN KEY (quote_id) REFERENCES quotes(quote_id);

ALTER TABLE quotes
ADD CONSTRAINT fk_quote_deal FOREIGN KEY (deal_id) REFERENCES deals(deal_id);

CREATE TABLE campaigns (
    campaign_id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_title VARCHAR(120) NOT NULL,
    campaign_type VARCHAR(50),
    target_vehicle_segment VARCHAR(100),
    campaign_budget DECIMAL(15,2),
    target_leads JSON NULL,
    start_date DATE,
    end_date DATE,
    campaign_roi DECIMAL(10,2),
    campaign_results JSON NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE customer_segments (
    segment_id INT AUTO_INCREMENT PRIMARY KEY,
    segment_name VARCHAR(100) NOT NULL UNIQUE,
    segment_description TEXT,
    criteria_definition TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE segment_members (
    segment_member_id INT AUTO_INCREMENT PRIMARY KEY,
    segment_id INT NOT NULL,
    customer_id INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_segment_member_segment FOREIGN KEY (segment_id) REFERENCES customer_segments(segment_id),
    CONSTRAINT fk_segment_member_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT uq_segment_member UNIQUE (segment_id, customer_id)
);

CREATE TABLE message_templates (
    template_id INT AUTO_INCREMENT PRIMARY KEY,
    template_name VARCHAR(100) NOT NULL UNIQUE,
    channel VARCHAR(30) NOT NULL,
    subject_template VARCHAR(255),
    body_template TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE campaign_messages (
    campaign_message_id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    customer_id INT NOT NULL,
    template_id INT NULL,
    channel VARCHAR(30) NOT NULL,
    delivery_status VARCHAR(30) NOT NULL,
    sent_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    opened_at TIMESTAMP NULL,
    clicked_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_campaign_message_campaign FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id),
    CONSTRAINT fk_campaign_message_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_campaign_message_template FOREIGN KEY (template_id) REFERENCES message_templates(template_id)
);

CREATE TABLE campaign_metrics (
    metric_id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    metric_date DATE NOT NULL,
    impressions INT DEFAULT 0,
    clicks INT DEFAULT 0,
    conversions INT DEFAULT 0,
    revenue_generated DECIMAL(15,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_campaign_metrics_campaign FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id),
    CONSTRAINT uq_campaign_metric UNIQUE (campaign_id, metric_date)
);

CREATE TABLE consent_preferences (
    consent_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    channel VARCHAR(30) NOT NULL,
    is_opted_in BOOLEAN DEFAULT FALSE,
    consent_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    source VARCHAR(80),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_consent_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE inventory_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(120) NOT NULL,
    description TEXT,
    current_stock INT DEFAULT 0,
    minimum_level INT DEFAULT 0,
    unit VARCHAR(30),
    price DECIMAL(15,2),
    location VARCHAR(120),
    status VARCHAR(30),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE inventory_locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    location_code VARCHAR(50) NOT NULL UNIQUE,
    warehouse_name VARCHAR(100) NOT NULL,
    aisle VARCHAR(30),
    bin_code VARCHAR(30),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE inventory_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,
    location_id INT NULL,
    transaction_type VARCHAR(30) NOT NULL,
    quantity INT NOT NULL,
    reference_type VARCHAR(50),
    reference_id VARCHAR(80),
    transaction_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_tx_item FOREIGN KEY (item_id) REFERENCES inventory_items(item_id),
    CONSTRAINT fk_inventory_tx_location FOREIGN KEY (location_id) REFERENCES inventory_locations(location_id),
    CONSTRAINT fk_inventory_tx_user FOREIGN KEY (created_by) REFERENCES users(user_id)
);

CREATE TABLE inventory_reorders (
    reorder_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,
    requested_by INT NULL,
    quantity INT NOT NULL,
    reorder_status VARCHAR(30) DEFAULT 'Requested',
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reorder_item FOREIGN KEY (item_id) REFERENCES inventory_items(item_id),
    CONSTRAINT fk_reorder_user FOREIGN KEY (requested_by) REFERENCES users(user_id)
);

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(120) NOT NULL,
    contact_info TEXT,
    address TEXT
);

CREATE TABLE manufactured_cars (
    vin VARCHAR(50) PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    chassis_type VARCHAR(80) NOT NULL,
    build_status VARCHAR(40) NOT NULL,
    assembly_line VARCHAR(80),
    color VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    car_vin VARCHAR(50) NULL,
    customer_name VARCHAR(120),
    customer_contact_details TEXT,
    vehicle_model VARCHAR(100),
    vehicle_variant VARCHAR(100),
    vehicle_color VARCHAR(50),
    custom_features TEXT,
    order_date DATE DEFAULT (CURRENT_DATE),
    order_status VARCHAR(30),
    total_amount DECIMAL(15,2),
    payment_status VARCHAR(30),
    order_details TEXT,
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_order_car FOREIGN KEY (car_vin) REFERENCES manufactured_cars(vin)
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    CONSTRAINT fk_order_item_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_order_item_item FOREIGN KEY (item_id) REFERENCES inventory_items(item_id)
);

CREATE TABLE suppliers_purchase_seed (
    ignored_id INT
);

DROP TABLE suppliers_purchase_seed;

CREATE TABLE purchase_orders (
    po_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    order_date DATE DEFAULT (CURRENT_DATE),
    status VARCHAR(30),
    amount DECIMAL(15,2),
    CONSTRAINT fk_po_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE purchase_order_lines (
    po_line_id INT AUTO_INCREMENT PRIMARY KEY,
    po_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    uom VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_po_line_po FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id),
    CONSTRAINT fk_po_line_item FOREIGN KEY (item_id) REFERENCES inventory_items(item_id)
);

CREATE TABLE goods_receipts (
    receipt_id INT AUTO_INCREMENT PRIMARY KEY,
    po_id INT NOT NULL,
    received_date DATE,
    received_by INT NULL,
    status VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_goods_receipt_po FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id),
    CONSTRAINT fk_goods_receipt_employee FOREIGN KEY (received_by) REFERENCES employees(employee_id)
);

CREATE TABLE shipments (
    shipment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    shipment_status VARCHAR(50),
    dispatch_date DATE,
    delivery_date DATE,
    carrier_info VARCHAR(100),
    CONSTRAINT fk_shipment_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    generated_date DATE DEFAULT (CURRENT_DATE),
    invoice_amount DECIMAL(15,2),
    tax_details DECIMAL(15,2),
    invoice_status VARCHAR(30),
    payment_status VARCHAR(30),
    due_date DATE,
    CONSTRAINT fk_invoice_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    payment_method VARCHAR(50),
    payment_amount DECIMAL(15,2),
    payment_status VARCHAR(30),
    transaction_details TEXT,
    payment_date DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_payment_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id)
);

CREATE TABLE demand_forecasts (
    forecast_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,
    predicted_demand INT,
    recommended_reorder INT,
    prediction_date DATE,
    confidence_score DECIMAL(5,2),
    CONSTRAINT fk_forecast_item FOREIGN KEY (item_id) REFERENCES inventory_items(item_id)
);

CREATE TABLE components (
    component_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL UNIQUE,
    component_code VARCHAR(60) NOT NULL UNIQUE,
    specification TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_component_item FOREIGN KEY (item_id) REFERENCES inventory_items(item_id)
);

CREATE TABLE bills_of_materials (
    bom_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(120),
    material_list JSON NULL,
    bom_version VARCHAR(30),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE bom_items (
    bom_item_id INT AUTO_INCREMENT PRIMARY KEY,
    bom_id INT NOT NULL,
    component_id INT NOT NULL,
    quantity_required DECIMAL(15,2) NOT NULL,
    uom VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_bom_item_bom FOREIGN KEY (bom_id) REFERENCES bills_of_materials(bom_id),
    CONSTRAINT fk_bom_item_component FOREIGN KEY (component_id) REFERENCES components(component_id),
    CONSTRAINT uq_bom_component UNIQUE (bom_id, component_id)
);

CREATE TABLE routings (
    routing_id INT AUTO_INCREMENT PRIMARY KEY,
    bom_id INT NOT NULL,
    work_center_id VARCHAR(50),
    assigned_operator_id INT NULL,
    setup_time INT,
    run_time INT,
    CONSTRAINT fk_routing_bom FOREIGN KEY (bom_id) REFERENCES bills_of_materials(bom_id),
    CONSTRAINT fk_routing_employee FOREIGN KEY (assigned_operator_id) REFERENCES employees(employee_id)
);

CREATE TABLE mrp_plans (
    mrp_id INT AUTO_INCREMENT PRIMARY KEY,
    gross_requirements DECIMAL(15,2),
    net_requirements DECIMAL(15,2),
    inventory_on_hand DECIMAL(15,2),
    sales_forecast_qty DECIMAL(15,2),
    customer_order_ref VARCHAR(100)
);

CREATE TABLE production_orders (
    production_order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NULL,
    car_vin VARCHAR(50) NULL,
    order_quantity INT,
    order_status VARCHAR(30),
    due_date DATE,
    CONSTRAINT fk_prod_order_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_prod_order_car FOREIGN KEY (car_vin) REFERENCES manufactured_cars(vin)
);

CREATE TABLE quality_inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    production_order_id INT NOT NULL,
    pass_fail_status VARCHAR(10),
    pass_rate DECIMAL(5,2),
    inspection_date DATE DEFAULT (CURRENT_DATE),
    compliance_code VARCHAR(50),
    CONSTRAINT fk_inspection_prod_order FOREIGN KEY (production_order_id) REFERENCES production_orders(production_order_id)
);

CREATE TABLE recruitment_candidates (
    candidate_id INT AUTO_INCREMENT PRIMARY KEY,
    candidate_name VARCHAR(120) NOT NULL,
    contact_info TEXT,
    resume_data TEXT,
    interview_score DECIMAL(4,2),
    application_status VARCHAR(50)
);

CREATE TABLE payroll_records (
    payroll_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    gross_salary DECIMAL(15,2),
    deductions DECIMAL(15,2),
    net_pay DECIMAL(15,2),
    tax_record TEXT,
    processed_date DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_payroll_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE attendance_records (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    overtime_hours DECIMAL(5,2) DEFAULT 0,
    CONSTRAINT fk_attendance_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE leave_requests (
    leave_request_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    leave_from_date DATE NOT NULL,
    leave_to_date DATE NOT NULL,
    leave_type VARCHAR(30),
    leave_status VARCHAR(30) NOT NULL,
    CONSTRAINT fk_leave_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE performance_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    rating DECIMAL(3,2),
    feedback TEXT,
    review_date DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_review_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE appraisal (
    appraise_id VARCHAR(255) PRIMARY KEY,
    appraisal_status ENUM('COMPLETED', 'PENDING') NOT NULL,
    deadline_date DATE NOT NULL,
    employee_id VARCHAR(255) NOT NULL,
    feedback VARCHAR(255) NULL,
    locked BOOLEAN NOT NULL DEFAULT FALSE,
    rating DOUBLE NOT NULL
);

CREATE TABLE attendance_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    employee_id VARCHAR(20) NOT NULL,
    attendance_date DATE NOT NULL,
    check_in_time TIME NULL,
    check_out_time TIME NULL,
    overtime_hours DOUBLE NULL
);

CREATE TABLE benefit_enrollment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    employee_id VARCHAR(20) NOT NULL,
    enrollment_status ENUM('ENROLLED', 'NOT_ENROLLED', 'PENDING') NOT NULL,
    health_plan VARCHAR(255) NULL,
    insurance_plan VARCHAR(255) NULL,
    insurance_coverage_status ENUM('ACTIVE', 'INACTIVE') NULL
);

CREATE TABLE candidate (
    candidate_id VARCHAR(255) PRIMARY KEY,
    candidate_name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255) NOT NULL,
    resume_data VARCHAR(255) NOT NULL,
    interview_score DOUBLE NULL,
    application_status ENUM('APPLIED', 'INTERVIEW', 'REJECTED', 'SELECTED', 'SHORTLISTED') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE claim (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    employee_id VARCHAR(20) NOT NULL,
    claim_type VARCHAR(255) NULL,
    amount DECIMAL(10,2) NULL,
    claim_status ENUM('APPROVED', 'PENDING') NOT NULL
);

CREATE TABLE leave_balance (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    employee_id VARCHAR(20) NOT NULL UNIQUE,
    balance INT NOT NULL DEFAULT 20
);

CREATE TABLE leave_request (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    employee_id VARCHAR(20) NOT NULL,
    leave_from_date DATE NOT NULL,
    leave_to_date DATE NOT NULL,
    leave_status ENUM('APPROVED', 'PENDING', 'REJECTED') NOT NULL
);

CREATE TABLE payroll (
    payrollId BIGINT PRIMARY KEY AUTO_INCREMENT,
    currentMonthTotal DECIMAL(38,2) NULL,
    deductions DECIMAL(38,2) NULL,
    grossSalary DECIMAL(38,2) NULL,
    netPay DECIMAL(38,2) NULL,
    role VARCHAR(255) NULL,
    salaryTransferRecord VARCHAR(255) NULL,
    employee_id VARCHAR(20) NULL,
    month VARCHAR(255) NOT NULL,
    year INT NOT NULL
);

CREATE TABLE promotion (
    promotion_id VARCHAR(255) PRIMARY KEY,
    effective_date DATE NOT NULL,
    employee_id VARCHAR(255) NOT NULL,
    new_role VARCHAR(255) NOT NULL
);

CREATE TABLE workforce_plan (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department VARCHAR(255) NOT NULL,
    hiring_forecast INT NOT NULL,
    hr_cost_projections DECIMAL(38,2) NOT NULL,
    open_positions INT NOT NULL,
    quarter VARCHAR(255) NOT NULL,
    total_budget DECIMAL(38,2) NOT NULL
);

CREATE TABLE onboarding_record (
    onboarding_id VARCHAR(255) PRIMARY KEY,
    assigned_employee_id VARCHAR(255) NOT NULL,
    background_check_status ENUM('CLEARED', 'FAILED', 'PENDING') NOT NULL,
    document_verification_status ENUM('PENDING', 'REJECTED', 'VERIFIED') NOT NULL,
    employee_name VARCHAR(255) NOT NULL,
    pipeline_status ENUM('ACTIVE_ONBOARDING', 'BACKGROUND_CHECK', 'DOCUMENT_VERIFICATION', 'EMPLOYEE_ASSIGNED', 'VERIFIED') NOT NULL,
    verified_record BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE onboarding_activity_log (
    onboarding_id VARCHAR(255) NOT NULL,
    activity VARCHAR(255) NULL
);

CREATE TABLE project (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    manager_name VARCHAR(120),
    start_date DATE,
    end_date DATE,
    status VARCHAR(30),
    objectives TEXT,
    progress_pct DECIMAL(5,2),
    budget_total DECIMAL(15,2),
    budget_spent DECIMAL(15,2),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE task (
    id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    task_name VARCHAR(120),
    description TEXT,
    start_date DATE,
    due_date DATE,
    status VARCHAR(30),
    priority VARCHAR(30),
    assigned_to INT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_task_project FOREIGN KEY (project_id) REFERENCES project(id),
    CONSTRAINT fk_task_employee FOREIGN KEY (assigned_to) REFERENCES employees(employee_id)
);

CREATE TABLE dependency (
    id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    depends_on_task_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_dependency_task FOREIGN KEY (task_id) REFERENCES task(id),
    CONSTRAINT fk_dependency_depends FOREIGN KEY (depends_on_task_id) REFERENCES task(id),
    CONSTRAINT uq_dependency UNIQUE (task_id, depends_on_task_id)
);

CREATE TABLE resource (
    id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    name VARCHAR(120),
    role VARCHAR(80),
    availability BOOLEAN,
    skill_set VARCHAR(120),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_resource_project FOREIGN KEY (project_id) REFERENCES project(id)
);

CREATE TABLE project_team_members (
    project_team_member_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    user_id INT NOT NULL,
    role_in_project VARCHAR(80),
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_project_team_project FOREIGN KEY (project_id) REFERENCES project(id),
    CONSTRAINT fk_project_team_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT uq_project_team UNIQUE (project_id, user_id)
);

CREATE TABLE assignment (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    resource_id INT NOT NULL,
    assigned_on DATE DEFAULT (CURRENT_DATE),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_assignment_task FOREIGN KEY (task_id) REFERENCES task(id) ON DELETE CASCADE,
    CONSTRAINT fk_assignment_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON DELETE CASCADE,
    CONSTRAINT uq_assignment UNIQUE (task_id, resource_id)
);

CREATE TABLE budget (
    budget_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    allocated_amount DECIMAL(15,2) NOT NULL,
    approved_amount DECIMAL(15,2) NULL,
    fiscal_period VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_budget_project FOREIGN KEY (project_id) REFERENCES project(id) ON DELETE CASCADE
);

CREATE TABLE source_types (
    source_type_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    type_code VARCHAR(50) NOT NULL UNIQUE,
    type_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE report_formats (
    report_format_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    format_code VARCHAR(50) NOT NULL UNIQUE,
    format_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE chart_types (
    chart_type_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    chart_code VARCHAR(50) NOT NULL UNIQUE,
    chart_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE kpi_statuses (
    kpi_status_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    status_code VARCHAR(50) NOT NULL UNIQUE,
    status_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE data_sources (
    data_source_id INT AUTO_INCREMENT PRIMARY KEY,
    source_name VARCHAR(120) NOT NULL UNIQUE,
    source_type VARCHAR(50) NOT NULL,
    source_type_id BIGINT NULL,
    car_model VARCHAR(150) NULL,
    data_timestamp TIMESTAMP NULL,
    raw_data JSON NULL,
    connection_details TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_data_sources_lookup_type FOREIGN KEY (source_type_id) REFERENCES source_types(source_type_id)
);

CREATE TABLE datasets (
    dataset_id INT AUTO_INCREMENT PRIMARY KEY,
    data_source_id INT NOT NULL,
    dataset_name VARCHAR(120) NOT NULL,
    description VARCHAR(255) NULL,
    processing_stage VARCHAR(30) NOT NULL,
    source_type_id BIGINT NULL,
    schema_definition TEXT,
    refresh_frequency VARCHAR(50),
    payload JSON NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_dataset_source FOREIGN KEY (data_source_id) REFERENCES data_sources(data_source_id),
    CONSTRAINT fk_dataset_lookup_type FOREIGN KEY (source_type_id) REFERENCES source_types(source_type_id),
    CONSTRAINT uq_dataset_name UNIQUE (data_source_id, dataset_name, processing_stage)
);

CREATE TABLE metrics (
    metric_id INT AUTO_INCREMENT PRIMARY KEY,
    dataset_id INT NOT NULL,
    metric_name VARCHAR(120) NOT NULL,
    metric_formula TEXT,
    unit VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_metric_dataset FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id)
);

CREATE TABLE dashboards (
    dashboard_id INT AUTO_INCREMENT PRIMARY KEY,
    dashboard_name VARCHAR(120) NOT NULL UNIQUE,
    owner_user_id INT NULL,
    user_name VARCHAR(100) NULL,
    description TEXT,
    dashboard_payload JSON NULL,
    last_updated TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_dashboard_user FOREIGN KEY (owner_user_id) REFERENCES users(user_id)
);

CREATE TABLE dashboard_widgets (
    widget_id INT AUTO_INCREMENT PRIMARY KEY,
    dashboard_id INT NOT NULL,
    widget_title VARCHAR(120) NOT NULL,
    widget_type VARCHAR(50) NOT NULL,
    metric_id INT NULL,
    dataset_id INT NULL,
    position_x INT DEFAULT 0,
    position_y INT DEFAULT 0,
    width_units INT DEFAULT 1,
    height_units INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_widget_dashboard FOREIGN KEY (dashboard_id) REFERENCES dashboards(dashboard_id),
    CONSTRAINT fk_widget_metric FOREIGN KEY (metric_id) REFERENCES metrics(metric_id),
    CONSTRAINT fk_widget_dataset FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id)
);

CREATE TABLE milestone (
    id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    name VARCHAR(120),
    target_date DATE,
    completion_status BOOLEAN,
    description TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_milestone_project FOREIGN KEY (project_id) REFERENCES project(id)
);

CREATE TABLE expense (
    id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    expense_date DATE,
    description TEXT,
    category VARCHAR(80),
    amount DECIMAL(15,2),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_expense_project FOREIGN KEY (project_id) REFERENCES project(id)
);

CREATE TABLE risk (
    id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    description TEXT,
    severity VARCHAR(30),
    status VARCHAR(30),
    mitigation_plan TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_risk_project FOREIGN KEY (project_id) REFERENCES project(id)
);

CREATE TABLE reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(120),
    report_name VARCHAR(200) NULL,
    report_type VARCHAR(100),
    generated_by INT NULL,
    generated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    start_date DATE,
    end_date DATE,
    format_id BIGINT NULL,
    report_data JSON NULL,
    content TEXT,
    CONSTRAINT fk_report_user FOREIGN KEY (generated_by) REFERENCES users(user_id),
    CONSTRAINT fk_report_format_lookup FOREIGN KEY (format_id) REFERENCES report_formats(report_format_id)
);

CREATE TABLE report_templates (
    template_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(120),
    layout VARCHAR(120),
    report_type VARCHAR(100)
);

CREATE TABLE report_filters (
    filter_id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    date_range VARCHAR(50),
    date_from DATE NULL,
    date_to DATE NULL,
    customer_segment VARCHAR(50),
    CONSTRAINT fk_report_filter_report FOREIGN KEY (report_id) REFERENCES reports(report_id)
);

CREATE TABLE report_exports (
    export_id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    format VARCHAR(20),
    export_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_report_export_report FOREIGN KEY (report_id) REFERENCES reports(report_id)
);

CREATE TABLE scheduler (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    schedule_time DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_scheduler_report FOREIGN KEY (report_id) REFERENCES reports(report_id) ON DELETE CASCADE
);

CREATE TABLE report_data (
    data_id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    customer_id INT NOT NULL,
    total_value DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_report_data_report FOREIGN KEY (report_id) REFERENCES reports(report_id) ON DELETE CASCADE,
    CONSTRAINT fk_report_data_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

CREATE TABLE approval_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    request_type VARCHAR(80),
    related_order_id INT NULL,
    amount DECIMAL(15,2),
    requested_by INT NULL,
    status VARCHAR(30),
    rejection_reason TEXT,
    request_date DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_approval_order FOREIGN KEY (related_order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_approval_user FOREIGN KEY (requested_by) REFERENCES users(user_id)
);

CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50),
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id VARCHAR(80) NULL,
    action VARCHAR(100) NOT NULL,
    performed_by INT NULL,
    subsystem_name VARCHAR(80),
    resource_table VARCHAR(80),
    resource_id VARCHAR(80),
    success BOOLEAN NOT NULL,
    latency_ms INT NULL,
    error_code VARCHAR(50) NULL,
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT,
    error_message TEXT,
    CONSTRAINT fk_audit_user FOREIGN KEY (performed_by) REFERENCES users(user_id)
);

CREATE TABLE assets (
    asset_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_tag VARCHAR(60) NOT NULL UNIQUE,
    asset_name VARCHAR(120) NOT NULL,
    category VARCHAR(50),
    purchase_date DATE,
    purchase_value DECIMAL(15,2),
    depreciation_method VARCHAR(50),
    useful_life_months INT,
    status VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE expenses (
    expense_id INT AUTO_INCREMENT PRIMARY KEY,
    expense_date DATE NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(80),
    amount DECIMAL(15,2) NOT NULL,
    approved_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_expense_user FOREIGN KEY (approved_by) REFERENCES users(user_id)
);

CREATE TABLE receivables (
    receivable_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    invoice_id INT NULL,
    account_id INT NULL,
    amount_due DECIMAL(15,2) NOT NULL,
    due_date DATE,
    status VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_receivable_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_receivable_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    CONSTRAINT fk_receivable_account FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE payables (
    payable_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    po_id INT NULL,
    account_id INT NULL,
    amount_due DECIMAL(15,2) NOT NULL,
    due_date DATE,
    status VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_payable_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    CONSTRAINT fk_payable_po FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id),
    CONSTRAINT fk_payable_account FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE ledger (
    ledger_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    description VARCHAR(255),
    created_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_ledger_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    ledger_id INT NOT NULL,
    debit DECIMAL(15,2) DEFAULT 0.00,
    credit DECIMAL(15,2) DEFAULT 0.00,
    transaction_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_transaction_ledger FOREIGN KEY (ledger_id) REFERENCES ledger(ledger_id) ON DELETE CASCADE
);

CREATE TABLE system_config (
    config_id INT AUTO_INCREMENT PRIMARY KEY,
    config_key VARCHAR(120) NOT NULL UNIQUE,
    connection_string VARCHAR(255),
    config_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE supplier_materials (
    supplier_id INT NOT NULL,
    item_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (supplier_id, item_id),
    CONSTRAINT fk_supplier_material_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE CASCADE,
    CONSTRAINT fk_supplier_material_item FOREIGN KEY (item_id) REFERENCES inventory_items(item_id) ON DELETE CASCADE
);

CREATE TABLE work_centers (
    work_center_id VARCHAR(50) PRIMARY KEY,
    work_center_name VARCHAR(100) NOT NULL,
    work_center_type VARCHAR(50) NOT NULL,
    capacity_hours DECIMAL(10,2) NOT NULL,
    utilization_pct DECIMAL(5,2) DEFAULT 0,
    location VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE assembly_lines (
    line_id VARCHAR(50) PRIMARY KEY,
    line_name VARCHAR(100) NOT NULL,
    shift_pattern VARCHAR(50) NOT NULL,
    line_status VARCHAR(30) NOT NULL,
    product_item_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_assembly_line_item FOREIGN KEY (product_item_id) REFERENCES inventory_items(item_id)
);

CREATE TABLE assembly_line_work_centers (
    line_id VARCHAR(50) NOT NULL,
    work_center_id VARCHAR(50) NOT NULL,
    PRIMARY KEY (line_id, work_center_id),
    CONSTRAINT fk_alwc_line FOREIGN KEY (line_id) REFERENCES assembly_lines(line_id) ON DELETE CASCADE,
    CONSTRAINT fk_alwc_wc FOREIGN KEY (work_center_id) REFERENCES work_centers(work_center_id) ON DELETE CASCADE
);

CREATE TABLE routing_steps (
    routing_step_id INT AUTO_INCREMENT PRIMARY KEY,
    routing_id INT NOT NULL,
    operation_id VARCHAR(50) NOT NULL,
    sequence_number INT NOT NULL,
    operation_name VARCHAR(100) NOT NULL,
    work_center_id VARCHAR(50) NOT NULL,
    setup_time DECIMAL(10,2) DEFAULT 0,
    run_time DECIMAL(10,2) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_routing_step UNIQUE (routing_id, sequence_number),
    CONSTRAINT fk_routing_step_routing FOREIGN KEY (routing_id) REFERENCES routings(routing_id) ON DELETE CASCADE,
    CONSTRAINT fk_routing_step_wc FOREIGN KEY (work_center_id) REFERENCES work_centers(work_center_id)
);

CREATE TABLE execution_logs (
    execution_log_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    production_order_id INT NOT NULL,
    start_time TIMESTAMP NULL,
    end_time TIMESTAMP NULL,
    operator_id VARCHAR(50),
    qty_produced INT DEFAULT 0,
    scrap_qty INT DEFAULT 0,
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_execution_log_po FOREIGN KEY (production_order_id) REFERENCES production_orders(production_order_id)
);

CREATE TABLE purchase_requisitions (
    requisition_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    status VARCHAR(30) NOT NULL,
    requested_date DATE NOT NULL,
    needed_by_date DATE NULL,
    requested_by VARCHAR(100) NOT NULL,
    approved_by VARCHAR(100) NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_purchase_req_item FOREIGN KEY (item_id) REFERENCES inventory_items(item_id)
);

CREATE TABLE supplier_invoices (
    supplier_invoice_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    po_id INT NOT NULL,
    invoice_amount DECIMAL(15,2) NOT NULL,
    invoice_date DATE NOT NULL,
    due_date DATE NOT NULL,
    payment_status VARCHAR(30) NOT NULL,
    verified_by VARCHAR(100) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_supplier_invoice_po FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id)
);

CREATE TABLE customer_invoices (
    customer_invoice_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    order_id INT NOT NULL,
    qty_produced INT NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL,
    generated_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_customer_invoice_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE automation_expenses (
    automation_expense_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NULL,
    expense_type VARCHAR(100) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    recorded_date DATE NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_automation_expense_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE workflows (
    workflow_id INT AUTO_INCREMENT PRIMARY KEY,
    workflow_name VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE risk_records (
    risk_record_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NULL,
    risk_message VARCHAR(255) NOT NULL,
    severity VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_risk_record_request FOREIGN KEY (request_id) REFERENCES approval_requests(request_id)
);

CREATE TABLE refunds (
    refund_id VARCHAR(20) PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    created_date DATETIME,
    status VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_refund_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE sales_records (
    sales_record_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data_source_id INT NULL,
    car_model VARCHAR(150) NOT NULL,
    units_sold INT NOT NULL,
    revenue DECIMAL(18,2) NOT NULL,
    sales_date TIMESTAMP NOT NULL,
    dealer_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sales_record_source FOREIGN KEY (data_source_id) REFERENCES data_sources(data_source_id) ON DELETE SET NULL,
    CONSTRAINT chk_sales_units_sold CHECK (units_sold >= 0),
    CONSTRAINT chk_sales_revenue CHECK (revenue >= 0)
);

CREATE TABLE hr_records (
    hr_record_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data_source_id INT NULL,
    employee_id VARCHAR(50) NOT NULL UNIQUE,
    employee_name VARCHAR(150) NOT NULL,
    department VARCHAR(100) NOT NULL,
    role VARCHAR(150) NOT NULL,
    joining_date TIMESTAMP NOT NULL,
    salary DECIMAL(18,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_hr_record_source FOREIGN KEY (data_source_id) REFERENCES data_sources(data_source_id) ON DELETE SET NULL,
    CONSTRAINT chk_hr_salary CHECK (salary >= 0)
);

CREATE TABLE finance_transactions (
    finance_transaction_id VARCHAR(50) PRIMARY KEY,
    data_source_id INT NULL,
    car_model VARCHAR(150) NOT NULL,
    amount DECIMAL(18,2) NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    transaction_date TIMESTAMP NOT NULL,
    department VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_finance_tx_source FOREIGN KEY (data_source_id) REFERENCES data_sources(data_source_id) ON DELETE SET NULL,
    CONSTRAINT chk_finance_amount CHECK (amount >= 0)
);

CREATE TABLE kpis (
    kpi_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    kpi_name VARCHAR(200) NULL,
    description TEXT,
    unit VARCHAR(50),
    category VARCHAR(30) NOT NULL,
    data_source_id INT NULL,
    target_value DECIMAL(18,2) NULL,
    actual_value DECIMAL(18,2) NULL,
    status_id BIGINT NULL,
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_kpi_source FOREIGN KEY (data_source_id) REFERENCES data_sources(data_source_id),
    CONSTRAINT fk_kpi_user FOREIGN KEY (created_by) REFERENCES users(user_id),
    CONSTRAINT fk_kpi_status_lookup FOREIGN KEY (status_id) REFERENCES kpi_statuses(kpi_status_id)
);

CREATE TABLE kpi_snapshots (
    snapshot_id INT AUTO_INCREMENT PRIMARY KEY,
    kpi_id INT NOT NULL,
    snapshot_value DECIMAL(15,4) NOT NULL,
    period_label VARCHAR(50) NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    recorded_by INT NULL,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_kpi_snapshot_kpi FOREIGN KEY (kpi_id) REFERENCES kpis(kpi_id),
    CONSTRAINT fk_kpi_snapshot_user FOREIGN KEY (recorded_by) REFERENCES users(user_id)
);

CREATE TABLE data_warehouse (
    warehouse_record_id INT AUTO_INCREMENT PRIMARY KEY,
    car_model VARCHAR(150) NULL,
    data_category VARCHAR(100) NOT NULL,
    stored_data JSON NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dataset_id INT NULL,
    CONSTRAINT fk_data_warehouse_dataset FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id) ON DELETE SET NULL
);

CREATE TABLE etl_jobs (
    etl_job_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    dataset_id INT NULL,
    cleaned_data JSON NULL,
    transformed_data JSON NULL,
    production_count INT NOT NULL DEFAULT 0,
    sales_count INT NOT NULL DEFAULT 0,
    processing_date TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
    CONSTRAINT fk_etl_job_dataset FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id) ON DELETE SET NULL,
    CONSTRAINT chk_etl_production_count CHECK (production_count >= 0),
    CONSTRAINT chk_etl_sales_count CHECK (sales_count >= 0)
);

CREATE TABLE analysis_results (
    analysis_id VARCHAR(20) PRIMARY KEY,
    metric_name VARCHAR(150) NOT NULL,
    metric_value DECIMAL(18,2) NOT NULL,
    production_efficiency DECIMAL(5,4) NOT NULL,
    defect_rate DECIMAL(5,4) NOT NULL,
    analysis_date TIMESTAMP NOT NULL,
    source_dataset_id INT NOT NULL,
    breakdown JSON NULL,
    CONSTRAINT fk_analysis_dataset FOREIGN KEY (source_dataset_id) REFERENCES datasets(dataset_id) ON DELETE CASCADE,
    CONSTRAINT chk_analysis_efficiency CHECK (production_efficiency >= 0 AND production_efficiency <= 1),
    CONSTRAINT chk_analysis_defect_rate CHECK (defect_rate >= 0 AND defect_rate <= 1)
);

CREATE TABLE forecast_results (
    forecast_id VARCHAR(20) PRIMARY KEY,
    metric_name VARCHAR(150) NOT NULL,
    current_value DECIMAL(18,2) NOT NULL,
    forecasted_value DECIMAL(18,2) NOT NULL,
    growth_rate DECIMAL(8,2) NOT NULL,
    forecast_date TIMESTAMP NOT NULL,
    forecast_period_days INT NOT NULL,
    confidence VARCHAR(20) NOT NULL,
    source_analysis_id VARCHAR(20) NULL,
    CONSTRAINT fk_forecast_analysis FOREIGN KEY (source_analysis_id) REFERENCES analysis_results(analysis_id) ON DELETE SET NULL,
    CONSTRAINT chk_forecast_period CHECK (forecast_period_days > 0)
);

CREATE TABLE trend_results (
    trend_id VARCHAR(20) PRIMARY KEY,
    trend_name VARCHAR(200) NOT NULL,
    direction VARCHAR(20) NOT NULL,
    change_percent DECIMAL(8,2) NOT NULL,
    calculated_at TIMESTAMP NOT NULL,
    data_points JSON NULL,
    source_dataset_id INT NULL,
    CONSTRAINT fk_trend_dataset FOREIGN KEY (source_dataset_id) REFERENCES datasets(dataset_id) ON DELETE CASCADE
);

CREATE TABLE query_logs (
    query_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    query_parameters VARCHAR(500) NOT NULL,
    filter_type VARCHAR(100) NULL,
    execution_date TIMESTAMP NOT NULL,
    result_data JSON NULL,
    dataset_id INT NULL,
    CONSTRAINT fk_query_log_dataset FOREIGN KEY (dataset_id) REFERENCES datasets(dataset_id) ON DELETE SET NULL
);

CREATE TABLE filter_sets (
    filter_set_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    filter_key VARCHAR(150) NOT NULL,
    filter_value VARCHAR(500) NOT NULL,
    filter_operator VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dashboard_kpis (
    dashboard_kpi_id INT AUTO_INCREMENT PRIMARY KEY,
    dashboard_id INT NOT NULL,
    kpi_id INT NOT NULL,
    chart_type VARCHAR(20) DEFAULT 'line',
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_dashboard_kpi_dashboard FOREIGN KEY (dashboard_id) REFERENCES dashboards(dashboard_id),
    CONSTRAINT fk_dashboard_kpi_kpi FOREIGN KEY (kpi_id) REFERENCES kpis(kpi_id)
);

CREATE TABLE da_reports (
    da_report_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    category VARCHAR(30) NOT NULL,
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_da_report_user FOREIGN KEY (created_by) REFERENCES users(user_id)
);

CREATE TABLE report_runs (
    report_run_id INT AUTO_INCREMENT PRIMARY KEY,
    da_report_id INT NOT NULL,
    run_by INT NOT NULL,
    run_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    period_start DATE NULL,
    period_end DATE NULL,
    status VARCHAR(20) DEFAULT 'pending',
    output_url VARCHAR(500),
    notes TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_report_run_report FOREIGN KEY (da_report_id) REFERENCES da_reports(da_report_id),
    CONSTRAINT fk_report_run_user FOREIGN KEY (run_by) REFERENCES users(user_id)
);

CREATE TABLE alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    kpi_id INT NOT NULL,
    user_id INT NOT NULL,
    condition_type VARCHAR(20) NOT NULL,
    threshold_value DECIMAL(15,4) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    last_triggered TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_alert_kpi FOREIGN KEY (kpi_id) REFERENCES kpis(kpi_id),
    CONSTRAINT fk_alert_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE visualizations (
    viz_id VARCHAR(50) PRIMARY KEY,
    chart_type_id BIGINT NULL,
    visualization_data JSON NULL,
    CONSTRAINT fk_visualization_chart_type FOREIGN KEY (chart_type_id) REFERENCES chart_types(chart_type_id)
);

CREATE TABLE analytics_engines (
    analytics_engine_id VARCHAR(50) PRIMARY KEY,
    model_type VARCHAR(150) NOT NULL,
    training_date TIMESTAMP NOT NULL
);

ALTER TABLE roles ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE employees ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE customers ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE customers ADD COLUMN lead_id INT NULL, ADD COLUMN ltv DECIMAL(15,2) NULL, ADD COLUMN first_name VARCHAR(100) NULL, ADD COLUMN last_name VARCHAR(100) NULL, ADD COLUMN city VARCHAR(100) NULL, ADD COLUMN age INT NULL, ADD COLUMN interest VARCHAR(100) NULL;
ALTER TABLE campaigns ADD COLUMN campaign_name VARCHAR(255) NULL, ADD COLUMN budget DECIMAL(15,2) NULL, ADD COLUMN revenue DECIMAL(15,2) NULL, ADD COLUMN segment_id INT NULL, ADD COLUMN impressions INT DEFAULT 0, ADD COLUMN clicks INT DEFAULT 0, ADD COLUMN conversions INT DEFAULT 0, ADD COLUMN lead_target INT DEFAULT 100, ADD COLUMN leads_generated INT DEFAULT 0;
ALTER TABLE suppliers ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE suppliers ADD COLUMN compliance_status BOOLEAN DEFAULT TRUE, ADD COLUMN scorecard DECIMAL(5,2) DEFAULT 4.0, ADD COLUMN approved BOOLEAN DEFAULT TRUE, ADD COLUMN payment_terms VARCHAR(30) DEFAULT 'NET30';
ALTER TABLE manufactured_cars ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE orders ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE orders ADD COLUMN quote_id INT NULL, ADD COLUMN contact_details VARCHAR(100) NULL, ADD COLUMN order_value DOUBLE NULL, ADD COLUMN current_status VARCHAR(50) NULL;
ALTER TABLE purchase_orders ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE purchase_orders ADD COLUMN total_amount DECIMAL(15,2) NULL, ADD COLUMN created_date DATETIME NULL, ADD COLUMN approval_date DATETIME NULL, ADD COLUMN created_by VARCHAR(100) NULL, ADD COLUMN approved_by VARCHAR(100) NULL, ADD COLUMN eta DATETIME NULL;
ALTER TABLE invoices ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE payments ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE payments ADD COLUMN order_id INT NULL, ADD COLUMN amount DOUBLE NULL, ADD COLUMN status VARCHAR(30) NULL;
ALTER TABLE demand_forecasts ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE bills_of_materials ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE routings ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE mrp_plans ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE production_orders ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE production_orders ADD COLUMN product_item_id INT NULL, ADD COLUMN planned_start_date DATETIME NULL, ADD COLUMN planned_end_date DATETIME NULL, ADD COLUMN actual_start_date DATETIME NULL, ADD COLUMN actual_end_date DATETIME NULL, ADD COLUMN priority VARCHAR(30) NULL, ADD COLUMN qty_planned INT NULL, ADD COLUMN qty_produced INT DEFAULT 0, ADD COLUMN scrap_qty INT DEFAULT 0, ADD COLUMN assembly_line_id VARCHAR(50) NULL;
ALTER TABLE quality_inspections ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE quality_inspections ADD COLUMN defects_count INT DEFAULT 0, ADD COLUMN sample_size INT NULL;
ALTER TABLE recruitment_candidates ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE payroll_records ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE attendance_records ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE leave_requests ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE performance_reviews ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE reports ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE reports ADD COLUMN title_alias VARCHAR(150) NULL;
ALTER TABLE report_templates ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE report_filters ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE report_exports ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE approval_requests ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE approval_requests ADD COLUMN request_title VARCHAR(100) NULL, ADD COLUMN requester VARCHAR(50) NULL, ADD COLUMN approver VARCHAR(50) NULL;
ALTER TABLE notifications ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE audit_logs ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE dashboards ADD COLUMN title VARCHAR(150) NULL, ADD COLUMN owner_id INT NULL, ADD COLUMN is_public BOOLEAN DEFAULT FALSE;
ALTER TABLE data_sources ADD COLUMN module VARCHAR(50) NULL;

INSERT INTO integration_registry (subsystem_name, api_key_hash) VALUES
('Integration', 'hash_integration'),
('UI', 'hash_ui'),
('CRM', 'hash_crm'),
('Marketing', 'hash_marketing'),
('Sales Management', 'hash_sales'),
('Order Processing', 'hash_order'),
('Supply Chain', 'hash_supply'),
('Manufacturing', 'hash_mfg'),
('HR', 'hash_hr'),
('Project Management', 'hash_pm'),
('Reporting', 'hash_reporting'),
('Data Analytics', 'hash_analytics'),
('Business Intelligence', 'hash_bi'),
('Automation', 'hash_automation'),
('Business Control', 'hash_control'),
('Financial Management', 'hash_finance'),
('Accounting', 'hash_accounting');

INSERT IGNORE INTO data_ownership (resource_table, owner_subsystem_id, stewardship_notes)
SELECT 'integration_registry', subsystem_id, 'Canonical registry owned by Integration' FROM integration_registry WHERE subsystem_name = 'Integration'
UNION ALL
SELECT 'permission_matrix', subsystem_id, 'Authorization rules owned by Integration' FROM integration_registry WHERE subsystem_name = 'Integration'
UNION ALL
SELECT 'audit_logs', subsystem_id, 'Audit governance owned by Integration' FROM integration_registry WHERE subsystem_name = 'Integration';

INSERT INTO roles (role_name, description) VALUES
('Integration Admin', 'Full system access'),
('Integration Engineer', 'Integration governance and API access'),
('Manufacturing Lead', 'Manufacturing access'),
('Supply Chain Lead', 'Supply Chain access'),
('Finance Lead', 'Financial access'),
('Business Control Lead', 'Business process controls access');

INSERT INTO users (username, email, password_hash, role_id, department) VALUES
('admin_main', 'admin@erp.com', 'hashed_pw_admin', 1, 'Integration'),
('integration_lead', 'integration@erp.com', 'hashed_pw_integration', 2, 'Integration'),
('mfg_lead', 'mfg@erp.com', 'hashed_pw_mfg', 3, 'Manufacturing'),
('supply_lead', 'supply@erp.com', 'hashed_pw_supply', 4, 'Supply Chain'),
('finance_user', 'finance@erp.com', 'hashed_pw_finance', 5, 'Finance'),
('control_lead', 'control@erp.com', 'hashed_pw_control', 6, 'Business Control');

INSERT INTO employees (user_id, employee_name, department, job_role, assigned_assembly_line, shift_schedule, email, hire_date, salary, employment_status) VALUES
(3, 'Mike Builder', 'Manufacturing', 'Production Lead', 'AL-1', 'Morning', 'mfg@erp.com', '2024-05-20', 75000.00, 'Active');

INSERT INTO customers (name, email, phone, segment, region, interested_car_model, lifetime_value, status, last_contact_date) VALUES
('Arjun Mehta', 'arjun@email.com', '9876500001', 'Premium', 'Bengaluru', 'Sedan X', 1250000.00, 'Active', '2026-03-20');

UPDATE customers
SET first_name = 'Arjun',
    last_name = 'Mehta',
    city = 'Bengaluru',
    age = 32,
    interest = 'Sedans',
    ltv = lifetime_value
WHERE customer_id = 1;

INSERT INTO leads (name, email, status) VALUES
('Rahul Sharma', 'rahul@email.com', 'QUALIFIED');

UPDATE customers
SET lead_id = 1
WHERE customer_id = 1;

INSERT INTO interactions (lead_id, customer_id, interaction_type, notes) VALUES
(1, 1, 'call', 'Interested in premium sedan options');

INSERT INTO deals (customer_id, amount, stage, status, probability, expected_close_date) VALUES
(1, 2200000.00, 'Negotiation', 'Open', 72.50, '2026-05-10 17:00:00');

INSERT INTO quotes (customer_id, deal_id, total_amount, discount, final_amount) VALUES
(1, 1, 2200000.00, 50000.00, 2150000.00);

UPDATE deals
SET quote_id = 1
WHERE deal_id = 1;

INSERT INTO quote_items (quote_id, product_name, quantity, price) VALUES
(1, 'Sedan X Top Trim', 1, 2200000.00);

INSERT INTO inventory_items (product_name, description, current_stock, minimum_level, unit, price, location, status) VALUES
('Battery Pack', 'EV battery module', 120, 40, 'Unit', 250000.00, 'WH-A1', 'Available'),
('Brake Assembly', 'Front brake set', 80, 25, 'Unit', 18000.00, 'WH-B3', 'Available');

INSERT INTO suppliers (supplier_name, contact_info, address) VALUES
('VoltEdge Supplies', 'voltedge@example.com', 'Bengaluru, Karnataka');

INSERT INTO purchase_orders (supplier_id, order_date, status, amount) VALUES
(1, '2026-04-10', 'Approved', 5000000.00);

UPDATE purchase_orders
SET total_amount = amount,
    created_date = '2026-04-10 09:00:00',
    approval_date = '2026-04-10 12:00:00',
    created_by = 'supply_lead',
    approved_by = 'admin_main',
    eta = '2026-04-17 18:00:00'
WHERE po_id = 1;

INSERT INTO manufactured_cars (vin, model_name, chassis_type, build_status, assembly_line, color) VALUES
('VIN1001', 'Sedan X', 'Monocoque', 'Assembly', 'AL-1', 'Black'),
('VIN1002', 'SUV Z', 'Ladder', 'Paint', 'AL-2', 'White');

INSERT INTO orders (customer_id, car_vin, customer_name, customer_contact_details, vehicle_model, vehicle_variant, vehicle_color, custom_features, order_status, total_amount, payment_status, order_details) VALUES
(1, 'VIN1001', 'Arjun Mehta', '9876500001', 'Sedan X', 'Top Trim', 'Black', 'Sunroof, ADAS', 'Processing', 2200000.00, 'Partial', 'Priority delivery');

UPDATE orders
SET contact_details = customer_contact_details,
    order_value = total_amount,
    current_status = order_status
WHERE order_id = 1;

INSERT INTO project (name, description, manager_name, start_date, end_date, status, objectives, progress_pct, budget_total, budget_spent) VALUES
('ERP Canonical DB', 'Canonical ERP database design', 'Rohit PM', '2026-03-01', '2026-05-01', 'In Progress', 'Consolidate subsystem data', 72.50, 1000000.00, 640000.00);

INSERT INTO task (project_id, task_name, description, start_date, due_date, status, priority, assigned_to) VALUES
(1, 'Finalize integration governance', 'Implement permission and audit corrections', '2026-04-01', '2026-04-20', 'In Progress', 'High', 1),
(1, 'Create BI tables', 'Add dashboards and metrics model', '2026-04-03', '2026-04-22', 'Open', 'Medium', 1);

INSERT INTO resource (project_id, name, role, availability, skill_set) VALUES
(1, 'Integration Team', 'Engineering', TRUE, 'Java, SQL, JDBC');

INSERT INTO milestone (project_id, name, target_date, completion_status, description) VALUES
(1, 'Schema Freeze', '2026-04-25', FALSE, 'Lock canonical database schema for integration handoff');

INSERT INTO expense (project_id, expense_date, description, category, amount) VALUES
(1, '2026-04-12', 'Schema validation workshop', 'Planning', 25000.00);

INSERT INTO risk (project_id, description, severity, status, mitigation_plan) VALUES
(1, 'Subsystem naming drift across teams', 'High', 'Open', 'Use canonical schema plus compatibility views');

INSERT INTO reports (title, report_type, generated_by, start_date, end_date, content) VALUES
('Monthly Sales Summary', 'Sales', 1, '2026-04-01', '2026-04-30', 'Sales performance snapshot');

INSERT INTO accounts (account_code, account_name, account_type) VALUES
('1000', 'Cash', 'Asset'),
('1100', 'Accounts Receivable', 'Asset'),
('2000', 'Accounts Payable', 'Liability'),
('4000', 'Vehicle Sales Revenue', 'Revenue'),
('5000', 'Operating Expenses', 'Expense');

INSERT INTO customer_segments (segment_name, segment_description, criteria_definition) VALUES
('Premium Buyers', 'High-value premium customers', 'lifetime_value > 1000000');

INSERT INTO segment_members (segment_id, customer_id) VALUES
(1, 1);

INSERT INTO message_templates (template_name, channel, subject_template, body_template) VALUES
('Promo Template', 'EMAIL', 'Explore the new model', 'Promotional body');

INSERT INTO campaigns (campaign_title, campaign_type, target_vehicle_segment, campaign_budget, target_leads, start_date, end_date, campaign_roi, campaign_results) VALUES
('Summer SUV Push', 'Email', 'SUV Buyers', 300000.00, JSON_ARRAY('Lead-1','Lead-2'), '2026-04-01', '2026-05-31', 18.20, JSON_OBJECT('status', 'seeded'));

UPDATE campaigns
SET campaign_name = campaign_title,
    budget = campaign_budget,
    revenue = 14400000.00,
    impressions = 1000,
    clicks = 120,
    conversions = 8,
    lead_target = 100,
    leads_generated = 12
WHERE campaign_id = 1;

INSERT INTO campaign_messages (campaign_id, customer_id, template_id, channel, delivery_status, sent_at, delivered_at) VALUES
(1, 1, 1, 'EMAIL', 'Delivered', '2026-04-02 09:00:00', '2026-04-02 09:01:00');

INSERT INTO campaign_metrics (campaign_id, metric_date, impressions, clicks, conversions, revenue_generated) VALUES
(1, '2026-04-02', 1000, 120, 8, 14400000.00);

INSERT INTO consent_preferences (customer_id, channel, is_opted_in, source) VALUES
(1, 'EMAIL', TRUE, 'Website');

INSERT INTO inventory_locations (location_code, warehouse_name, aisle, bin_code) VALUES
('WH-A1', 'Main Warehouse', 'A', '1'),
('WH-B3', 'Main Warehouse', 'B', '3');

INSERT INTO purchase_order_lines (po_id, item_id, quantity, unit_price, uom) VALUES
(1, 1, 10, 250000.00, 'Unit');

INSERT INTO supplier_materials (supplier_id, item_id) VALUES
(1, 1),
(1, 2);

INSERT INTO goods_receipts (po_id, received_date, received_by, status) VALUES
(1, '2026-04-12', 1, 'Received');

INSERT INTO components (item_id, component_code, specification) VALUES
(1, 'COMP-BATT-001', 'Lithium battery pack'),
(2, 'COMP-BRAKE-001', 'Front brake assembly');

INSERT INTO bills_of_materials (product_name, material_list, bom_version, is_active) VALUES
('Sedan X', JSON_ARRAY(), 'v1', TRUE);

INSERT INTO bom_items (bom_id, component_id, quantity_required, uom) VALUES
(1, 1, 1, 'Unit'),
(1, 2, 2, 'Unit');

INSERT INTO invoices (order_id, invoice_amount, tax_details, invoice_status, payment_status, due_date) VALUES
(1, 2200000.00, 396000.00, 'Generated', 'Partial', '2026-05-05');

INSERT INTO payments (invoice_id, payment_method, payment_amount, payment_status, transaction_details) VALUES
(1, 'Bank Transfer', 1000000.00, 'Success', 'TXN-ERP-1001');

UPDATE payments
SET order_id = 1,
    amount = payment_amount,
    status = payment_status
WHERE invoice_id = 1;

INSERT INTO receivables (customer_id, invoice_id, account_id, amount_due, due_date, status) VALUES
(1, 1, 2, 1200000.00, '2026-05-05', 'Open');

INSERT INTO payables (supplier_id, po_id, account_id, amount_due, due_date, status) VALUES
(1, 1, 3, 5000000.00, '2026-05-10', 'Open');

INSERT INTO assets (asset_tag, asset_name, category, purchase_date, purchase_value, depreciation_method, useful_life_months, status) VALUES
('AST-1001', 'Assembly Robot', 'Machinery', '2025-09-10', 4500000.00, 'Straight Line', 84, 'Active');

INSERT INTO expenses (expense_date, description, category, amount, approved_by) VALUES
('2026-04-10', 'Cloud tooling and DBA review', 'Infrastructure', 120000.00, 1);

INSERT INTO data_sources (source_name, source_type, connection_details, is_active) VALUES
('ERP MySQL', 'MYSQL', 'erp_subsystem canonical db', TRUE);

UPDATE data_sources
SET module = 'production',
    car_model = 'Sedan X',
    data_timestamp = CURRENT_TIMESTAMP,
    raw_data = JSON_OBJECT('seed', 'bi-source')
WHERE data_source_id = 1;

INSERT INTO datasets (data_source_id, dataset_name, description, processing_stage, source_type_id, schema_definition, refresh_frequency, payload) VALUES
(1, 'orders_raw', 'Business Intelligence source dataset', 'raw', NULL, 'orders raw schema', 'hourly', JSON_OBJECT('domain', 'bi'));

INSERT INTO metrics (dataset_id, metric_name, metric_formula, unit) VALUES
(1, 'Revenue YTD', 'SUM(total_amount)', 'INR');

INSERT INTO dashboards (dashboard_name, owner_user_id, description) VALUES
('Executive Dashboard', 1, 'Executive KPI view');

UPDATE dashboards
SET title = dashboard_name,
    owner_id = owner_user_id,
    is_public = TRUE,
    user_name = 'admin_main',
    last_updated = CURRENT_TIMESTAMP,
    dashboard_payload = JSON_OBJECT('layout', 'executive')
WHERE dashboard_id = 1;

INSERT INTO dashboard_widgets (dashboard_id, widget_title, widget_type, metric_id, dataset_id, position_x, position_y, width_units, height_units) VALUES
(1, 'Revenue KPI', 'KPI', 1, 1, 0, 0, 2, 1);

INSERT INTO kpis (name, description, unit, category, data_source_id, created_by) VALUES
('Monthly Vehicle Output', 'Produced vehicles in the month', 'units', 'production', 1, 1);

UPDATE kpis
SET kpi_name = name,
    target_value = 1000.00,
    actual_value = 925.00
WHERE kpi_id = 1;

INSERT INTO kpi_snapshots (kpi_id, snapshot_value, period_label, period_start, period_end, recorded_by) VALUES
(1, 145.0000, 'Apr 2026', '2026-04-01', '2026-04-30', 1);

INSERT INTO dashboard_kpis (dashboard_id, kpi_id, chart_type, display_order) VALUES
(1, 1, 'card', 1);

INSERT INTO da_reports (title, description, category, created_by) VALUES
('DA Monthly Ops Report', 'Analytics snapshot across modules', 'summary', 1);

INSERT INTO report_runs (da_report_id, run_by, period_start, period_end, status, output_url, notes) VALUES
(1, 1, '2026-04-01', '2026-04-30', 'success', '/reports/da-monthly-ops.pdf', 'Seed report run');

INSERT INTO alerts (kpi_id, user_id, condition_type, threshold_value, is_active) VALUES
(1, 1, 'less_than', 120.0000, TRUE);

INSERT INTO source_types (type_code, type_name, description) VALUES
('ERP_MODULE', 'ERP Module', 'Operational ERP source system'),
('CSV', 'CSV File', 'Comma-separated values source'),
('API', 'API', 'Remote API source');

INSERT INTO report_formats (format_code, format_name, description) VALUES
('PDF', 'PDF', 'Portable Document Format'),
('EXCEL', 'Excel', 'Spreadsheet format'),
('CSV', 'CSV', 'Comma-separated values');

INSERT INTO chart_types (chart_code, chart_name, description) VALUES
('BAR', 'Bar Chart', 'Bar-based visualization'),
('LINE', 'Line Chart', 'Trend visualization'),
('PIE', 'Pie Chart', 'Proportional visualization'),
('TABLE', 'Table', 'Tabular visualization');

INSERT INTO kpi_statuses (status_code, status_name, description) VALUES
('ABOVE_TARGET', 'Above Target', 'Actual value exceeds target'),
('ON_TARGET', 'On Target', 'Actual value meets target'),
('BELOW_TARGET', 'Below Target', 'Actual value is below target');

UPDATE data_sources
SET source_type_id = 1
WHERE data_source_id = 1;

UPDATE datasets
SET source_type_id = 1
WHERE dataset_id = 1;

UPDATE kpis
SET status_id = 3
WHERE kpi_id = 1;

UPDATE reports
SET report_name = COALESCE(title, 'Monthly Sales Summary'),
    format_id = 1,
    report_data = JSON_OBJECT('summary', 'seed-bi-report'),
    title_alias = title
WHERE report_id = 1;

INSERT INTO sales_records (data_source_id, car_model, units_sold, revenue, sales_date, dealer_id) VALUES
(1, 'Sedan X', 85, 187000000.00, CURRENT_TIMESTAMP, 'DLR-BLR-01');

INSERT INTO hr_records (data_source_id, employee_id, employee_name, department, role, joining_date, salary) VALUES
(1, 'EMP-BI-001', 'Asha Rao', 'Business Intelligence', 'BI Analyst', '2025-06-01 09:00:00', 850000.00);

INSERT INTO finance_transactions (finance_transaction_id, data_source_id, car_model, amount, transaction_type, transaction_date, department) VALUES
('FIN-BI-001', 1, 'Sedan X', 187000000.00, 'REVENUE', CURRENT_TIMESTAMP, 'Finance');

INSERT INTO data_warehouse (car_model, data_category, stored_data, created_at, dataset_id) VALUES
('Sedan X', 'sales', JSON_OBJECT('units_sold', 85, 'revenue', 187000000.00), CURRENT_TIMESTAMP, 1);

INSERT INTO etl_jobs (dataset_id, cleaned_data, transformed_data, production_count, sales_count, processing_date, status) VALUES
(1, JSON_OBJECT('rows_cleaned', 85), JSON_OBJECT('aggregated', TRUE), 925, 85, CURRENT_TIMESTAMP, 'SUCCESS');

INSERT INTO analysis_results (analysis_id, metric_name, metric_value, production_efficiency, defect_rate, analysis_date, source_dataset_id, breakdown) VALUES
('ANL-0001', 'Production Efficiency', 92.50, 0.9250, 0.0310, CURRENT_TIMESTAMP, 1, JSON_OBJECT('plant', 'Bengaluru'));

INSERT INTO forecast_results (forecast_id, metric_name, current_value, forecasted_value, growth_rate, forecast_date, forecast_period_days, confidence, source_analysis_id) VALUES
('FRC-0001', 'Revenue Forecast', 187000000.00, 201960000.00, 8.00, CURRENT_TIMESTAMP, 30, 'HIGH', 'ANL-0001');

INSERT INTO trend_results (trend_id, trend_name, direction, change_percent, calculated_at, data_points, source_dataset_id) VALUES
('TRD-0001', 'Monthly Sales Trend', 'UP', 6.50, CURRENT_TIMESTAMP, JSON_ARRAY(72, 78, 85), 1);

INSERT INTO query_logs (query_parameters, filter_type, execution_date, result_data, dataset_id) VALUES
('car_model=Sedan X', 'car_model', CURRENT_TIMESTAMP, JSON_OBJECT('records', 1), 1);

INSERT INTO filter_sets (filter_key, filter_value, filter_operator) VALUES
('department', 'Finance', '=');

INSERT INTO visualizations (viz_id, chart_type_id, visualization_data) VALUES
('VIZ-001', 2, JSON_OBJECT('title', 'Revenue Trend'));

INSERT INTO analytics_engines (analytics_engine_id, model_type, training_date) VALUES
('ENG-001', 'Time Series Forecast', CURRENT_TIMESTAMP);

INSERT INTO project_team_members (project_id, user_id, role_in_project) VALUES
(1, 1, 'Integration Admin');

INSERT INTO dependency (task_id, depends_on_task_id) VALUES
(2, 1);

INSERT INTO workflows (workflow_name, status, created_by) VALUES
('IT Access Provisioning', 'In Progress', 'admin_main');

INSERT INTO risk_records (request_id, risk_message, severity) VALUES
(NULL, 'Database unavailable during demo', 'HIGH');

INSERT INTO refunds (refund_id, order_id, amount, created_date, status) VALUES
('RF-1001', 1, 25000.00, '2026-04-18 09:30:00', 'Pending');

INSERT INTO work_centers (work_center_id, work_center_name, work_center_type, capacity_hours, utilization_pct, location) VALUES
('WC-A1', 'Battery Fitment', 'Assembly', 16.00, 72.50, 'Plant-1');

INSERT INTO assembly_lines (line_id, line_name, shift_pattern, line_status, product_item_id) VALUES
('AL-1', 'Main EV Line', 'Morning', 'Active', 1);

INSERT INTO assembly_line_work_centers (line_id, work_center_id) VALUES
('AL-1', 'WC-A1');

INSERT INTO routings (bom_id, work_center_id, assigned_operator_id, setup_time, run_time) VALUES
(1, 'WC-A1', 1, 1, 2);

INSERT INTO production_orders (order_id, car_vin, order_quantity, order_status, due_date) VALUES
(1, 'VIN1001', 1, 'In Progress', '2026-04-12');

INSERT INTO routing_steps (routing_id, operation_id, sequence_number, operation_name, work_center_id, setup_time, run_time) VALUES
(1, 'OP-10', 1, 'Battery Installation', 'WC-A1', 0.50, 2.00);

INSERT INTO execution_logs (production_order_id, start_time, end_time, operator_id, qty_produced, scrap_qty, note) VALUES
(1, '2026-04-06 08:30:00', NULL, 'OPR-001', 0, 0, 'Production started');

INSERT INTO quality_inspections (production_order_id, pass_fail_status, pass_rate, inspection_date, compliance_code) VALUES
(1, 'PASS', 100.00, '2026-04-08', 'QC-OK');

UPDATE quality_inspections
SET defects_count = 0,
    sample_size = 10
WHERE inspection_id = 1;

INSERT INTO inventory_transactions (item_id, location_id, transaction_type, quantity, reference_type, reference_id, created_by) VALUES
(1, 1, 'RECEIPT', 10, 'PO', '1', 1);

INSERT INTO shipments (order_id, shipment_status, dispatch_date, delivery_date, carrier_info) VALUES
(1, 'Packed', '2026-04-11', NULL, 'FastTrack Logistics');

INSERT INTO purchase_requisitions (item_id, quantity, status, requested_date, needed_by_date, requested_by, approved_by, notes) VALUES
(1, 5, 'Approved', '2026-04-09', '2026-04-15', 'supply_lead', 'admin_main', 'Battery replenishment');

INSERT INTO supplier_invoices (po_id, invoice_amount, invoice_date, due_date, payment_status, verified_by) VALUES
(1, 5000000.00, '2026-04-12', '2026-05-10', 'Pending', 'finance_user');

INSERT INTO customer_invoices (order_id, qty_produced, unit_price, total_amount, generated_date) VALUES
(1, 1, 2200000.00, 2200000.00, '2026-04-07');

INSERT IGNORE INTO permission_matrix
(subsystem_id, resource_table, can_create, can_read, can_update, can_delete, readable_columns, writable_columns, allowed_row_filter)
SELECT subsystem_id, 'integration_registry', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('subsystem_id','subsystem_name','api_key_hash','is_active','created_at','updated_at'),
JSON_ARRAY('subsystem_name','api_key_hash','is_active'),
NULL
FROM integration_registry WHERE subsystem_name = 'Integration'
UNION ALL
SELECT subsystem_id, 'permission_matrix', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('permission_id','subsystem_id','resource_table','can_create','can_read','can_update','can_delete','readable_columns','writable_columns','allowed_row_filter','created_at','updated_at'),
JSON_ARRAY('subsystem_id','resource_table','can_create','can_read','can_update','can_delete','readable_columns','writable_columns','allowed_row_filter'),
NULL
FROM integration_registry WHERE subsystem_name = 'Integration'
UNION ALL
SELECT subsystem_id, 'audit_logs', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('log_id','request_id','action','performed_by','subsystem_name','resource_table','resource_id','success','latency_ms','error_code','log_timestamp','details','error_message','updated_at'),
JSON_ARRAY('request_id','action','performed_by','subsystem_name','resource_table','resource_id','success','latency_ms','error_code','details','error_message'),
NULL
FROM integration_registry WHERE subsystem_name = 'Integration'
UNION ALL
SELECT subsystem_id, 'data_ownership', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('ownership_id','resource_table','owner_subsystem_id','stewardship_notes','created_at','updated_at'),
JSON_ARRAY('resource_table','owner_subsystem_id','stewardship_notes'),
NULL
FROM integration_registry WHERE subsystem_name = 'Integration'
UNION ALL
SELECT subsystem_id, 'user_sessions', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('session_id','user_id','created_at','expires_at','last_access_at','ip_address','user_agent','revoked_at','updated_at'),
JSON_ARRAY('user_id','expires_at','last_access_at','ip_address','user_agent','revoked_at'),
NULL
FROM integration_registry WHERE subsystem_name = 'Integration'
UNION ALL
SELECT subsystem_id, 'accounts', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('account_id','account_code','account_name','account_type','parent_account_id','is_active','created_at','updated_at'),
JSON_ARRAY('account_code','account_name','account_type','parent_account_id','is_active'),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'payables', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('payable_id','supplier_id','po_id','account_id','amount_due','due_date','status','created_at','updated_at'),
JSON_ARRAY('supplier_id','po_id','account_id','amount_due','due_date','status'),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'receivables', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('receivable_id','customer_id','invoice_id','account_id','amount_due','due_date','status','created_at','updated_at'),
JSON_ARRAY('customer_id','invoice_id','account_id','amount_due','due_date','status'),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'assets', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('asset_id','asset_tag','asset_name','category','purchase_date','purchase_value','depreciation_method','useful_life_months','status','created_at','updated_at'),
JSON_ARRAY('asset_tag','asset_name','category','purchase_date','purchase_value','depreciation_method','useful_life_months','status'),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'expenses', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('expense_id','expense_date','description','category','amount','approved_by','created_at','updated_at'),
JSON_ARRAY('expense_date','description','category','amount','approved_by'),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'purchase_order_lines', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('po_line_id','po_id','item_id','quantity','unit_price','uom','created_at','updated_at'),
JSON_ARRAY('po_id','item_id','quantity','unit_price','uom'),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'goods_receipts', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('receipt_id','po_id','received_date','received_by','status','created_at','updated_at'),
JSON_ARRAY('po_id','received_date','received_by','status'),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'components', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('component_id','item_id','component_code','specification','created_at','updated_at'),
JSON_ARRAY('item_id','component_code','specification'),
NULL
FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT subsystem_id, 'bom_items', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('bom_item_id','bom_id','component_id','quantity_required','uom','created_at','updated_at'),
JSON_ARRAY('bom_id','component_id','quantity_required','uom'),
NULL
FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT subsystem_id, 'inventory_locations', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('location_id','location_code','warehouse_name','aisle','bin_code','is_active','created_at','updated_at'),
JSON_ARRAY('location_code','warehouse_name','aisle','bin_code','is_active'),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'inventory_transactions', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('transaction_id','item_id','location_id','transaction_type','quantity','reference_type','reference_id','transaction_timestamp','created_by','created_at','updated_at'),
JSON_ARRAY('item_id','location_id','transaction_type','quantity','reference_type','reference_id','created_by'),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'customer_segments', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('segment_id','segment_name','segment_description','criteria_definition','created_at','updated_at'),
JSON_ARRAY('segment_name','segment_description','criteria_definition'),
NULL
FROM integration_registry WHERE subsystem_name = 'Marketing'
UNION ALL
SELECT subsystem_id, 'segment_members', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('segment_member_id','segment_id','customer_id','assigned_at','updated_at'),
JSON_ARRAY('segment_id','customer_id'),
NULL
FROM integration_registry WHERE subsystem_name = 'Marketing'
UNION ALL
SELECT subsystem_id, 'message_templates', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('template_id','template_name','channel','subject_template','body_template','created_at','updated_at'),
JSON_ARRAY('template_name','channel','subject_template','body_template'),
NULL
FROM integration_registry WHERE subsystem_name = 'Marketing'
UNION ALL
SELECT subsystem_id, 'campaign_messages', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('campaign_message_id','campaign_id','customer_id','template_id','channel','delivery_status','sent_at','delivered_at','opened_at','clicked_at','created_at','updated_at'),
JSON_ARRAY('campaign_id','customer_id','template_id','channel','delivery_status','sent_at','delivered_at','opened_at','clicked_at'),
NULL
FROM integration_registry WHERE subsystem_name = 'Marketing'
UNION ALL
SELECT subsystem_id, 'campaign_metrics', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('metric_id','campaign_id','metric_date','impressions','clicks','conversions','revenue_generated','created_at','updated_at'),
JSON_ARRAY('campaign_id','metric_date','impressions','clicks','conversions','revenue_generated'),
NULL
FROM integration_registry WHERE subsystem_name = 'Marketing'
UNION ALL
SELECT subsystem_id, 'consent_preferences', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('consent_id','customer_id','channel','is_opted_in','consent_timestamp','source','created_at','updated_at'),
JSON_ARRAY('customer_id','channel','is_opted_in','source'),
NULL
FROM integration_registry WHERE subsystem_name = 'Marketing'
UNION ALL
SELECT subsystem_id, 'data_sources', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('data_source_id','source_name','source_type','connection_details','is_active','created_at','updated_at'),
JSON_ARRAY('source_name','source_type','connection_details','is_active'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'datasets', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('dataset_id','data_source_id','dataset_name','processing_stage','schema_definition','refresh_frequency','created_at','updated_at'),
JSON_ARRAY('data_source_id','dataset_name','processing_stage','schema_definition','refresh_frequency'),
NULL
FROM integration_registry WHERE subsystem_name = 'Data Analytics'
UNION ALL
SELECT subsystem_id, 'metrics', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('metric_id','dataset_id','metric_name','metric_formula','unit','created_at','updated_at'),
JSON_ARRAY('dataset_id','metric_name','metric_formula','unit'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'dashboards', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('dashboard_id','dashboard_name','owner_user_id','description','created_at','updated_at'),
JSON_ARRAY('dashboard_name','owner_user_id','description'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'dashboard_widgets', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('widget_id','dashboard_id','widget_title','widget_type','metric_id','dataset_id','position_x','position_y','width_units','height_units','created_at','updated_at'),
JSON_ARRAY('dashboard_id','widget_title','widget_type','metric_id','dataset_id','position_x','position_y','width_units','height_units'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'project_team_members', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('project_team_member_id','project_id','user_id','role_in_project','joined_at','updated_at'),
JSON_ARRAY('project_id','user_id','role_in_project'),
NULL
FROM integration_registry WHERE subsystem_name = 'Project Management';

INSERT IGNORE INTO data_ownership (resource_table, owner_subsystem_id, stewardship_notes)
SELECT 'leads', subsystem_id, 'CRM lead intake compatibility table' FROM integration_registry WHERE subsystem_name = 'CRM'
UNION ALL
SELECT 'interactions', subsystem_id, 'CRM interaction compatibility table' FROM integration_registry WHERE subsystem_name = 'CRM'
UNION ALL
SELECT 'deals', subsystem_id, 'Sales pipeline compatibility table' FROM integration_registry WHERE subsystem_name = 'Sales Management'
UNION ALL
SELECT 'quotes', subsystem_id, 'Sales quotes compatibility table' FROM integration_registry WHERE subsystem_name = 'Sales Management'
UNION ALL
SELECT 'quote_items', subsystem_id, 'Sales quote items compatibility table' FROM integration_registry WHERE subsystem_name = 'Sales Management'
UNION ALL
SELECT 'refunds', subsystem_id, 'Order processing refunds support' FROM integration_registry WHERE subsystem_name = 'Order Processing'
UNION ALL
SELECT 'work_centers', subsystem_id, 'Manufacturing work centers' FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT 'routing_steps', subsystem_id, 'Manufacturing routing step details' FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT 'assembly_lines', subsystem_id, 'Manufacturing assembly lines' FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT 'execution_logs', subsystem_id, 'Manufacturing execution logs' FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT 'purchase_requisitions', subsystem_id, 'Supply chain requisitions' FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT 'supplier_invoices', subsystem_id, 'Supply chain supplier invoices' FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT 'customer_invoices', subsystem_id, 'Automation/customer billing support' FROM integration_registry WHERE subsystem_name = 'Automation'
UNION ALL
SELECT 'workflows', subsystem_id, 'Business process workflow execution records' FROM integration_registry WHERE subsystem_name = 'Business Control'
UNION ALL
SELECT 'risk_records', subsystem_id, 'Business control risk tracking' FROM integration_registry WHERE subsystem_name = 'Business Control'
UNION ALL
SELECT 'approval_requests', subsystem_id, 'Business process approval queue' FROM integration_registry WHERE subsystem_name = 'Business Control'
UNION ALL
SELECT 'kpis', subsystem_id, 'Analytics KPI definitions' FROM integration_registry WHERE subsystem_name = 'Data Analytics'
UNION ALL
SELECT 'kpi_snapshots', subsystem_id, 'Analytics KPI history' FROM integration_registry WHERE subsystem_name = 'Data Analytics'
UNION ALL
SELECT 'dashboard_kpis', subsystem_id, 'BI dashboard to KPI mapping' FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'da_reports', subsystem_id, 'Analytics report definitions' FROM integration_registry WHERE subsystem_name = 'Data Analytics'
UNION ALL
SELECT 'report_runs', subsystem_id, 'Analytics report execution logs' FROM integration_registry WHERE subsystem_name = 'Data Analytics'
UNION ALL
SELECT 'alerts', subsystem_id, 'Analytics alert thresholds' FROM integration_registry WHERE subsystem_name = 'Data Analytics';

INSERT IGNORE INTO permission_matrix
(subsystem_id, resource_table, can_create, can_read, can_update, can_delete, readable_columns, writable_columns, allowed_row_filter)
SELECT subsystem_id, 'leads', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('lead_id','name','email','status','created_at','updated_at'),
JSON_ARRAY('name','email','status'),
NULL
FROM integration_registry WHERE subsystem_name = 'CRM'
UNION ALL
SELECT subsystem_id, 'interactions', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('interaction_id','lead_id','customer_id','interaction_type','notes','interaction_timestamp','updated_at'),
JSON_ARRAY('lead_id','customer_id','interaction_type','notes'),
NULL
FROM integration_registry WHERE subsystem_name = 'CRM'
UNION ALL
SELECT subsystem_id, 'customers', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('customer_id','lead_id','name','email','phone','segment','region','interested_car_model','purchased_vin','vehicle_model_year','lifetime_value','ltv','status','last_contact_date','first_name','last_name','city','age','interest','created_at','updated_at'),
JSON_ARRAY('lead_id','name','email','phone','segment','region','interested_car_model','purchased_vin','vehicle_model_year','lifetime_value','ltv','status','last_contact_date','first_name','last_name','city','age','interest'),
NULL
FROM integration_registry WHERE subsystem_name = 'Sales Management'
UNION ALL
SELECT subsystem_id, 'deals', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('deal_id','customer_id','quote_id','amount','stage','status','probability','expected_close_date','created_at','updated_at'),
JSON_ARRAY('customer_id','quote_id','amount','stage','status','probability','expected_close_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'Sales Management'
UNION ALL
SELECT subsystem_id, 'quotes', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('quote_id','customer_id','deal_id','total_amount','discount','final_amount','created_at','updated_at'),
JSON_ARRAY('customer_id','deal_id','total_amount','discount','final_amount'),
NULL
FROM integration_registry WHERE subsystem_name = 'Sales Management'
UNION ALL
SELECT subsystem_id, 'quote_items', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('quote_item_id','quote_id','product_name','quantity','price','created_at','updated_at'),
JSON_ARRAY('quote_id','product_name','quantity','price'),
NULL
FROM integration_registry WHERE subsystem_name = 'Sales Management'
UNION ALL
SELECT subsystem_id, 'refunds', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('refund_id','order_id','amount','created_date','status','created_at','updated_at'),
JSON_ARRAY('refund_id','order_id','amount','created_date','status'),
NULL
FROM integration_registry WHERE subsystem_name = 'Order Processing'
UNION ALL
SELECT subsystem_id, 'supplier_materials', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('supplier_id','item_id','created_at'),
JSON_ARRAY('supplier_id','item_id'),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'work_centers', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('work_center_id','work_center_name','work_center_type','capacity_hours','utilization_pct','location','created_at','updated_at'),
JSON_ARRAY('work_center_id','work_center_name','work_center_type','capacity_hours','utilization_pct','location'),
NULL
FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT subsystem_id, 'assembly_lines', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('line_id','line_name','shift_pattern','line_status','product_item_id','created_at','updated_at'),
JSON_ARRAY('line_id','line_name','shift_pattern','line_status','product_item_id'),
NULL
FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT subsystem_id, 'assembly_line_work_centers', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('line_id','work_center_id'),
JSON_ARRAY('line_id','work_center_id'),
NULL
FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT subsystem_id, 'routing_steps', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('routing_step_id','routing_id','operation_id','sequence_number','operation_name','work_center_id','setup_time','run_time','created_at','updated_at'),
JSON_ARRAY('routing_id','operation_id','sequence_number','operation_name','work_center_id','setup_time','run_time'),
NULL
FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT subsystem_id, 'execution_logs', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('execution_log_id','production_order_id','start_time','end_time','operator_id','qty_produced','scrap_qty','note','created_at','updated_at'),
JSON_ARRAY('production_order_id','start_time','end_time','operator_id','qty_produced','scrap_qty','note'),
NULL
FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT subsystem_id, 'purchase_requisitions', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('requisition_id','item_id','quantity','status','requested_date','needed_by_date','requested_by','approved_by','notes','created_at','updated_at'),
JSON_ARRAY('item_id','quantity','status','requested_date','needed_by_date','requested_by','approved_by','notes'),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'supplier_invoices', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('supplier_invoice_id','po_id','invoice_amount','invoice_date','due_date','payment_status','verified_by','created_at','updated_at'),
JSON_ARRAY('po_id','invoice_amount','invoice_date','due_date','payment_status','verified_by'),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'customer_invoices', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('customer_invoice_id','order_id','qty_produced','unit_price','total_amount','generated_date','created_at','updated_at'),
JSON_ARRAY('order_id','qty_produced','unit_price','total_amount','generated_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'Automation'
UNION ALL
SELECT subsystem_id, 'workflows', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('workflow_id','workflow_name','status','created_by','created_at','updated_at'),
JSON_ARRAY('workflow_name','status','created_by'),
NULL
FROM integration_registry WHERE subsystem_name = 'Automation'
UNION ALL
SELECT subsystem_id, 'risk_records', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('risk_record_id','request_id','risk_message','severity','created_at','updated_at'),
JSON_ARRAY('request_id','risk_message','severity'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Control'
UNION ALL
SELECT subsystem_id, 'approval_requests', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('request_id','request_type','related_order_id','amount','requested_by','status','rejection_reason','request_date','updated_at','request_title','requester','approver'),
JSON_ARRAY('request_type','related_order_id','amount','requested_by','status','rejection_reason','request_date','request_title','requester','approver'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Control'
UNION ALL
SELECT subsystem_id, 'workflows', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('workflow_id','workflow_name','status','created_by','created_at','updated_at'),
JSON_ARRAY('workflow_name','status','created_by'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Control'
UNION ALL
SELECT subsystem_id, 'users', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('user_id','username','email','password_hash','role_id','department','is_active','last_login','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Control'
UNION ALL
SELECT subsystem_id, 'audit_logs', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('log_id','request_id','action','performed_by','subsystem_name','resource_table','resource_id','success','latency_ms','error_code','log_timestamp','details','error_message','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Control'
UNION ALL
SELECT subsystem_id, 'kpis', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('kpi_id','name','description','unit','category','data_source_id','created_by','created_at','updated_at'),
JSON_ARRAY('name','description','unit','category','data_source_id','created_by'),
NULL
FROM integration_registry WHERE subsystem_name = 'Data Analytics'
UNION ALL
SELECT subsystem_id, 'kpi_snapshots', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('snapshot_id','kpi_id','snapshot_value','period_label','period_start','period_end','recorded_by','recorded_at','updated_at'),
JSON_ARRAY('kpi_id','snapshot_value','period_label','period_start','period_end','recorded_by'),
NULL
FROM integration_registry WHERE subsystem_name = 'Data Analytics'
UNION ALL
SELECT subsystem_id, 'dashboard_kpis', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('dashboard_kpi_id','dashboard_id','kpi_id','chart_type','display_order','created_at','updated_at'),
JSON_ARRAY('dashboard_id','kpi_id','chart_type','display_order'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'da_reports', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('da_report_id','title','description','category','created_by','created_at','updated_at'),
JSON_ARRAY('title','description','category','created_by'),
NULL
FROM integration_registry WHERE subsystem_name = 'Data Analytics'
UNION ALL
SELECT subsystem_id, 'report_runs', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('report_run_id','da_report_id','run_by','run_at','period_start','period_end','status','output_url','notes','updated_at'),
JSON_ARRAY('da_report_id','run_by','period_start','period_end','status','output_url','notes'),
NULL
FROM integration_registry WHERE subsystem_name = 'Data Analytics'
UNION ALL
SELECT subsystem_id, 'alerts', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('alert_id','kpi_id','user_id','condition_type','threshold_value','is_active','last_triggered','created_at','updated_at'),
JSON_ARRAY('kpi_id','user_id','condition_type','threshold_value','is_active','last_triggered'),
NULL
FROM integration_registry WHERE subsystem_name = 'Data Analytics';

UPDATE permission_matrix pm
JOIN integration_registry ir ON ir.subsystem_id = pm.subsystem_id
SET pm.readable_columns = JSON_ARRAY('customer_id','lead_id','name','email','phone','segment','region','interested_car_model','purchased_vin','vehicle_model_year','lifetime_value','ltv','status','last_contact_date','first_name','last_name','city','age','interest','created_at','updated_at'),
    pm.writable_columns = JSON_ARRAY('lead_id','name','email','phone','segment','region','interested_car_model','purchased_vin','vehicle_model_year','lifetime_value','ltv','status','last_contact_date','first_name','last_name','city','age','interest')
WHERE ir.subsystem_name IN ('CRM', 'Sales Management') AND pm.resource_table = 'customers';

UPDATE permission_matrix pm
JOIN integration_registry ir ON ir.subsystem_id = pm.subsystem_id
SET pm.readable_columns = JSON_ARRAY('campaign_id','campaign_title','campaign_name','campaign_type','target_vehicle_segment','campaign_budget','budget','revenue','target_leads','segment_id','start_date','end_date','campaign_roi','campaign_results','status','impressions','clicks','conversions','lead_target','leads_generated','created_at','updated_at'),
    pm.writable_columns = JSON_ARRAY('campaign_title','campaign_name','campaign_type','target_vehicle_segment','campaign_budget','budget','revenue','target_leads','segment_id','start_date','end_date','campaign_roi','campaign_results','status','impressions','clicks','conversions','lead_target','leads_generated')
WHERE ir.subsystem_name IN ('CRM', 'Marketing') AND pm.resource_table = 'campaigns';

UPDATE permission_matrix pm
JOIN integration_registry ir ON ir.subsystem_id = pm.subsystem_id
SET pm.readable_columns = JSON_ARRAY('supplier_id','supplier_name','contact_info','address','compliance_status','scorecard','approved','payment_terms','updated_at'),
    pm.writable_columns = JSON_ARRAY('supplier_name','contact_info','address','compliance_status','scorecard','approved','payment_terms')
WHERE ir.subsystem_name = 'Supply Chain' AND pm.resource_table = 'suppliers';

UPDATE permission_matrix pm
JOIN integration_registry ir ON ir.subsystem_id = pm.subsystem_id
SET pm.readable_columns = JSON_ARRAY('po_id','supplier_id','order_date','status','amount','total_amount','created_date','approval_date','created_by','approved_by','eta','updated_at'),
    pm.writable_columns = JSON_ARRAY('supplier_id','order_date','status','amount','total_amount','created_date','approval_date','created_by','approved_by','eta')
WHERE ir.subsystem_name = 'Supply Chain' AND pm.resource_table = 'purchase_orders';

UPDATE permission_matrix pm
JOIN integration_registry ir ON ir.subsystem_id = pm.subsystem_id
SET pm.readable_columns = JSON_ARRAY('order_id','quote_id','customer_id','car_vin','customer_name','customer_contact_details','contact_details','vehicle_model','vehicle_variant','vehicle_color','custom_features','order_date','order_status','current_status','total_amount','order_value','payment_status','order_details','updated_at'),
    pm.writable_columns = JSON_ARRAY('quote_id','customer_id','car_vin','customer_name','customer_contact_details','contact_details','vehicle_model','vehicle_variant','vehicle_color','custom_features','order_status','current_status','total_amount','order_value','payment_status','order_details')
WHERE ir.subsystem_name = 'Order Processing' AND pm.resource_table = 'orders';

UPDATE permission_matrix pm
JOIN integration_registry ir ON ir.subsystem_id = pm.subsystem_id
SET pm.readable_columns = JSON_ARRAY('payment_id','invoice_id','order_id','payment_method','payment_amount','amount','payment_status','status','transaction_details','payment_date','updated_at'),
    pm.writable_columns = JSON_ARRAY('invoice_id','order_id','payment_method','payment_amount','amount','payment_status','status','transaction_details','payment_date')
WHERE ir.subsystem_name IN ('Order Processing', 'Financial Management') AND pm.resource_table = 'payments';

UPDATE permission_matrix pm
JOIN integration_registry ir ON ir.subsystem_id = pm.subsystem_id
SET pm.readable_columns = JSON_ARRAY('production_order_id','order_id','car_vin','product_item_id','order_quantity','order_status','due_date','planned_start_date','planned_end_date','actual_start_date','actual_end_date','priority','qty_planned','qty_produced','scrap_qty','assembly_line_id','updated_at'),
    pm.writable_columns = JSON_ARRAY('order_id','car_vin','product_item_id','order_quantity','order_status','due_date','planned_start_date','planned_end_date','actual_start_date','actual_end_date','priority','qty_planned','qty_produced','scrap_qty','assembly_line_id')
WHERE ir.subsystem_name = 'Manufacturing' AND pm.resource_table = 'production_orders';

UPDATE permission_matrix pm
JOIN integration_registry ir ON ir.subsystem_id = pm.subsystem_id
SET pm.readable_columns = JSON_ARRAY('inspection_id','production_order_id','pass_fail_status','pass_rate','inspection_date','compliance_code','defects_count','sample_size','updated_at'),
    pm.writable_columns = JSON_ARRAY('production_order_id','pass_fail_status','pass_rate','inspection_date','compliance_code','defects_count','sample_size')
WHERE ir.subsystem_name = 'Manufacturing' AND pm.resource_table = 'quality_inspections';

UPDATE permission_matrix pm
JOIN integration_registry ir ON ir.subsystem_id = pm.subsystem_id
SET pm.readable_columns = JSON_ARRAY('data_source_id','source_name','source_type','source_type_id','car_model','data_timestamp','raw_data','connection_details','is_active','created_at','updated_at','module'),
    pm.writable_columns = JSON_ARRAY('source_name','source_type','source_type_id','car_model','data_timestamp','raw_data','connection_details','is_active','module')
WHERE ir.subsystem_name = 'Business Intelligence' AND pm.resource_table = 'data_sources';

UPDATE permission_matrix pm
JOIN integration_registry ir ON ir.subsystem_id = pm.subsystem_id
SET pm.readable_columns = JSON_ARRAY('dashboard_id','dashboard_name','owner_user_id','user_name','description','dashboard_payload','last_updated','created_at','updated_at','title','owner_id','is_public'),
    pm.writable_columns = JSON_ARRAY('dashboard_name','owner_user_id','user_name','description','dashboard_payload','last_updated','title','owner_id','is_public')
WHERE ir.subsystem_name = 'Business Intelligence' AND pm.resource_table = 'dashboards';

UPDATE permission_matrix pm
JOIN integration_registry ir ON ir.subsystem_id = pm.subsystem_id
SET pm.readable_columns = JSON_ARRAY('metric_id','dataset_id','metric_name','metric_formula','unit','created_at','updated_at'),
    pm.writable_columns = JSON_ARRAY('dataset_id','metric_name','metric_formula','unit')
WHERE ir.subsystem_name = 'Business Intelligence' AND pm.resource_table = 'metrics';

INSERT IGNORE INTO data_ownership (resource_table, owner_subsystem_id, stewardship_notes)
SELECT 'project', subsystem_id, 'Canonical project registry aligned with project management team SQL.'
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT 'task', subsystem_id, 'Canonical task registry aligned with project management team SQL.'
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT 'resource', subsystem_id, 'Canonical project resource registry aligned with project management team SQL.'
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT 'milestone', subsystem_id, 'Canonical milestone registry aligned with project management team SQL.'
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT 'dependency', subsystem_id, 'Canonical task dependency registry aligned with project management team SQL.'
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT 'risk', subsystem_id, 'Canonical project risk registry aligned with project management team SQL.'
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT 'expense', subsystem_id, 'Canonical project expense registry aligned with project management team SQL.'
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT 'assignment', subsystem_id, 'Task to resource assignments aligned with project management SQL compatibility.'
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT 'budget', subsystem_id, 'Project budget compatibility table for subsystem alignment.'
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT 'scheduler', subsystem_id, 'Scheduled report execution metadata aligned with reports subsystem SQL.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'report_data', subsystem_id, 'Materialized report-to-customer values used by reporting subsystem SQL.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'ledger', subsystem_id, 'Financial ledger headers aligned with accounting subsystem SQL.'
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT 'transactions', subsystem_id, 'Financial ledger entries aligned with accounting subsystem SQL.'
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT 'system_config', subsystem_id, 'Integration-owned runtime configuration for database connectivity and subsystem setup.'
FROM integration_registry WHERE subsystem_name = 'Integration'
UNION ALL
SELECT 'automation_expenses', subsystem_id, 'Automation expense tracking aligned with manufacturing automation SQL.'
FROM integration_registry WHERE subsystem_name = 'Automation';

INSERT IGNORE INTO data_ownership (resource_table, owner_subsystem_id, stewardship_notes)
SELECT 'source_types', subsystem_id, 'BI source type master data from the phase 3 BI schema.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'report_formats', subsystem_id, 'BI report format master data from the phase 3 BI schema.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'chart_types', subsystem_id, 'BI chart type master data from the phase 3 BI schema.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'kpi_statuses', subsystem_id, 'BI KPI status master data from the phase 3 BI schema.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'sales_records', subsystem_id, 'BI sales source facts from the phase 3 BI schema.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'hr_records', subsystem_id, 'BI HR source facts from the phase 3 BI schema.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'finance_transactions', subsystem_id, 'BI finance source facts from the phase 3 BI schema.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'data_warehouse', subsystem_id, 'BI repository table for consolidated warehouse records.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'etl_jobs', subsystem_id, 'BI ETL processing history.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'analysis_results', subsystem_id, 'BI analytics output records.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'forecast_results', subsystem_id, 'BI forecast output records.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'trend_results', subsystem_id, 'BI trend output records.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'query_logs', subsystem_id, 'BI query execution history.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'filter_sets', subsystem_id, 'BI reusable filter definitions.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'visualizations', subsystem_id, 'BI visualization repository.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT 'analytics_engines', subsystem_id, 'BI analytics engine metadata.'
FROM integration_registry WHERE subsystem_name = 'Business Intelligence';

INSERT IGNORE INTO permission_matrix
    (subsystem_id, resource_table, can_create, can_read, can_update, can_delete, readable_columns, writable_columns, allowed_row_filter)
SELECT subsystem_id, 'project', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('id','name','description','manager_name','start_date','end_date','status','objectives','progress_pct','budget_total','budget_spent','updated_at'),
JSON_ARRAY('name','description','manager_name','start_date','end_date','status','objectives','progress_pct','budget_total','budget_spent'),
NULL
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT subsystem_id, 'task', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('id','project_id','task_name','description','start_date','due_date','status','priority','assigned_to','updated_at'),
JSON_ARRAY('project_id','task_name','description','start_date','due_date','status','priority','assigned_to'),
NULL
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT subsystem_id, 'resource', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('id','project_id','name','role','availability','skill_set','updated_at'),
JSON_ARRAY('project_id','name','role','availability','skill_set'),
NULL
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT subsystem_id, 'milestone', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('id','project_id','name','target_date','completion_status','description','updated_at'),
JSON_ARRAY('project_id','name','target_date','completion_status','description'),
NULL
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT subsystem_id, 'dependency', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('id','task_id','depends_on_task_id','created_at','updated_at'),
JSON_ARRAY('task_id','depends_on_task_id'),
NULL
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT subsystem_id, 'risk', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('id','project_id','description','severity','status','mitigation_plan','updated_at'),
JSON_ARRAY('project_id','description','severity','status','mitigation_plan'),
NULL
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT subsystem_id, 'expense', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('id','project_id','expense_date','description','category','amount','updated_at'),
JSON_ARRAY('project_id','expense_date','description','category','amount'),
NULL
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT subsystem_id, 'assignment', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('assignment_id','task_id','resource_id','assigned_on','updated_at'),
JSON_ARRAY('task_id','resource_id','assigned_on'),
NULL
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT subsystem_id, 'budget', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('budget_id','project_id','allocated_amount','approved_amount','fiscal_period','created_at','updated_at'),
JSON_ARRAY('project_id','allocated_amount','approved_amount','fiscal_period'),
NULL
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT subsystem_id, 'scheduler', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('schedule_id','report_id','schedule_time','created_at','updated_at'),
JSON_ARRAY('report_id','schedule_time'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'report_data', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('data_id','report_id','customer_id','total_value','created_at','updated_at'),
JSON_ARRAY('report_id','customer_id','total_value'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'ledger', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('ledger_id','user_id','description','created_date','created_at','updated_at'),
JSON_ARRAY('user_id','description','created_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'transactions', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('transaction_id','ledger_id','debit','credit','transaction_date','created_at','updated_at'),
JSON_ARRAY('ledger_id','debit','credit','transaction_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'system_config', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('config_id','config_key','connection_string','config_value','created_at','updated_at'),
JSON_ARRAY('config_key','connection_string','config_value'),
NULL
FROM integration_registry WHERE subsystem_name = 'Integration'
UNION ALL
SELECT subsystem_id, 'automation_expenses', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('automation_expense_id','order_id','expense_type','amount','recorded_date','notes','created_at','updated_at'),
JSON_ARRAY('order_id','expense_type','amount','recorded_date','notes'),
NULL
FROM integration_registry WHERE subsystem_name = 'Automation';

INSERT IGNORE INTO permission_matrix
    (subsystem_id, resource_table, can_create, can_read, can_update, can_delete, readable_columns, writable_columns, allowed_row_filter)
SELECT subsystem_id, 'source_types', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('source_type_id','type_code','type_name','description'),
JSON_ARRAY('type_code','type_name','description'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'report_formats', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('report_format_id','format_code','format_name','description'),
JSON_ARRAY('format_code','format_name','description'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'chart_types', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('chart_type_id','chart_code','chart_name','description'),
JSON_ARRAY('chart_code','chart_name','description'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'kpi_statuses', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('kpi_status_id','status_code','status_name','description'),
JSON_ARRAY('status_code','status_name','description'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'sales_records', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('sales_record_id','data_source_id','car_model','units_sold','revenue','sales_date','dealer_id','created_at'),
JSON_ARRAY('data_source_id','car_model','units_sold','revenue','sales_date','dealer_id'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'hr_records', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('hr_record_id','data_source_id','employee_id','employee_name','department','role','joining_date','salary','created_at'),
JSON_ARRAY('data_source_id','employee_id','employee_name','department','role','joining_date','salary'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'finance_transactions', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('finance_transaction_id','data_source_id','car_model','amount','transaction_type','transaction_date','department','created_at'),
JSON_ARRAY('finance_transaction_id','data_source_id','car_model','amount','transaction_type','transaction_date','department'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'data_warehouse', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('warehouse_record_id','car_model','data_category','stored_data','created_at','dataset_id'),
JSON_ARRAY('car_model','data_category','stored_data','created_at','dataset_id'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'etl_jobs', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('etl_job_id','dataset_id','cleaned_data','transformed_data','production_count','sales_count','processing_date','status'),
JSON_ARRAY('dataset_id','cleaned_data','transformed_data','production_count','sales_count','processing_date','status'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'analysis_results', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('analysis_id','metric_name','metric_value','production_efficiency','defect_rate','analysis_date','source_dataset_id','breakdown'),
JSON_ARRAY('analysis_id','metric_name','metric_value','production_efficiency','defect_rate','analysis_date','source_dataset_id','breakdown'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'forecast_results', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('forecast_id','metric_name','current_value','forecasted_value','growth_rate','forecast_date','forecast_period_days','confidence','source_analysis_id'),
JSON_ARRAY('forecast_id','metric_name','current_value','forecasted_value','growth_rate','forecast_date','forecast_period_days','confidence','source_analysis_id'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'trend_results', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('trend_id','trend_name','direction','change_percent','calculated_at','data_points','source_dataset_id'),
JSON_ARRAY('trend_id','trend_name','direction','change_percent','calculated_at','data_points','source_dataset_id'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'query_logs', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('query_id','query_parameters','filter_type','execution_date','result_data','dataset_id'),
JSON_ARRAY('query_parameters','filter_type','execution_date','result_data','dataset_id'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'filter_sets', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('filter_set_id','filter_key','filter_value','filter_operator','created_at'),
JSON_ARRAY('filter_key','filter_value','filter_operator'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'visualizations', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('viz_id','chart_type_id','visualization_data'),
JSON_ARRAY('viz_id','chart_type_id','visualization_data'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'analytics_engines', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('analytics_engine_id','model_type','training_date'),
JSON_ARRAY('analytics_engine_id','model_type','training_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'reports', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('report_id','title','report_name','report_type','generated_by','generated_date','start_date','end_date','format_id','report_data','content','updated_at','title_alias'),
JSON_ARRAY('title','report_name','report_type','generated_by','start_date','end_date','format_id','report_data','content','title_alias'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'kpis', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('kpi_id','name','kpi_name','description','unit','category','data_source_id','target_value','actual_value','status_id','created_by','created_at','updated_at'),
JSON_ARRAY('name','kpi_name','description','unit','category','data_source_id','target_value','actual_value','status_id','created_by'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'datasets', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('dataset_id','data_source_id','dataset_name','description','processing_stage','source_type_id','schema_definition','refresh_frequency','payload','created_at','updated_at'),
JSON_ARRAY('data_source_id','dataset_name','description','processing_stage','source_type_id','schema_definition','refresh_frequency','payload'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence';

-- Additional permission fixes based on subsystem data requirements.
INSERT IGNORE INTO permission_matrix
    (subsystem_id, resource_table, can_create, can_read, can_update, can_delete, readable_columns, writable_columns, allowed_row_filter)
SELECT subsystem_id, 'customers', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('customer_id','lead_id','name','email','phone','segment','region','interested_car_model','purchased_vin','vehicle_model_year','lifetime_value','ltv','status','last_contact_date','first_name','last_name','city','age','interest','created_at','updated_at'),
JSON_ARRAY('lead_id','name','email','phone','segment','region','interested_car_model','purchased_vin','vehicle_model_year','lifetime_value','ltv','status','last_contact_date','first_name','last_name','city','age','interest'),
NULL
FROM integration_registry WHERE subsystem_name = 'CRM'
UNION ALL
SELECT subsystem_id, 'campaigns', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('campaign_id','campaign_title','campaign_name','campaign_type','target_vehicle_segment','campaign_budget','budget','revenue','target_leads','segment_id','start_date','end_date','campaign_roi','campaign_results','status','impressions','clicks','conversions','lead_target','leads_generated','created_at','updated_at'),
JSON_ARRAY('campaign_title','campaign_name','campaign_type','target_vehicle_segment','campaign_budget','budget','revenue','target_leads','segment_id','start_date','end_date','campaign_roi','campaign_results','status','impressions','clicks','conversions','lead_target','leads_generated'),
NULL
FROM integration_registry WHERE subsystem_name = 'CRM'
UNION ALL
SELECT subsystem_id, 'campaigns', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('campaign_id','campaign_title','campaign_name','campaign_type','target_vehicle_segment','campaign_budget','budget','revenue','target_leads','segment_id','start_date','end_date','campaign_roi','campaign_results','status','impressions','clicks','conversions','lead_target','leads_generated','created_at','updated_at'),
JSON_ARRAY('campaign_title','campaign_name','campaign_type','target_vehicle_segment','campaign_budget','budget','revenue','target_leads','segment_id','start_date','end_date','campaign_roi','campaign_results','status','impressions','clicks','conversions','lead_target','leads_generated'),
NULL
FROM integration_registry WHERE subsystem_name = 'Marketing'
UNION ALL
SELECT subsystem_id, 'customers', FALSE, TRUE, TRUE, FALSE,
JSON_ARRAY('customer_id','lead_id','name','email','phone','segment','region','interested_car_model','purchased_vin','vehicle_model_year','lifetime_value','ltv','status','last_contact_date','first_name','last_name','city','age','interest','created_at','updated_at'),
JSON_ARRAY('lead_id','name','email','phone','segment','region','interested_car_model','purchased_vin','vehicle_model_year','lifetime_value','ltv','status','last_contact_date','first_name','last_name','city','age','interest'),
NULL
FROM integration_registry WHERE subsystem_name = 'Marketing'
UNION ALL
SELECT subsystem_id, 'customers', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('customer_id','lead_id','name','email','phone','segment','region','interested_car_model','purchased_vin','vehicle_model_year','lifetime_value','ltv','status','last_contact_date','first_name','last_name','city','age','interest','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Order Processing'
UNION ALL
SELECT subsystem_id, 'deals', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('deal_id','customer_id','quote_id','amount','stage','status','probability','expected_close_date','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Order Processing'
UNION ALL
SELECT subsystem_id, 'quotes', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('quote_id','customer_id','deal_id','total_amount','discount','final_amount','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Order Processing'
UNION ALL
SELECT subsystem_id, 'quote_items', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('quote_item_id','quote_id','product_name','quantity','price','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Order Processing'
UNION ALL
SELECT subsystem_id, 'orders', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('order_id','quote_id','customer_id','car_vin','customer_name','customer_contact_details','contact_details','vehicle_model','vehicle_variant','vehicle_color','custom_features','order_date','order_status','current_status','total_amount','order_value','payment_status','order_details','updated_at'),
JSON_ARRAY('quote_id','customer_id','car_vin','customer_name','customer_contact_details','contact_details','vehicle_model','vehicle_variant','vehicle_color','custom_features','order_status','current_status','total_amount','order_value','payment_status','order_details'),
NULL
FROM integration_registry WHERE subsystem_name = 'Order Processing'
UNION ALL
SELECT subsystem_id, 'payments', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('payment_id','invoice_id','order_id','payment_method','payment_amount','amount','payment_status','status','transaction_details','payment_date','updated_at'),
JSON_ARRAY('invoice_id','order_id','payment_method','payment_amount','amount','payment_status','status','transaction_details','payment_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'Order Processing'
UNION ALL
SELECT subsystem_id, 'shipments', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('shipment_id','order_id','carrier_name','tracking_number','shipment_status','shipped_date','expected_delivery_date','delivered_date','created_at','updated_at'),
JSON_ARRAY('order_id','carrier_name','tracking_number','shipment_status','shipped_date','expected_delivery_date','delivered_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'Order Processing'
UNION ALL
SELECT subsystem_id, 'suppliers', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('supplier_id','supplier_name','contact_info','address','compliance_status','scorecard','approved','payment_terms','created_at','updated_at'),
JSON_ARRAY('supplier_name','contact_info','address','compliance_status','scorecard','approved','payment_terms'),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'purchase_orders', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('po_id','supplier_id','order_date','status','amount','total_amount','created_date','approval_date','created_by','approved_by','eta','created_at','updated_at'),
JSON_ARRAY('supplier_id','order_date','status','amount','total_amount','created_date','approval_date','created_by','approved_by','eta'),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'shipments', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('shipment_id','order_id','carrier_name','tracking_number','shipment_status','shipped_date','expected_delivery_date','delivered_date','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'materials', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('item_id','item_code','item_name','item_type','uom','standard_cost','status','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'employees', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('employee_id','employee_code','full_name','email','department','designation','hire_date','base_salary','manager_id','status','created_at','updated_at'),
JSON_ARRAY('employee_code','full_name','email','department','designation','hire_date','base_salary','manager_id','status'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'recruitment_candidates', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('candidate_id','full_name','email','phone','position_applied','application_status','created_at','updated_at'),
JSON_ARRAY('full_name','email','phone','position_applied','application_status'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'payroll_records', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('payroll_id','employee_id','pay_period_start','pay_period_end','gross_salary','deductions','net_salary','processed_at','updated_at'),
JSON_ARRAY('employee_id','pay_period_start','pay_period_end','gross_salary','deductions','net_salary','processed_at'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'attendance_records', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('attendance_id','employee_id','attendance_date','check_in_time','check_out_time','attendance_status','updated_at'),
JSON_ARRAY('employee_id','attendance_date','check_in_time','check_out_time','attendance_status'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'leave_requests', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('leave_request_id','employee_id','leave_type','start_date','end_date','approval_status','applied_at','updated_at'),
JSON_ARRAY('employee_id','leave_type','start_date','end_date','approval_status','applied_at'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'performance_reviews', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('review_id','employee_id','review_period','review_score','review_comments','reviewed_by','reviewed_at','updated_at'),
JSON_ARRAY('employee_id','review_period','review_score','review_comments','reviewed_by','reviewed_at'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'reports', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('report_id','title','report_name','title_alias','report_type','generated_by','generated_date','start_date','end_date','format_id','report_data','content','created_at','updated_at'),
JSON_ARRAY('title','report_name','title_alias','report_type','generated_by','generated_date','start_date','end_date','format_id','report_data','content'),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'report_filters', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('filter_id','report_id','date_from','date_to','customer_segment','created_at','updated_at'),
JSON_ARRAY('report_id','date_from','date_to','customer_segment'),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'report_templates', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('template_id','template_name','layout','created_at','updated_at'),
JSON_ARRAY('template_name','layout'),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'report_exports', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('export_id','report_id','format','export_url','export_date','created_at','updated_at'),
JSON_ARRAY('report_id','format','export_url','export_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'scheduler', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('schedule_id','report_id','schedule_time','created_at','updated_at'),
JSON_ARRAY('report_id','schedule_time'),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'report_data', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('data_id','report_id','customer_id','total_value','created_at','updated_at'),
JSON_ARRAY('report_id','customer_id','total_value'),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'users', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('user_id','username','email','role_id','department','is_active','last_login','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'customers', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('customer_id','lead_id','name','email','phone','segment','region','interested_car_model','purchased_vin','vehicle_model_year','lifetime_value','ltv','status','last_contact_date','first_name','last_name','city','age','interest','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'users', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('user_id','username','email','role_id','department','is_active','last_login','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Data Analytics'
UNION ALL
SELECT subsystem_id, 'data_sources', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('data_source_id','source_name','source_type','source_type_id','connection_details','is_active','module','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Data Analytics'
UNION ALL
SELECT subsystem_id, 'dashboards', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('dashboard_id','dashboard_name','owner_user_id','user_name','description','dashboard_payload','last_updated','created_at','updated_at','title','owner_id','is_public'),
JSON_ARRAY('dashboard_name','owner_user_id','user_name','description','dashboard_payload','last_updated','title','owner_id','is_public'),
NULL
FROM integration_registry WHERE subsystem_name = 'Data Analytics'
UNION ALL
SELECT subsystem_id, 'dashboard_kpis', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('dashboard_kpi_id','dashboard_id','kpi_id','chart_type','display_order','created_at','updated_at'),
JSON_ARRAY('dashboard_id','kpi_id','chart_type','display_order'),
NULL
FROM integration_registry WHERE subsystem_name = 'Data Analytics'
UNION ALL
SELECT subsystem_id, 'invoices', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('invoice_id','order_id','generated_date','invoice_amount','tax_details','invoice_status','payment_status','due_date','updated_at'),
JSON_ARRAY('order_id','generated_date','invoice_amount','tax_details','invoice_status','payment_status','due_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'reports', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('report_id','title','report_name','title_alias','report_type','generated_by','generated_date','start_date','end_date','format_id','report_data','content','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'system_config', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('config_id','config_key','connection_string','config_value','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'users', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('user_id','username','email','role_id','department','is_active','last_login','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence';

INSERT IGNORE INTO data_ownership (resource_table, owner_subsystem_id, stewardship_notes)
SELECT 'appraisal', subsystem_id, 'HR appraisal compatibility table' FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT 'attendance_record', subsystem_id, 'HR attendance compatibility table' FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT 'benefit_enrollment', subsystem_id, 'HR benefits compatibility table' FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT 'candidate', subsystem_id, 'HR candidate compatibility table' FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT 'claim', subsystem_id, 'HR claim compatibility table' FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT 'leave_balance', subsystem_id, 'HR leave balance compatibility table' FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT 'leave_request', subsystem_id, 'HR leave request compatibility table' FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT 'payroll', subsystem_id, 'HR payroll compatibility table' FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT 'promotion', subsystem_id, 'HR promotion compatibility table' FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT 'workforce_plan', subsystem_id, 'HR workforce plan compatibility table' FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT 'onboarding_record', subsystem_id, 'HR onboarding compatibility table' FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT 'onboarding_activity_log', subsystem_id, 'HR onboarding log compatibility table' FROM integration_registry WHERE subsystem_name = 'HR';

INSERT IGNORE INTO permission_matrix
    (subsystem_id, resource_table, can_create, can_read, can_update, can_delete, readable_columns, writable_columns, allowed_row_filter)
SELECT subsystem_id, 'segments', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('segment_id','name','criteria'),
JSON_ARRAY('name','criteria'),
NULL
FROM integration_registry WHERE subsystem_name = 'Marketing'
UNION ALL
SELECT subsystem_id, 'crm_leads', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('lead_id','name','email','status','created_at','updated_at'),
JSON_ARRAY('name','email','status'),
NULL
FROM integration_registry WHERE subsystem_name = 'CRM'
UNION ALL
SELECT subsystem_id, 'customer_interactions', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('interaction_id','lead_id','customer_id','interaction_type','notes','interaction_timestamp','updated_at'),
JSON_ARRAY('lead_id','customer_id','interaction_type','notes'),
NULL
FROM integration_registry WHERE subsystem_name = 'CRM'
UNION ALL
SELECT subsystem_id, 'sales_opportunities', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('deal_id','customer_id','quote_id','amount','stage','status','probability','expected_close_date','created_at','updated_at'),
JSON_ARRAY('customer_id','quote_id','amount','stage','status','probability','expected_close_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'Sales Management'
UNION ALL
SELECT subsystem_id, 'sales_quotations', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('quote_id','customer_id','deal_id','total_amount','discount','final_amount','created_at','updated_at'),
JSON_ARRAY('customer_id','deal_id','total_amount','discount','final_amount'),
NULL
FROM integration_registry WHERE subsystem_name = 'Sales Management'
UNION ALL
SELECT subsystem_id, 'materials', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('product_id','product_name','category','uom','stock_qty','reorder_level'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'automation_orders', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('order_id','product_id','qty_requested','created_at','due_date','status'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Automation'
UNION ALL
SELECT subsystem_id, 'bom_header', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('bom_id','product_id','revision_no','active','created_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT subsystem_id, 'po_line_items', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('line_id','po_id','item_id','qty_ordered','unit_price','uom'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'quality_checks', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('qc_id','production_order_id','status','pass_rate','inspection_date'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT subsystem_id, 'user', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('user_id','name','role'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'customer', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('customer_id','name','segment'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'report', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('report_id','title','report_type','created_date','user_id'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'filter', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('filter_id','report_id','date_from','date_to','customer_segment'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'report_template', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('template_id','layout'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'export', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('export_id','report_id','format','export_date'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'Roles', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('role_id','roleName','permissions'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'Users', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('userId','name','email','password','role_id'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'Sessions', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('sessionId','userId','lastAccessTime'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'Invoices', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('invoiceId','userId','amount','date','status'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'Expenses', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('expenseId','userId','category','amount','date'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'Payables', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('payableId','userId','amount','due_date','status'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'Receivables', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('receivableId','userId','amount','due_date','status'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'Ledger', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('ledgerId','userId','description','created_date'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'Transactions', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('transactionId','ledgerId','debit','credit','transaction_date'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'Payments', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('paymentId','userId','amount','payment_date','method'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'Reports', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('reportId','reportType','generatedDate','insights'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'SystemConfig', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('configId','connectionString'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'appraisal', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('appraise_id','appraisal_status','deadline_date','employee_id','feedback','locked','rating'),
JSON_ARRAY('appraise_id','appraisal_status','deadline_date','employee_id','feedback','locked','rating'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'attendance_record', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('id','employee_id','attendance_date','check_in_time','check_out_time','overtime_hours'),
JSON_ARRAY('employee_id','attendance_date','check_in_time','check_out_time','overtime_hours'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'benefit_enrollment', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('id','employee_id','enrollment_status','health_plan','insurance_plan','insurance_coverage_status'),
JSON_ARRAY('employee_id','enrollment_status','health_plan','insurance_plan','insurance_coverage_status'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'candidate', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('candidate_id','candidate_name','contact_info','resume_data','interview_score','application_status','created_at','updated_at'),
JSON_ARRAY('candidate_id','candidate_name','contact_info','resume_data','interview_score','application_status'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'claim', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('id','employee_id','claim_type','amount','claim_status'),
JSON_ARRAY('employee_id','claim_type','amount','claim_status'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'leave_balance', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('id','employee_id','balance'),
JSON_ARRAY('employee_id','balance'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'leave_request', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('id','employee_id','leave_from_date','leave_to_date','leave_status'),
JSON_ARRAY('employee_id','leave_from_date','leave_to_date','leave_status'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'payroll', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('payrollId','currentMonthTotal','deductions','grossSalary','netPay','role','salaryTransferRecord','employee_id','month','year'),
JSON_ARRAY('currentMonthTotal','deductions','grossSalary','netPay','role','salaryTransferRecord','employee_id','month','year'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'promotion', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('promotion_id','effective_date','employee_id','new_role'),
JSON_ARRAY('promotion_id','effective_date','employee_id','new_role'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'workforce_plan', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('id','department','hiring_forecast','hr_cost_projections','open_positions','quarter','total_budget'),
JSON_ARRAY('department','hiring_forecast','hr_cost_projections','open_positions','quarter','total_budget'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'onboarding_record', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('onboarding_id','assigned_employee_id','background_check_status','document_verification_status','employee_name','pipeline_status','verified_record'),
JSON_ARRAY('onboarding_id','assigned_employee_id','background_check_status','document_verification_status','employee_name','pipeline_status','verified_record'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'onboarding_activity_log', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('onboarding_id','activity'),
JSON_ARRAY('onboarding_id','activity'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR';

-- Final permission reconciliation for canonical tables and compatibility views.
-- Keep this after the permission seed blocks so it corrects earlier INSERT IGNORE
-- rows without changing the broader schema or deployment flow.
INSERT INTO permission_matrix
    (subsystem_id, resource_table, can_create, can_read, can_update, can_delete, readable_columns, writable_columns, allowed_row_filter)
SELECT subsystem_id, 'campaigns', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('campaign_id','campaign_title','campaign_type','target_vehicle_segment','campaign_budget','target_leads','start_date','end_date','campaign_roi','campaign_results','created_at','updated_at'),
JSON_ARRAY('campaign_title','campaign_type','target_vehicle_segment','campaign_budget','target_leads','start_date','end_date','campaign_roi','campaign_results'),
NULL
FROM integration_registry WHERE subsystem_name = 'CRM'
UNION ALL
SELECT subsystem_id, 'leads', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('lead_id','name','email','status','created_at','updated_at'),
JSON_ARRAY('name','email','status'),
NULL
FROM integration_registry WHERE subsystem_name = 'Sales Management'
UNION ALL
SELECT subsystem_id, 'campaigns', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('campaign_id','campaign_title','campaign_type','target_vehicle_segment','campaign_budget','target_leads','start_date','end_date','campaign_roi','campaign_results','created_at','updated_at'),
JSON_ARRAY('campaign_title','campaign_type','target_vehicle_segment','campaign_budget','target_leads','start_date','end_date','campaign_roi','campaign_results'),
NULL
FROM integration_registry WHERE subsystem_name = 'Marketing'
UNION ALL
SELECT subsystem_id, 'suppliers', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('supplier_id','supplier_name','contact_info','address'),
JSON_ARRAY('supplier_name','contact_info','address'),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'purchase_orders', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('po_id','supplier_id','order_date','status','amount'),
JSON_ARRAY('supplier_id','order_date','status','amount'),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'shipments', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('shipment_id','order_id','shipment_status','dispatch_date','delivery_date','carrier_info'),
JSON_ARRAY('order_id','shipment_status','dispatch_date','delivery_date','carrier_info'),
NULL
FROM integration_registry WHERE subsystem_name = 'Order Processing'
UNION ALL
SELECT subsystem_id, 'shipments', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('shipment_id','order_id','shipment_status','dispatch_date','delivery_date','carrier_info'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'materials', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('product_id','product_name','category','uom','stock_qty','reorder_level'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Supply Chain'
UNION ALL
SELECT subsystem_id, 'production_orders', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('production_order_id','order_id','car_vin','order_quantity','order_status','due_date'),
JSON_ARRAY('order_id','car_vin','order_quantity','order_status','due_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT subsystem_id, 'quality_inspections', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('inspection_id','production_order_id','pass_fail_status','pass_rate','inspection_date','compliance_code'),
JSON_ARRAY('production_order_id','pass_fail_status','pass_rate','inspection_date','compliance_code'),
NULL
FROM integration_registry WHERE subsystem_name = 'Manufacturing'
UNION ALL
SELECT subsystem_id, 'employees', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('employee_id','user_id','employee_name','department','job_role','assigned_assembly_line','shift_schedule','email','phone_no','hire_date','salary','employment_status'),
JSON_ARRAY('user_id','employee_name','department','job_role','assigned_assembly_line','shift_schedule','email','phone_no','hire_date','salary','employment_status'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'recruitment_candidates', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('candidate_id','candidate_name','contact_info','resume_data','interview_score','application_status'),
JSON_ARRAY('candidate_name','contact_info','resume_data','interview_score','application_status'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'payroll_records', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('payroll_id','employee_id','gross_salary','deductions','net_pay','tax_record','processed_date'),
JSON_ARRAY('employee_id','gross_salary','deductions','net_pay','tax_record','processed_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'attendance_records', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('attendance_id','employee_id','attendance_date','overtime_hours'),
JSON_ARRAY('employee_id','attendance_date','overtime_hours'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'leave_requests', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('leave_request_id','employee_id','leave_from_date','leave_to_date','leave_type','leave_status'),
JSON_ARRAY('employee_id','leave_from_date','leave_to_date','leave_type','leave_status'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'performance_reviews', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('review_id','employee_id','rating','feedback','review_date'),
JSON_ARRAY('employee_id','rating','feedback','review_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'HR'
UNION ALL
SELECT subsystem_id, 'reports', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('report_id','title','report_name','report_type','generated_by','generated_date','start_date','end_date','format_id','report_data','content'),
JSON_ARRAY('title','report_name','report_type','generated_by','generated_date','start_date','end_date','format_id','report_data','content'),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'report_filters', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('filter_id','report_id','date_range','date_from','date_to','customer_segment'),
JSON_ARRAY('report_id','date_range','date_from','date_to','customer_segment'),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'report_templates', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('template_id','title','layout','report_type'),
JSON_ARRAY('title','layout','report_type'),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'report_exports', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('export_id','report_id','format','export_date'),
JSON_ARRAY('report_id','format','export_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'Reporting'
UNION ALL
SELECT subsystem_id, 'reports', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('report_id','title','report_name','report_type','generated_by','generated_date','start_date','end_date','format_id','report_data','content'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'Financial Management'
UNION ALL
SELECT subsystem_id, 'reports', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('report_id','title','report_name','report_type','generated_by','generated_date','start_date','end_date','format_id','report_data','content'),
JSON_ARRAY('title','report_name','report_type','generated_by','generated_date','start_date','end_date','format_id','report_data','content'),
NULL
FROM integration_registry WHERE subsystem_name = 'Business Intelligence'
UNION ALL
SELECT subsystem_id, 'roles', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('role_id','role_name','description'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'users', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('user_id','username','email','password_hash','role_id','department','is_active','last_login','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'user_sessions', TRUE, TRUE, TRUE, TRUE,
JSON_ARRAY('session_id','user_id','created_at','expires_at','last_access_at','ip_address','user_agent','revoked_at','updated_at'),
JSON_ARRAY('user_id','expires_at','last_access_at','ip_address','user_agent','revoked_at'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'manufactured_cars', FALSE, TRUE, TRUE, FALSE,
JSON_ARRAY('vin','model_name','chassis_type','build_status','assembly_line','color','created_at'),
JSON_ARRAY('build_status'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'production_orders', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('production_order_id','order_id','car_vin','order_quantity','order_status','due_date'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'quality_inspections', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('inspection_id','production_order_id','pass_fail_status','pass_rate','inspection_date','compliance_code'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'inventory_items', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('item_id','product_name','description','current_stock','minimum_level','unit','price','location','status','last_updated'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'inventory_reorders', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('reorder_id','item_id','requested_by','quantity','reorder_status','requested_at'),
JSON_ARRAY('item_id','requested_by','quantity','reorder_status'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'purchase_requisitions', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('requisition_id','item_id','quantity','status','requested_date','needed_by_date','requested_by','approved_by','notes','created_at','updated_at'),
JSON_ARRAY('item_id','quantity','status','requested_date','needed_by_date','requested_by','approved_by','notes'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'orders', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('order_id','customer_id','car_vin','customer_name','customer_contact_details','vehicle_model','vehicle_variant','vehicle_color','custom_features','order_date','order_status','total_amount','payment_status','order_details'),
JSON_ARRAY('customer_id','car_vin','customer_name','customer_contact_details','vehicle_model','vehicle_variant','vehicle_color','custom_features','order_date','order_status','total_amount','payment_status','order_details'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'payments', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('payment_id','invoice_id','payment_method','payment_amount','payment_status','transaction_details','payment_date'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'customers', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('customer_id','name','email','phone','segment','region','interested_car_model','purchased_vin','vehicle_model_year','lifetime_value','status','last_contact_date','created_at'),
JSON_ARRAY('name','email','phone','segment','region','interested_car_model','purchased_vin','vehicle_model_year','lifetime_value','status','last_contact_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'campaigns', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('campaign_id','campaign_title','campaign_type','target_vehicle_segment','campaign_budget','target_leads','start_date','end_date','campaign_roi','campaign_results','created_at','updated_at'),
JSON_ARRAY('campaign_title','campaign_type','target_vehicle_segment','campaign_budget','target_leads','start_date','end_date','campaign_roi','campaign_results'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'campaign_messages', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('campaign_message_id','campaign_id','customer_id','template_id','channel','delivery_status','sent_at','delivered_at','opened_at','clicked_at','created_at','updated_at'),
JSON_ARRAY('campaign_id','customer_id','template_id','channel','delivery_status','sent_at','delivered_at','opened_at','clicked_at'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'deals', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('deal_id','customer_id','quote_id','amount','stage','status','probability','expected_close_date','created_at','updated_at'),
JSON_ARRAY('customer_id','quote_id','amount','stage','status','probability','expected_close_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'quotes', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('quote_id','customer_id','deal_id','total_amount','discount','final_amount','created_at','updated_at'),
JSON_ARRAY('customer_id','deal_id','total_amount','discount','final_amount'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'quote_items', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('quote_item_id','quote_id','product_name','quantity','price','created_at','updated_at'),
JSON_ARRAY('quote_id','product_name','quantity','price'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'project', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('id','name','description','manager_name','start_date','end_date','status','objectives','progress_pct','budget_total','budget_spent','updated_at'),
JSON_ARRAY('name','description','manager_name','start_date','end_date','status','objectives','progress_pct','budget_total','budget_spent'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'milestone', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('id','project_id','name','target_date','completion_status','description','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'budget', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('budget_id','project_id','allocated_amount','approved_amount','fiscal_period','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'employees', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('employee_id','user_id','employee_name','department','job_role','assigned_assembly_line','shift_schedule','email','phone_no','hire_date','salary','employment_status'),
JSON_ARRAY('user_id','employee_name','department','job_role','assigned_assembly_line','shift_schedule','email','phone_no','hire_date','salary','employment_status'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'leave_requests', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('leave_request_id','employee_id','leave_from_date','leave_to_date','leave_type','leave_status'),
JSON_ARRAY('employee_id','leave_from_date','leave_to_date','leave_type','leave_status'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'recruitment_candidates', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('candidate_id','candidate_name','contact_info','resume_data','interview_score','application_status'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'workforce_plan', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('id','department','hiring_forecast','hr_cost_projections','open_positions','quarter','total_budget'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'assets', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('asset_id','asset_tag','asset_name','category','purchase_date','purchase_value','depreciation_method','useful_life_months','status','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'expenses', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('expense_id','expense_date','description','category','amount','approved_by','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'accounts', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('account_id','account_code','account_name','account_type','parent_account_id','is_active','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'receivables', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('receivable_id','customer_id','invoice_id','account_id','amount_due','due_date','status','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'payables', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('payable_id','supplier_id','po_id','account_id','amount_due','due_date','status','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'ledger', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('ledger_id','user_id','description','created_date','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'transactions', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('transaction_id','ledger_id','debit','credit','transaction_date','created_at','updated_at'),
JSON_ARRAY('ledger_id','debit','credit','transaction_date'),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'customer_invoices', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('customer_invoice_id','order_id','qty_produced','unit_price','total_amount','generated_date','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'kpis', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('kpi_id','name','description','unit','category','data_source_id','created_by','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'kpi_snapshots', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('snapshot_id','kpi_id','snapshot_value','period_label','period_start','period_end','recorded_by','recorded_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'alerts', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('alert_id','kpi_id','user_id','condition_type','threshold_value','is_active','last_triggered','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'report_data', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('data_id','report_id','customer_id','total_value','created_at','updated_at'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
UNION ALL
SELECT subsystem_id, 'reports', FALSE, TRUE, FALSE, FALSE,
JSON_ARRAY('report_id','title','report_name','report_type','generated_by','generated_date','start_date','end_date','format_id','report_data','content'),
JSON_ARRAY(),
NULL
FROM integration_registry WHERE subsystem_name = 'UI'
ON DUPLICATE KEY UPDATE
    can_create = VALUES(can_create),
    can_read = VALUES(can_read),
    can_update = VALUES(can_update),
    can_delete = VALUES(can_delete),
    readable_columns = VALUES(readable_columns),
    writable_columns = VALUES(writable_columns),
    allowed_row_filter = VALUES(allowed_row_filter),
    updated_at = CURRENT_TIMESTAMP;

-- LikeSecA local safety net:
-- 1. every subsystem gets full CRUD on every base table
-- 2. every subsystem gets read access to non-colliding compatibility views
-- This intentionally favors "no missing permission failures" for local handoff use.
INSERT INTO permission_matrix
    (subsystem_id, resource_table, can_create, can_read, can_update, can_delete, readable_columns, writable_columns, allowed_row_filter)
SELECT
    ir.subsystem_id,
    t.table_name,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    COALESCE(JSON_ARRAYAGG(c.column_name), JSON_ARRAY()),
    COALESCE(JSON_ARRAYAGG(c.column_name), JSON_ARRAY()),
    NULL
FROM integration_registry ir
JOIN information_schema.tables t
    ON t.table_schema = DATABASE()
   AND t.table_name NOT IN ('integration_registry', 'permission_matrix', 'data_ownership')
   AND t.table_type = 'BASE TABLE'
LEFT JOIN information_schema.columns c
    ON c.table_schema = t.table_schema
   AND c.table_name = t.table_name
WHERE ir.is_active = TRUE
GROUP BY ir.subsystem_id, t.table_name
ON DUPLICATE KEY UPDATE
    can_create = VALUES(can_create),
    can_read = VALUES(can_read),
    can_update = VALUES(can_update),
    can_delete = VALUES(can_delete),
    readable_columns = VALUES(readable_columns),
    writable_columns = VALUES(writable_columns),
    allowed_row_filter = VALUES(allowed_row_filter),
    updated_at = CURRENT_TIMESTAMP;

INSERT INTO permission_matrix
    (subsystem_id, resource_table, can_create, can_read, can_update, can_delete, readable_columns, writable_columns, allowed_row_filter)
SELECT
    ir.subsystem_id,
    t.table_name,
    FALSE,
    TRUE,
    FALSE,
    FALSE,
    COALESCE(JSON_ARRAYAGG(c.column_name), JSON_ARRAY()),
    JSON_ARRAY(),
    NULL
FROM integration_registry ir
JOIN information_schema.tables t
    ON t.table_schema = DATABASE()
   AND t.table_type = 'VIEW'
   AND LOWER(t.table_name) NOT IN (
        SELECT LOWER(base_t.table_name)
        FROM information_schema.tables base_t
        WHERE base_t.table_schema = DATABASE()
          AND base_t.table_type = 'BASE TABLE'
   )
LEFT JOIN information_schema.columns c
    ON c.table_schema = t.table_schema
   AND c.table_name = t.table_name
WHERE ir.is_active = TRUE
GROUP BY ir.subsystem_id, t.table_name
ON DUPLICATE KEY UPDATE
    can_create = VALUES(can_create),
    can_read = VALUES(can_read),
    can_update = VALUES(can_update),
    can_delete = VALUES(can_delete),
    readable_columns = VALUES(readable_columns),
    writable_columns = VALUES(writable_columns),
    allowed_row_filter = VALUES(allowed_row_filter),
    updated_at = CURRENT_TIMESTAMP;

INSERT INTO system_config (config_key, connection_string, config_value) VALUES
('db.default', 'jdbc:mysql://localhost:3306/erp_integration', 'Primary local connection string');

INSERT INTO ledger (user_id, description, created_date)
SELECT user_id, 'Opening integration-controlled ledger', CURRENT_DATE
FROM users
ORDER BY user_id
LIMIT 1;

INSERT INTO transactions (ledger_id, debit, credit, transaction_date)
SELECT ledger_id, 10000.00, 0.00, CURRENT_DATE
FROM ledger
ORDER BY ledger_id
LIMIT 1;

INSERT INTO budget (project_id, allocated_amount, approved_amount, fiscal_period)
SELECT id, COALESCE(budget_total, 0.00), COALESCE(budget_total, 0.00), '2026-Q2'
FROM project
ORDER BY id
LIMIT 1;

INSERT INTO assignment (task_id, resource_id, assigned_on)
SELECT t.id, r.id, CURRENT_DATE
FROM task t
JOIN resource r ON r.project_id = t.project_id
ORDER BY t.id, r.id
LIMIT 1;

INSERT INTO scheduler (report_id, schedule_time)
SELECT report_id, DATE_ADD(NOW(), INTERVAL 1 DAY)
FROM reports
ORDER BY report_id
LIMIT 1;

INSERT INTO report_data (report_id, customer_id, total_value)
SELECT r.report_id, c.customer_id, 2500000.00
FROM reports r
JOIN customers c
ORDER BY r.report_id, c.customer_id
LIMIT 1;

INSERT INTO automation_expenses (order_id, expense_type, amount, recorded_date, notes)
SELECT order_id, 'Robot Calibration', 18000.00, CURRENT_DATE, 'Compatibility seed for automation expense tracking.'
FROM orders
ORDER BY order_id
LIMIT 1;

CREATE VIEW `Roles` AS
SELECT
    role_id,
    role_name AS roleName,
    NULL AS permissions
FROM roles;

CREATE VIEW `Users` AS
SELECT
    user_id AS userId,
    COALESCE(username, email) AS name,
    email,
    password_hash AS password,
    role_id
FROM users;

CREATE VIEW `Sessions` AS
SELECT
    session_id AS sessionId,
    user_id AS userId,
    last_access_at AS lastAccessTime
FROM user_sessions;

CREATE VIEW `Invoices` AS
SELECT
    invoice_id AS invoiceId,
    order_id AS userId,
    invoice_amount AS amount,
    generated_date AS date,
    invoice_status AS status
FROM invoices;

CREATE VIEW `Expenses` AS
SELECT
    expense_id AS expenseId,
    approved_by AS userId,
    category,
    amount,
    expense_date AS date
FROM expenses;

CREATE VIEW `Payables` AS
SELECT
    payable_id AS payableId,
    supplier_id AS userId,
    amount_due AS amount,
    due_date,
    status
FROM payables;

CREATE VIEW `Receivables` AS
SELECT
    receivable_id AS receivableId,
    customer_id AS userId,
    amount_due AS amount,
    due_date,
    status
FROM receivables;

CREATE VIEW `Ledger` AS
SELECT
    ledger_id AS ledgerId,
    user_id AS userId,
    description,
    created_date
FROM ledger;

CREATE VIEW `Transactions` AS
SELECT
    transaction_id AS transactionId,
    ledger_id AS ledgerId,
    debit,
    credit,
    transaction_date
FROM transactions;

CREATE VIEW `Payments` AS
SELECT
    payment_id AS paymentId,
    order_id AS userId,
    amount,
    payment_date,
    payment_method AS method
FROM payments;

CREATE VIEW `Reports` AS
SELECT
    report_id AS reportId,
    report_type AS reportType,
    generated_date AS generatedDate,
    content AS insights
FROM reports;

CREATE VIEW `SystemConfig` AS
SELECT
    config_id AS configId,
    connection_string AS connectionString
FROM system_config;

CREATE VIEW `user` AS
SELECT
    u.user_id,
    COALESCE(u.username, u.email) AS name,
    COALESCE(r.role_name, 'Unknown') AS role
FROM users u
LEFT JOIN roles r ON r.role_id = u.role_id;

CREATE VIEW `customer` AS
SELECT
    customer_id,
    name,
    segment
FROM customers;

CREATE VIEW `report` AS
SELECT
    report_id,
    title,
    report_type,
    generated_date AS created_date,
    generated_by AS user_id
FROM reports;

CREATE VIEW `filter` AS
SELECT
    filter_id,
    report_id,
    date_from,
    date_to,
    customer_segment
FROM report_filters;

CREATE VIEW `report_template` AS
SELECT
    template_id,
    layout
FROM report_templates;

CREATE VIEW `export` AS
SELECT
    export_id,
    report_id,
    format,
    export_date
FROM report_exports;

CREATE VIEW `projects` AS
SELECT
    id AS project_id,
    name,
    description,
    manager_name,
    start_date,
    end_date,
    status,
    objectives,
    progress_pct,
    budget_total,
    budget_spent,
    updated_at
FROM project;

CREATE VIEW `project_tasks` AS
SELECT
    id AS task_id,
    project_id,
    task_name,
    description,
    start_date,
    due_date,
    status,
    priority,
    assigned_to,
    updated_at
FROM task;

CREATE VIEW `project_resources` AS
SELECT
    id AS resource_id,
    project_id,
    name,
    role,
    availability,
    skill_set,
    updated_at
FROM resource;

CREATE VIEW `project_milestones` AS
SELECT
    id AS milestone_id,
    project_id,
    name,
    target_date,
    completion_status,
    description,
    updated_at
FROM milestone;

CREATE VIEW `task_dependencies` AS
SELECT
    id AS dependency_id,
    task_id,
    depends_on_task_id,
    created_at,
    updated_at
FROM dependency;

CREATE VIEW `project_risks` AS
SELECT
    id AS risk_id,
    project_id,
    description,
    severity,
    status,
    mitigation_plan,
    updated_at
FROM risk;

CREATE VIEW `project_expenses` AS
SELECT
    id AS expense_id,
    project_id,
    expense_date,
    description,
    category,
    amount,
    updated_at
FROM expense;

CREATE VIEW `crm_leads` AS
SELECT
    lead_id,
    name AS lead_name,
    NULL AS lead_source,
    status AS lead_status,
    NULL AS vehicle_model_of_interest,
    NULL AS trim_variant_preference,
    FALSE AS test_drive_scheduled,
    NULL AS trade_in_vehicle_details,
    NULL AS financing_preference,
    created_at,
    updated_at
FROM leads;

CREATE VIEW `sales_opportunities` AS
SELECT
    deal_id AS opportunity_id,
    NULL AS lead_id,
    customer_id,
    NULL AS client_name,
    NULL AS car_model,
    amount AS deal_value,
    probability AS win_probability_pct,
    DATE(expected_close_date) AS expected_close_date,
    status,
    stage,
    quote_id,
    probability,
    created_at,
    updated_at
FROM deals;

CREATE VIEW `sales_quotations` AS
SELECT
    q.quote_id,
    q.deal_id AS opportunity_id,
    q.total_amount,
    NULL AS max_discount_limit,
    q.discount,
    q.final_amount,
    q.customer_id,
    q.created_at,
    q.updated_at
FROM quotes q;

CREATE VIEW `customer_interactions` AS
SELECT
    interaction_id,
    customer_id,
    interaction_type,
    notes AS interaction_log,
    interaction_timestamp AS interaction_date,
    updated_at
FROM interactions;

CREATE VIEW `segments` AS
SELECT
    segment_id,
    segment_name AS name,
    criteria_definition AS criteria
FROM customer_segments;

CREATE VIEW `materials` AS
SELECT
    item_id AS product_id,
    product_name,
    status AS category,
    unit AS uom,
    current_stock AS stock_qty,
    minimum_level AS reorder_level
FROM inventory_items;

CREATE VIEW `automation_orders` AS
SELECT
    order_id,
    NULL AS product_id,
    1 AS qty_requested,
    order_date AS created_at,
    NULL AS due_date,
    order_status AS status
FROM orders;

CREATE VIEW `bom_header` AS
SELECT
    bom_id,
    NULL AS product_id,
    bom_version AS revision_no,
    is_active AS active,
    NULL AS created_at
FROM bills_of_materials;

CREATE VIEW `po_line_items` AS
SELECT
    po_line_id AS line_id,
    po_id,
    item_id,
    quantity AS qty_ordered,
    unit_price,
    uom
FROM purchase_order_lines;

CREATE VIEW `quality_checks` AS
SELECT
    inspection_id AS qc_id,
    production_order_id,
    pass_fail_status AS status,
    pass_rate,
    inspection_date
FROM quality_inspections;
