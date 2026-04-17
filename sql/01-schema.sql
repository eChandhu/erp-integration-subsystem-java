CREATE DATABASE IF NOT EXISTS erp_subsystem;
USE erp_subsystem;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS inventory_reorders;
DROP TABLE IF EXISTS dashboard_widgets;
DROP TABLE IF EXISTS dashboards;
DROP TABLE IF EXISTS metrics;
DROP TABLE IF EXISTS datasets;
DROP TABLE IF EXISTS data_sources;
DROP TABLE IF EXISTS task_dependencies;
DROP TABLE IF EXISTS project_team_members;
DROP TABLE IF EXISTS inventory_transactions;
DROP TABLE IF EXISTS inventory_locations;
DROP TABLE IF EXISTS bom_items;
DROP TABLE IF EXISTS components;
DROP TABLE IF EXISTS goods_receipts;
DROP TABLE IF EXISTS purchase_order_lines;
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
DROP TABLE IF EXISTS reports;
DROP TABLE IF EXISTS project_risks;
DROP TABLE IF EXISTS project_expenses;
DROP TABLE IF EXISTS project_milestones;
DROP TABLE IF EXISTS project_resources;
DROP TABLE IF EXISTS project_tasks;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS quality_inspections;
DROP TABLE IF EXISTS production_orders;
DROP TABLE IF EXISTS mrp_plans;
DROP TABLE IF EXISTS routings;
DROP TABLE IF EXISTS bills_of_materials;
DROP TABLE IF EXISTS demand_forecasts;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS purchase_orders;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS manufactured_cars;
DROP TABLE IF EXISTS inventory_items;
DROP TABLE IF EXISTS campaigns;
DROP TABLE IF EXISTS customer_interactions;
DROP TABLE IF EXISTS sales_quotations;
DROP TABLE IF EXISTS sales_opportunities;
DROP TABLE IF EXISTS crm_leads;
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

CREATE TABLE crm_leads (
    lead_id INT AUTO_INCREMENT PRIMARY KEY,
    lead_name VARCHAR(120) NOT NULL,
    lead_source VARCHAR(50),
    lead_status VARCHAR(50),
    vehicle_model_of_interest VARCHAR(100),
    trim_variant_preference VARCHAR(100),
    test_drive_scheduled BOOLEAN DEFAULT FALSE,
    trade_in_vehicle_details JSON NULL,
    financing_preference VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sales_opportunities (
    opportunity_id INT AUTO_INCREMENT PRIMARY KEY,
    lead_id INT NULL,
    customer_id INT NULL,
    client_name VARCHAR(120),
    car_model VARCHAR(100),
    deal_value DECIMAL(15,2),
    win_probability_pct DECIMAL(5,2),
    expected_close_date DATE,
    status VARCHAR(50),
    stage VARCHAR(50),
    CONSTRAINT fk_sales_opp_lead FOREIGN KEY (lead_id) REFERENCES crm_leads(lead_id),
    CONSTRAINT fk_sales_opp_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE sales_quotations (
    quote_id INT AUTO_INCREMENT PRIMARY KEY,
    opportunity_id INT NOT NULL,
    total_amount DECIMAL(15,2),
    max_discount_limit DECIMAL(15,2),
    discount DECIMAL(15,2),
    final_amount DECIMAL(15,2),
    CONSTRAINT fk_sales_quote_opp FOREIGN KEY (opportunity_id) REFERENCES sales_opportunities(opportunity_id)
);

CREATE TABLE customer_interactions (
    interaction_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    interaction_type VARCHAR(50),
    interaction_log TEXT,
    interaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_customer_interaction_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

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

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    manager_name VARCHAR(120),
    start_date DATE,
    end_date DATE,
    status VARCHAR(30),
    objectives TEXT,
    progress_pct DECIMAL(5,2),
    budget_total DECIMAL(15,2),
    budget_spent DECIMAL(15,2)
);

CREATE TABLE project_tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    task_name VARCHAR(120),
    description TEXT,
    start_date DATE,
    due_date DATE,
    status VARCHAR(30),
    priority VARCHAR(30),
    assigned_to INT NULL,
    CONSTRAINT fk_project_task_project FOREIGN KEY (project_id) REFERENCES projects(project_id),
    CONSTRAINT fk_project_task_employee FOREIGN KEY (assigned_to) REFERENCES employees(employee_id)
);

CREATE TABLE task_dependencies (
    dependency_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    depends_on_task_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_task_dependency_task FOREIGN KEY (task_id) REFERENCES project_tasks(task_id),
    CONSTRAINT fk_task_dependency_depends FOREIGN KEY (depends_on_task_id) REFERENCES project_tasks(task_id),
    CONSTRAINT uq_task_dependency UNIQUE (task_id, depends_on_task_id)
);

CREATE TABLE project_resources (
    resource_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    name VARCHAR(120),
    role VARCHAR(80),
    availability BOOLEAN,
    skill_set VARCHAR(120),
    CONSTRAINT fk_project_resource_project FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE project_team_members (
    project_team_member_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    user_id INT NOT NULL,
    role_in_project VARCHAR(80),
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_project_team_project FOREIGN KEY (project_id) REFERENCES projects(project_id),
    CONSTRAINT fk_project_team_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT uq_project_team UNIQUE (project_id, user_id)
);

CREATE TABLE data_sources (
    data_source_id INT AUTO_INCREMENT PRIMARY KEY,
    source_name VARCHAR(120) NOT NULL UNIQUE,
    source_type VARCHAR(50) NOT NULL,
    connection_details TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE datasets (
    dataset_id INT AUTO_INCREMENT PRIMARY KEY,
    data_source_id INT NOT NULL,
    dataset_name VARCHAR(120) NOT NULL,
    processing_stage VARCHAR(30) NOT NULL,
    schema_definition TEXT,
    refresh_frequency VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_dataset_source FOREIGN KEY (data_source_id) REFERENCES data_sources(data_source_id),
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
    description TEXT,
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

CREATE TABLE project_milestones (
    milestone_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    name VARCHAR(120),
    target_date DATE,
    completion_status BOOLEAN,
    description TEXT,
    CONSTRAINT fk_project_milestone_project FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE project_expenses (
    expense_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    expense_date DATE,
    description TEXT,
    category VARCHAR(80),
    amount DECIMAL(15,2),
    CONSTRAINT fk_project_expense_project FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE project_risks (
    risk_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    description TEXT,
    severity VARCHAR(30),
    status VARCHAR(30),
    mitigation_plan TEXT,
    CONSTRAINT fk_project_risk_project FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(120),
    report_type VARCHAR(100),
    generated_by INT NULL,
    generated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    start_date DATE,
    end_date DATE,
    content TEXT,
    CONSTRAINT fk_report_user FOREIGN KEY (generated_by) REFERENCES users(user_id)
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

ALTER TABLE roles ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE employees ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE customers ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE crm_leads ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE sales_opportunities ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE sales_quotations ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE customer_interactions ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE suppliers ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE manufactured_cars ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE orders ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE purchase_orders ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE invoices ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE payments ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE demand_forecasts ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE bills_of_materials ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE routings ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE mrp_plans ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE production_orders ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE quality_inspections ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE recruitment_candidates ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE payroll_records ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE attendance_records ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE leave_requests ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE performance_reviews ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE projects ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE project_tasks ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE project_resources ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE project_milestones ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE project_expenses ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE project_risks ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE reports ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE report_templates ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE report_filters ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE report_exports ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE approval_requests ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE notifications ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE audit_logs ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

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
('Financial Management', 'hash_finance');

INSERT INTO data_ownership (resource_table, owner_subsystem_id, stewardship_notes)
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
('Finance Lead', 'Financial access');

INSERT INTO users (username, email, password_hash, role_id, department) VALUES
('admin_main', 'admin@erp.com', 'hashed_pw_admin', 1, 'Integration'),
('integration_lead', 'integration@erp.com', 'hashed_pw_integration', 2, 'Integration'),
('mfg_lead', 'mfg@erp.com', 'hashed_pw_mfg', 3, 'Manufacturing'),
('supply_lead', 'supply@erp.com', 'hashed_pw_supply', 4, 'Supply Chain'),
('finance_user', 'finance@erp.com', 'hashed_pw_finance', 5, 'Finance');

INSERT INTO employees (user_id, employee_name, department, job_role, assigned_assembly_line, shift_schedule, email, hire_date, salary, employment_status) VALUES
(3, 'Mike Builder', 'Manufacturing', 'Production Lead', 'AL-1', 'Morning', 'mfg@erp.com', '2024-05-20', 75000.00, 'Active');

INSERT INTO customers (name, email, phone, segment, region, interested_car_model, lifetime_value, status, last_contact_date) VALUES
('Arjun Mehta', 'arjun@email.com', '9876500001', 'Premium', 'Bengaluru', 'Sedan X', 1250000.00, 'Active', '2026-03-20');

INSERT INTO inventory_items (product_name, description, current_stock, minimum_level, unit, price, location, status) VALUES
('Battery Pack', 'EV battery module', 120, 40, 'Unit', 250000.00, 'WH-A1', 'Available'),
('Brake Assembly', 'Front brake set', 80, 25, 'Unit', 18000.00, 'WH-B3', 'Available');

INSERT INTO suppliers (supplier_name, contact_info, address) VALUES
('VoltEdge Supplies', 'voltedge@example.com', 'Bengaluru, Karnataka');

INSERT INTO purchase_orders (supplier_id, order_date, status, amount) VALUES
(1, '2026-04-10', 'Approved', 5000000.00);

INSERT INTO manufactured_cars (vin, model_name, chassis_type, build_status, assembly_line, color) VALUES
('VIN1001', 'Sedan X', 'Monocoque', 'Assembly', 'AL-1', 'Black'),
('VIN1002', 'SUV Z', 'Ladder', 'Paint', 'AL-2', 'White');

INSERT INTO orders (customer_id, car_vin, customer_name, customer_contact_details, vehicle_model, vehicle_variant, vehicle_color, custom_features, order_status, total_amount, payment_status, order_details) VALUES
(1, 'VIN1001', 'Arjun Mehta', '9876500001', 'Sedan X', 'Top Trim', 'Black', 'Sunroof, ADAS', 'Processing', 2200000.00, 'Partial', 'Priority delivery');

INSERT INTO projects (name, description, manager_name, start_date, end_date, status, objectives, progress_pct, budget_total, budget_spent) VALUES
('ERP Canonical DB', 'Canonical ERP database design', 'Rohit PM', '2026-03-01', '2026-05-01', 'In Progress', 'Consolidate subsystem data', 72.50, 1000000.00, 640000.00);

INSERT INTO project_tasks (project_id, task_name, description, start_date, due_date, status, priority, assigned_to) VALUES
(1, 'Finalize integration governance', 'Implement permission and audit corrections', '2026-04-01', '2026-04-20', 'In Progress', 'High', 1),
(1, 'Create BI tables', 'Add dashboards and metrics model', '2026-04-03', '2026-04-22', 'Open', 'Medium', 1);

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

INSERT INTO datasets (data_source_id, dataset_name, processing_stage, schema_definition, refresh_frequency) VALUES
(1, 'orders_raw', 'raw', 'orders raw schema', 'hourly');

INSERT INTO metrics (dataset_id, metric_name, metric_formula, unit) VALUES
(1, 'Revenue YTD', 'SUM(total_amount)', 'INR');

INSERT INTO dashboards (dashboard_name, owner_user_id, description) VALUES
('Executive Dashboard', 1, 'Executive KPI view');

INSERT INTO dashboard_widgets (dashboard_id, widget_title, widget_type, metric_id, dataset_id, position_x, position_y, width_units, height_units) VALUES
(1, 'Revenue KPI', 'KPI', 1, 1, 0, 0, 2, 1);

INSERT INTO project_team_members (project_id, user_id, role_in_project) VALUES
(1, 1, 'Integration Admin');

INSERT INTO task_dependencies (task_id, depends_on_task_id) VALUES
(2, 1);

INSERT INTO permission_matrix
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
SELECT subsystem_id, 'task_dependencies', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('dependency_id','task_id','depends_on_task_id','created_at','updated_at'),
JSON_ARRAY('task_id','depends_on_task_id'),
NULL
FROM integration_registry WHERE subsystem_name = 'Project Management'
UNION ALL
SELECT subsystem_id, 'project_team_members', TRUE, TRUE, TRUE, FALSE,
JSON_ARRAY('project_team_member_id','project_id','user_id','role_in_project','joined_at','updated_at'),
JSON_ARRAY('project_id','user_id','role_in_project'),
NULL
FROM integration_registry WHERE subsystem_name = 'Project Management';
