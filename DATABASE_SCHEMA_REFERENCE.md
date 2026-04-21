# ERP Schema Reference

This document summarizes the local ERP schema that is packaged inside the JAR.
The canonical runtime copy is `src/main/resources/schema.sql`, and it is loaded
automatically when a team creates the facade object on their local MySQL
server.

The schema covers the distributed ERP subsystems plus the shared governance
tables such as `integration_registry`, `permission_matrix`, `data_ownership`,
and `audit_logs`.

---

## Table Organization by Subsystem

### Core/Integration Tables

#### **integration_registry**
*Purpose*: Tracks all active subsystems in the ERP ecosystem
- **subsystem_id** (UUID) - Unique identifier for subsystem
- **subsystem_name** (VARCHAR) - Human-readable name (CRM, Manufacturing, HR, etc.)
- **api_key_hash** (VARCHAR) - Hash of API key for authentication
- **is_active** (BOOLEAN) - Whether subsystem is currently active
- **created_at** (TIMESTAMP) - Registration timestamp
- **updated_at** (TIMESTAMP) - Last modification timestamp

*Permissions*: All subsystems can READ (for discovery), Integration subsystem can WRITE

---

#### **permission_matrix**
*Purpose*: Defines CRUD access control for each subsystem on each table
- **permission_id** (INT) - Auto-increment identifier
- **subsystem_id** (CHAR(36)) - Reference to integration_registry
- **resource_table** (VARCHAR) - Table name being controlled
- **can_create** (BOOLEAN) - Allow INSERT operations
- **can_read** (BOOLEAN) - Allow SELECT operations
- **can_update** (BOOLEAN) - Allow UPDATE operations
- **can_delete** (BOOLEAN) - Allow DELETE operations
- **readable_columns** (JSON) - Array of column names readable by subsystem
- **writable_columns** (JSON) - Array of column names writable by subsystem
- **allowed_row_filter** (TEXT) - SQL WHERE clause for row-level security

*Permissions*: BusinessControl/Integration subsystems can WRITE, All can READ their own permissions

---

#### **data_ownership**
*Purpose*: Designates which subsystem owns/manages each table
- **ownership_id** (INT) - Auto-increment identifier
- **resource_table** (VARCHAR) - Table name
- **owner_subsystem_id** (CHAR(36)) - UUID of owning subsystem
- **stewardship_notes** (TEXT) - Notes about data management
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification date

*Permissions*: Integration subsystem OWNS, all can READ

---

### UI/User Management Tables

#### **roles**
*Purpose*: User roles within the ERP system (ADMIN, MANAGER, ANALYST, etc.)
- **role_id** (INT) - Auto-increment identifier
- **role_name** (VARCHAR) - Role name (must be unique)
- **description** (TEXT) - Role description and permissions

*Permissions*: UI subsystem owns, BusinessControl can READ, users query for their roles

---

#### **users**
*Purpose*: User accounts and authentication
- **user_id** (INT) - Auto-increment identifier
- **username** (VARCHAR) - Login username (unique)
- **email** (VARCHAR) - Email address (unique)
- **password_hash** (VARCHAR) - Bcrypt hash (never plaintext)
- **role_id** (INT) - Foreign key to roles
- **department** (VARCHAR) - Department name
- **is_active** (BOOLEAN) - Account active status
- **last_login** (DATETIME) - Last successful login timestamp
- **created_at** (TIMESTAMP) - Account creation date
- **updated_at** (TIMESTAMP) - Last account modification

*Permissions*: UI subsystem owns, BusinessControl can READ, each user can UPDATE their own record

---

#### **user_sessions**
*Purpose*: Active user sessions with JWT tokens
- **session_id** (CHAR(36)) - Session UUID
- **user_id** (INT) - Foreign key to users
- **created_at** (TIMESTAMP) - Session start time
- **expires_at** (TIMESTAMP) - Session expiration time
- **last_access_at** (TIMESTAMP) - Last activity timestamp
- **ip_address** (VARCHAR) - Client IP address
- **user_agent** (TEXT) - Client browser/app info
- **revoked_at** (TIMESTAMP) - Logout timestamp (if applicable)
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: UI subsystem owns, only self-session READ, BusinessControl can READ all

---

#### **role_permissions**
*Purpose*: Define which modules/features each role can access
- **role_permission_id** (INT) - Auto-increment identifier
- **role_id** (INT) - Foreign key to roles
- **module_name** (VARCHAR) - Module/subsystem name
- **can_create** (BOOLEAN) - Create permission
- **can_read** (BOOLEAN) - Read permission
- **can_update** (BOOLEAN) - Update permission
- **can_delete** (BOOLEAN) - Delete permission

*Permissions*: BusinessControl owns, UI can READ

---

#### **audit_logs**
*Purpose*: Immutable audit trail of all significant operations
- **audit_id** (BIGINT) - Auto-increment identifier
- **subsystem_name** (VARCHAR) - Subsystem performing action
- **user_id** (INT) - User performing action (null if system)
- **operation** (VARCHAR) - Operation type (CREATE, UPDATE, DELETE, LOGIN, LOGOUT)
- **table_name** (VARCHAR) - Table affected
- **record_id** (VARCHAR) - ID of record affected
- **old_values** (JSON) - Previous values (for UPDATE)
- **new_values** (JSON) - New values (for INSERT/UPDATE)
- **ip_address** (VARCHAR) - Source IP address
- **occurred_at** (TIMESTAMP) - Operation timestamp

*Permissions*: All subsystems can APPEND, BusinessControl/UI can READ, DELETE NOT ALLOWED (immutable)

---

#### **notifications**
*Purpose*: User notifications and alerts
- **notification_id** (INT) - Auto-increment identifier
- **user_id** (INT) - Foreign key to users
- **notification_type** (VARCHAR) - Type (info, warning, error, success)
- **title** (VARCHAR) - Notification title
- **message** (TEXT) - Notification body
- **is_read** (BOOLEAN) - Read status
- **created_at** (TIMESTAMP) - Creation timestamp
- **expires_at** (TIMESTAMP) - Expiration time (auto-purge)

*Permissions*: All subsystems can CREATE, UI can READ/UPDATE, auto-purge after 30 days

---

### CRM/Marketing Tables

#### **customers**
*Purpose*: Customer master data
- **customer_id** (INT) - Auto-increment identifier
- **name** (VARCHAR) - Full customer name
- **email** (VARCHAR) - Email address
- **phone** (VARCHAR) - Phone number
- **segment** (VARCHAR) - Customer segment (Premium, Standard, VIP)
- **region** (VARCHAR) - Geographic region
- **interested_car_model** (VARCHAR) - Vehicle model of interest
- **purchased_vin** (VARCHAR) - Vehicle Identification Number
- **vehicle_model_year** (VARCHAR) - Year of vehicle
- **lifetime_value** (DECIMAL) - Total lifetime purchase value
- **status** (VARCHAR) - Customer status (Active, Inactive, Prospect)
- **last_contact_date** (DATE) - Last contact timestamp
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: 
- CRM: FULL ACCESS
- Marketing: READ all except lifetime_value (price sensitive)
- OrderProcessing: READ (basic info only)
- SalesManagement: READ+UPDATE certain columns

---

#### **leads**
*Purpose*: Sales leads and prospects
- **lead_id** (INT) - Auto-increment identifier
- **name** (VARCHAR) - Lead name
- **email** (VARCHAR) - Email address (unique)
- **status** (VARCHAR) - Lead status (NEW, CONTACTED, QUALIFIED, CONVERTED, LOST)
- **created_at** (TIMESTAMP) - Lead creation date
- **updated_at** (TIMESTAMP) - Last status change

*Permissions*: CRM owns, SalesManagement can READ+UPDATE status, Marketing can READ

---

#### **interactions**
*Purpose*: Record of customer/lead interactions (calls, emails, meetings)
- **interaction_id** (INT) - Auto-increment identifier
- **lead_id** (INT) - Foreign key to leads (nullable)
- **customer_id** (INT) - Foreign key to customers (nullable)
- **interaction_type** (VARCHAR) - Type (call, email, meeting, chat)
- **notes** (TEXT) - Interaction details
- **interaction_timestamp** (TIMESTAMP) - When interaction occurred
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: CRM owns, all subsystems can READ their own interactions, CRM can CREATE

---

#### **deals**
*Purpose*: Sales opportunities and deal pipeline
- **deal_id** (INT) - Auto-increment identifier
- **customer_id** (INT) - Foreign key to customers
- **quote_id** (INT) - Foreign key to quotes
- **amount** (DOUBLE) - Deal value in currency
- **stage** (VARCHAR) - Pipeline stage (Prospecting, Qualification, Proposal, Negotiation, Closed)
- **status** (VARCHAR) - Status (Open, Won, Lost)
- **probability** (DOUBLE) - Win probability (0.0-1.0)
- **expected_close_date** (DATETIME) - Forecasted close date
- **created_at** (TIMESTAMP) - Deal creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: SalesManagement owns, CRM can READ+UPDATE, Reporting can READ (for dashboards)

---

#### **campaigns**
*Purpose*: Marketing campaigns for customer segments
- **campaign_id** (INT) - Auto-increment identifier
- **campaign_title** (VARCHAR) - Campaign name
- **campaign_type** (VARCHAR) - Type (email, sms, social, direct)
- **target_vehicle_segment** (VARCHAR) - Target customer segment
- **campaign_budget** (DECIMAL) - Budget allocated
- **target_leads** (JSON) - Array of target lead IDs
- **start_date** (DATE) - Campaign start date
- **end_date** (DATE) - Campaign end date
- **campaign_roi** (DECIMAL) - Return on investment percentage
- **campaign_results** (JSON) - Campaign metrics
- **created_at** (TIMESTAMP) - Creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: Marketing owns, Reporting can READ, BusinessIntelligence can READ (for analysis)

---

#### **customer_segments**
*Purpose*: Customer segment definitions
- **segment_id** (INT) - Auto-increment identifier
- **segment_name** (VARCHAR) - Segment name (Premium, VIP, Standard, etc.)
- **segment_description** (TEXT) - Segment description
- **criteria_definition** (TEXT) - SQL-like criteria for membership
- **created_at** (TIMESTAMP) - Creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: Marketing owns, all subsystems can READ, CRM can READ+CREATE

---

#### **segment_members**
*Purpose*: Membership of customers in segments
- **segment_member_id** (INT) - Auto-increment identifier
- **segment_id** (INT) - Foreign key to customer_segments
- **customer_id** (INT) - Foreign key to customers
- **assigned_at** (TIMESTAMP) - When assigned to segment
- **updated_at** (TIMESTAMP) - Last update

*Permissions*: Marketing owns, all subsystems can READ, Marketing can WRITE

---

### Sales/Order Processing Tables

#### **orders**
*Purpose*: Customer orders for vehicles
- **order_id** (INT) - Auto-increment identifier
- **customer_id** (INT) - Foreign key to customers
- **car_vin** (VARCHAR) - Foreign key to manufactured_cars
- **customer_name** (VARCHAR) - Redundant customer name (denormalized for speed)
- **customer_contact_details** (TEXT) - Contact information
- **vehicle_model** (VARCHAR) - Vehicle model ordered
- **vehicle_variant** (VARCHAR) - Model variant
- **vehicle_color** (VARCHAR) - Color selected
- **custom_features** (TEXT) - Additional features
- **order_date** (DATE) - Order date
- **order_status** (VARCHAR) - Status (Pending, Confirmed, Manufacturing, Ready, Delivered, Cancelled)
- **total_amount** (DECIMAL) - Total order value
- **payment_status** (VARCHAR) - Payment status (Pending, Partial, Paid)
- **order_details** (TEXT) - Additional order notes
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: OrderProcessing owns, CRM can READ, FinancialManagement can READ (for accounting)

---

#### **order_items**
*Purpose*: Line items within orders
- **order_item_id** (INT) - Auto-increment identifier
- **order_id** (INT) - Foreign key to orders
- **item_id** (INT) - Foreign key to inventory_items
- **quantity** (INT) - Quantity ordered
- **unit_price** (DECIMAL) - Price per unit at time of order
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: OrderProcessing owns, FinancialManagement can READ

---

#### **quotes**
*Purpose*: Price quotes for customers
- **quote_id** (INT) - Auto-increment identifier
- **customer_id** (INT) - Foreign key to customers
- **deal_id** (INT) - Foreign key to deals
- **total_amount** (DOUBLE) - Quote total before discount
- **discount** (DOUBLE) - Discount amount
- **final_amount** (DOUBLE) - Final quoted price
- **created_at** (TIMESTAMP) - Quote creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: SalesManagement owns, CRM can READ, FinancialManagement can READ

---

#### **quote_items**
*Purpose*: Line items within quotes
- **quote_item_id** (INT) - Auto-increment identifier
- **quote_id** (INT) - Foreign key to quotes
- **product_name** (VARCHAR) - Product/service name
- **quantity** (INT) - Quantity quoted
- **price** (DOUBLE) - Price per unit
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: SalesManagement owns, FinancialManagement can READ

---

#### **shipments**
*Purpose*: Shipping and delivery tracking
- **shipment_id** (INT) - Auto-increment identifier
- **order_id** (INT) - Foreign key to orders
- **shipment_status** (VARCHAR) - Status (Pending, Shipped, In-Transit, Delivered, Cancelled)
- **dispatch_date** (DATE) - When shipment left warehouse
- **delivery_date** (DATE) - When delivered to customer
- **carrier_info** (VARCHAR) - Shipping carrier name
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: SupplyChain owns, OrderProcessing can READ+UPDATE, CRM can READ (for customer service)

---

### Manufacturing Tables

#### **manufactured_cars**
*Purpose*: Manufactured vehicles with VIN tracking
- **vin** (VARCHAR) - Vehicle Identification Number (unique primary key)
- **model_name** (VARCHAR) - Model name
- **chassis_type** (VARCHAR) - Chassis type
- **build_status** (VARCHAR) - Build status (Design, In-Progress, Quality-Check, Ready, Delivered)
- **assembly_line** (VARCHAR) - Which assembly line (Line 1, 2, 3, etc.)
- **color** (VARCHAR) - Vehicle color
- **created_at** (TIMESTAMP) - Build start date

*Permissions*: Manufacturing owns, all subsystems can READ, CRM can READ (for order matching)

---

#### **bills_of_materials**
*Purpose*: BOM - Material list for manufacturing
- **bom_id** (INT) - Auto-increment identifier
- **product_name** (VARCHAR) - Product/model name
- **material_list** (JSON) - Material specifications
- **bom_version** (VARCHAR) - Version number (1.0, 1.1, etc.)
- **is_active** (BOOLEAN) - Whether currently in use
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: Manufacturing owns, all subsystems can READ (read-only)

---

#### **bom_items**
*Purpose*: Individual items within a BOM
- **bom_item_id** (INT) - Auto-increment identifier
- **bom_id** (INT) - Foreign key to bills_of_materials
- **component_id** (INT) - Foreign key to components
- **quantity_required** (DECIMAL) - Quantity per unit
- **uom** (VARCHAR) - Unit of measure
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: Manufacturing owns, SupplyChain can READ (for procurement planning)

---

#### **components**
*Purpose*: Individual components used in manufacturing
- **component_id** (INT) - Auto-increment identifier
- **item_id** (INT) - Foreign key to inventory_items (one-to-one)
- **component_code** (VARCHAR) - Internal component code (unique)
- **specification** (TEXT) - Technical specification
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: Manufacturing owns, SupplyChain can READ

---

#### **production_orders**
*Purpose*: Work orders for manufacturing
- **production_order_id** (INT) - Auto-increment identifier
- **order_id** (INT) - Foreign key to orders (nullable)
- **car_vin** (VARCHAR) - Foreign key to manufactured_cars (nullable)
- **order_quantity** (INT) - Quantity to produce
- **order_status** (VARCHAR) - Status (Draft, Released, In-Progress, Completed, Cancelled)
- **due_date** (DATE) - Target completion date
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: Manufacturing owns, OrderProcessing can READ, ProjectManagement can READ

---

#### **quality_inspections**
*Purpose*: Quality checks during manufacturing
- **inspection_id** (INT) - Auto-increment identifier
- **production_order_id** (INT) - Foreign key to production_orders
- **pass_fail_status** (VARCHAR) - Pass or Fail
- **pass_rate** (DECIMAL) - Percentage passing (0-100)
- **inspection_date** (DATE) - Inspection date
- **compliance_code** (VARCHAR) - Compliance standard reference
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: Manufacturing owns, BusinessControl can READ (for compliance)

---

#### **work_centers**
*Purpose*: Manufacturing work centers/stations
- **work_center_id** (VARCHAR) - Unique identifier
- **center_name** (VARCHAR) - Human-readable name
- **location** (VARCHAR) - Physical location
- **capacity** (INT) - Units per hour capacity
- **current_load** (INT) - Current load
- **is_active** (BOOLEAN) - Currently operational
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: Manufacturing owns, all subsystems can READ

---

#### **assembly_lines**
*Purpose*: Assembly line definitions
- **assembly_line_id** (VARCHAR) - Unique identifier
- **line_name** (VARCHAR) - Line name (Assembly Line 1, 2, etc.)
- **product_model** (VARCHAR) - Model produced
- **capacity_per_day** (INT) - Daily production capacity
- **current_status** (VARCHAR) - Status (Running, Paused, Maintenance, Offline)
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: Manufacturing owns, all subsystems can READ

---

#### **work_centers** (Assembly Line Work Centers)
*Purpose*: Individual work centers within an assembly line
- **assembly_line_work_center_id** (INT) - Auto-increment identifier
- **assembly_line_id** (VARCHAR) - Foreign key to assembly_lines
- **work_center_id** (VARCHAR) - Foreign key to work_centers
- **sequence_number** (INT) - Sequence in line
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: Manufacturing owns, all subsystems can READ

---

### Inventory/Supply Chain Tables

#### **inventory_items**
*Purpose*: Master inventory item catalog
- **item_id** (INT) - Auto-increment identifier
- **product_name** (VARCHAR) - Product name
- **description** (TEXT) - Product description
- **current_stock** (INT) - Current quantity on hand
- **minimum_level** (INT) - Reorder point
- **unit** (VARCHAR) - Unit of measure (pcs, kg, ltr, etc.)
- **price** (DECIMAL) - Unit cost/price
- **location** (VARCHAR) - Warehouse location
- **status** (VARCHAR) - Status (Active, Inactive, Discontinued)
- **last_updated** (TIMESTAMP) - Last stock update

*Permissions*: SupplyChain owns, all subsystems can READ, Manufacturing can UPDATE stock

---

#### **inventory_locations**
*Purpose*: Warehouse locations/bins
- **location_id** (INT) - Auto-increment identifier
- **location_code** (VARCHAR) - Code (e.g., A-01-001)
- **warehouse_name** (VARCHAR) - Warehouse name
- **aisle** (VARCHAR) - Aisle designation
- **bin_code** (VARCHAR) - Bin/rack code
- **is_active** (BOOLEAN) - Currently in use
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: SupplyChain owns, all subsystems can READ

---

#### **inventory_transactions**
*Purpose*: All inventory movements (stock in, out, transfers)
- **transaction_id** (INT) - Auto-increment identifier
- **item_id** (INT) - Foreign key to inventory_items
- **location_id** (INT) - Foreign key to inventory_locations
- **transaction_type** (VARCHAR) - Type (In, Out, Transfer, Adjustment, Return)
- **quantity** (INT) - Quantity moved
- **reference_type** (VARCHAR) - What triggered transaction (PO, Order, Production, etc.)
- **reference_id** (VARCHAR) - ID of triggering reference
- **transaction_timestamp** (TIMESTAMP) - When transaction occurred
- **created_by** (INT) - User who created transaction
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: SupplyChain owns, all subsystems can READ, Manufacturing can CREATE (for production)

---

#### **inventory_reorders**
*Purpose*: Reorder requests when stock falls below minimum
- **reorder_id** (INT) - Auto-increment identifier
- **item_id** (INT) - Foreign key to inventory_items
- **requested_by** (INT) - User who requested reorder
- **quantity** (INT) - Quantity to reorder
- **reorder_status** (VARCHAR) - Status (Requested, Approved, PO-Generated, Received, Cancelled)
- **requested_at** (TIMESTAMP) - When requested

*Permissions*: SupplyChain owns, all subsystems can READ, can CREATE requests

---

#### **suppliers**
*Purpose*: Supplier master data
- **supplier_id** (INT) - Auto-increment identifier
- **supplier_name** (VARCHAR) - Supplier name
- **contact_info** (TEXT) - Contact details
- **address** (TEXT) - Supplier address

*Permissions*: SupplyChain owns, all subsystems can READ

---

#### **purchase_orders**
*Purpose*: Purchase orders to suppliers
- **po_id** (INT) - Auto-increment identifier
- **supplier_id** (INT) - Foreign key to suppliers
- **order_date** (DATE) - Order date
- **status** (VARCHAR) - Status (Draft, Sent, Confirmed, Partial-Received, Received, Cancelled)
- **amount** (DECIMAL) - Total PO amount
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: SupplyChain owns, FinancialManagement can READ (for accounts payable)

---

#### **purchase_order_lines**
*Purpose*: Line items within purchase orders
- **po_line_id** (INT) - Auto-increment identifier
- **po_id** (INT) - Foreign key to purchase_orders
- **item_id** (INT) - Foreign key to inventory_items
- **quantity** (INT) - Quantity ordered
- **unit_price** (DECIMAL) - Price per unit
- **uom** (VARCHAR) - Unit of measure
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: SupplyChain owns, FinancialManagement can READ

---

#### **goods_receipts**
*Purpose*: Receipt of goods from suppliers
- **receipt_id** (INT) - Auto-increment identifier
- **po_id** (INT) - Foreign key to purchase_orders
- **received_date** (DATE) - Date received
- **received_by** (INT) - Employee who received goods
- **status** (VARCHAR) - Status (Pending, QC-Check, Accepted, Rejected)
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: SupplyChain owns, FinancialManagement can READ (for 3-way match)

---

#### **demand_forecasts**
*Purpose*: Predicted customer demand for inventory planning
- **forecast_id** (INT) - Auto-increment identifier
- **item_id** (INT) - Foreign key to inventory_items
- **predicted_demand** (INT) - Predicted quantity
- **recommended_reorder** (INT) - Recommended order quantity
- **prediction_date** (DATE) - Forecast date
- **confidence_score** (DECIMAL) - Confidence percentage (0-100)
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: DataAnalytics owns, SupplyChain can READ (for procurement planning)

---

### Financial Management Tables

#### **accounts**
*Purpose*: Chart of accounts for general ledger
- **account_id** (INT) - Auto-increment identifier
- **account_code** (VARCHAR) - Account code (e.g., 1000, 2100, 5200)
- **account_name** (VARCHAR) - Account name
- **account_type** (VARCHAR) - Type (Asset, Liability, Equity, Revenue, Expense)
- **parent_account_id** (INT) - For hierarchical structure
- **is_active** (BOOLEAN) - Currently in use
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: FinancialManagement owns, all subsystems can READ, BusinessControl can UPDATE

---

#### **transactions**
*Purpose*: Individual accounting transactions
- **transaction_id** (INT) - Auto-increment identifier
- **account_id** (INT) - Foreign key to accounts (debit side)
- **contra_account_id** (INT) - Foreign key to accounts (credit side)
- **amount** (DECIMAL) - Transaction amount
- **transaction_date** (DATE) - When transaction occurred
- **description** (TEXT) - Transaction description
- **reference_type** (VARCHAR) - What triggered (Order, Invoice, PO, etc.)
- **reference_id** (VARCHAR) - ID of reference
- **created_by** (INT) - User who created transaction
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: FinancialManagement owns, BusinessControl/Reporting can READ, FinancialManagement can CREATE

---

#### **ledger**
*Purpose*: General ledger (accounting records)
- **ledger_id** (INT) - Auto-increment identifier
- **account_id** (INT) - Foreign key to accounts
- **debit_amount** (DECIMAL) - Debit side amount
- **credit_amount** (DECIMAL) - Credit side amount
- **transaction_date** (DATE) - Transaction date
- **description** (TEXT) - Description
- **posting_status** (VARCHAR) - Status (Draft, Posted, Reversed)
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: FinancialManagement owns (append-only), all subsystems can READ

---

#### **invoices**
*Purpose*: Sales invoices to customers
- **invoice_id** (INT) - Auto-increment identifier
- **order_id** (INT) - Foreign key to orders
- **generated_date** (DATE) - Invoice date
- **invoice_amount** (DECIMAL) - Total amount
- **tax_details** (DECIMAL) - Tax amount
- **invoice_status** (VARCHAR) - Status (Draft, Sent, Paid, Overdue, Cancelled)
- **payment_status** (VARCHAR) - Payment status (Unpaid, Partial, Paid)
- **due_date** (DATE) - Payment due date
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: FinancialManagement owns, OrderProcessing can READ, Reporting can READ

---

#### **payments**
*Purpose*: Payment receipts
- **payment_id** (INT) - Auto-increment identifier
- **invoice_id** (INT) - Foreign key to invoices
- **payment_method** (VARCHAR) - Method (Cash, Check, Wire, Card, ACH)
- **payment_amount** (DECIMAL) - Amount paid
- **payment_status** (VARCHAR) - Status (Pending, Reconciled, Failed)
- **transaction_details** (TEXT) - Payment reference/confirmation
- **payment_date** (DATE) - Payment date
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: FinancialManagement owns, all subsystems can READ, BusinessControl can READ

---

#### **payables**
*Purpose*: Accounts payable (money owed to suppliers)
- **payables_id** (INT) - Auto-increment identifier
- **supplier_id** (INT) - Foreign key to suppliers
- **po_id** (INT) - Foreign key to purchase_orders
- **invoice_amount** (DECIMAL) - Amount owed
- **paid_amount** (DECIMAL) - Amount paid to date
- **due_date** (DATE) - Payment due date
- **status** (VARCHAR) - Status (Open, Partial, Paid, Overdue)
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: FinancialManagement owns, SupplyChain can READ, Reporting can READ

---

#### **receivables**
*Purpose*: Accounts receivable (money owed by customers)
- **receivables_id** (INT) - Auto-increment identifier
- **customer_id** (INT) - Foreign key to customers
- **invoice_id** (INT) - Foreign key to invoices
- **amount_due** (DECIMAL) - Total amount due
- **amount_received** (DECIMAL) - Amount received to date
- **due_date** (DATE) - Due date
- **status** (VARCHAR) - Status (Open, Partial, Paid, Overdue, Bad-Debt)
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: FinancialManagement owns, CRM/OrderProcessing can READ, Reporting can READ

---

#### **expenses**
*Purpose*: Business expense tracking
- **expense_id** (INT) - Auto-increment identifier
- **submitted_by** (INT) - Employee ID
- **expense_type** (VARCHAR) - Type (Travel, Meals, Office, etc.)
- **amount** (DECIMAL) - Expense amount
- **description** (TEXT) - Expense details
- **receipt_path** (VARCHAR) - Path to receipt document
- **status** (VARCHAR) - Status (Draft, Submitted, Approved, Rejected, Reimbursed)
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: All subsystems can CREATE (own expenses), HR can APPROVE, FinancialManagement can READ

---

#### **assets**
*Purpose*: Fixed assets tracking (equipment, vehicles, etc.)
- **asset_id** (INT) - Auto-increment identifier
- **asset_name** (VARCHAR) - Asset name
- **asset_type** (VARCHAR) - Type (Equipment, Vehicle, Building, IT)
- **purchase_date** (DATE) - Purchase date
- **purchase_price** (DECIMAL) - Original cost
- **current_value** (DECIMAL) - Current depreciated value
- **location** (VARCHAR) - Where asset is located
- **status** (VARCHAR) - Status (Active, Retired, Sold)
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: FinancialManagement owns, BusinessControl can READ

---

### HR Management Tables

#### **employees**
*Purpose*: Employee master data
- **employee_id** (INT) - Auto-increment identifier
- **user_id** (INT) - Foreign key to users (one-to-one, optional)
- **employee_name** (VARCHAR) - Full name
- **department** (VARCHAR) - Department name
- **job_role** (VARCHAR) - Job title
- **assigned_assembly_line** (VARCHAR) - If manufacturing, which line
- **shift_schedule** (VARCHAR) - Work schedule (Morning, Afternoon, Night, Flexible)
- **email** (VARCHAR) - Email address
- **phone_no** (VARCHAR) - Phone number
- **hire_date** (DATE) - Hiring date
- **salary** (DECIMAL) - Base salary
- **employment_status** (VARCHAR) - Status (Active, On-Leave, Suspended, Terminated)
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: HR owns, all subsystems can READ (basic info), HR can WRITE

---

#### **payroll**
*Purpose*: Employee payroll records
- **payroll_id** (BIGINT) - Auto-increment identifier
- **employee_id** (VARCHAR) - Employee reference
- **gross_salary** (DECIMAL) - Gross salary for period
- **deductions** (DECIMAL) - Total deductions (taxes, insurance, etc.)
- **net_pay** (DECIMAL) - Net pay after deductions
- **month** (VARCHAR) - Month (YYYY-MM format)
- **year** (INT) - Year
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: HR owns, FinancialManagement can READ (for general ledger posting), employees can READ their own

---

#### **attendance_records**
*Purpose*: Employee attendance/time tracking
- **attendance_id** (INT) - Auto-increment identifier
- **employee_id** (INT) - Foreign key to employees
- **attendance_date** (DATE) - Date
- **check_in_time** (TIME) - Time employee checked in
- **check_out_time** (TIME) - Time employee checked out
- **overtime_hours** (DOUBLE) - Overtime hours worked
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: HR owns, employees can READ their own, managers can READ their team's, HR can CREATE

---

#### **leave_requests**
*Purpose*: Employee leave/time-off requests
- **leave_request_id** (INT) - Auto-increment identifier
- **employee_id** (INT) - Foreign key to employees
- **leave_from_date** (DATE) - Start date
- **leave_to_date** (DATE) - End date
- **leave_type** (VARCHAR) - Type (Vacation, Sick, Personal, Bereavement, Unpaid)
- **leave_status** (VARCHAR) - Status (Pending, Approved, Rejected, Cancelled)
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: HR owns, employees can CREATE (own requests), managers can APPROVE

---

#### **leave_balance**
*Purpose*: Employee leave balance tracking
- **leave_balance_id** (BIGINT) - Auto-increment identifier
- **employee_id** (VARCHAR) - Employee reference (unique)
- **balance** (INT) - Days remaining (default 20)
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: HR owns, employees can READ their own

---

#### **performance_reviews**
*Purpose*: Employee performance evaluations
- **review_id** (INT) - Auto-increment identifier
- **employee_id** (INT) - Foreign key to employees
- **rating** (DECIMAL) - Rating (1-5 scale)
- **feedback** (TEXT) - Review feedback
- **review_date** (DATE) - Review date
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: HR owns, managers can CREATE (for their reports), employees can READ their own

---

#### **appraisal**
*Purpose*: Annual performance appraisals
- **appraise_id** (VARCHAR) - Unique identifier
- **employee_id** (VARCHAR) - Employee reference
- **appraisal_status** (ENUM) - Status (COMPLETED, PENDING)
- **deadline_date** (DATE) - Appraisal deadline
- **feedback** (VARCHAR) - Appraisal feedback
- **locked** (BOOLEAN) - Whether locked/finalized
- **rating** (DOUBLE) - Appraisal rating
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: HR owns, managers can CREATE, HR can FINALIZE

---

#### **recruitment_candidates**
*Purpose*: Job candidates
- **candidate_id** (INT) - Auto-increment identifier
- **candidate_name** (VARCHAR) - Name
- **contact_info** (TEXT) - Contact details
- **resume_data** (TEXT) - Resume/CV content
- **interview_score** (DECIMAL) - Interview score
- **application_status** (VARCHAR) - Status (Applied, Interview, Selected, Rejected)
- **created_at** (TIMESTAMP) - Application date

*Permissions*: HR owns, all subsystems can READ

---

#### **promotion**
*Purpose*: Employee promotions
- **promotion_id** (VARCHAR) - Unique identifier
- **employee_id** (VARCHAR) - Employee being promoted
- **effective_date** (DATE) - Promotion effective date
- **new_role** (VARCHAR) - New job role
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: HR owns, BusinessControl can READ

---

#### **onboarding_record**
*Purpose*: Employee onboarding checklist
- **onboarding_id** (VARCHAR) - Unique identifier
- **employee_name** (VARCHAR) - New employee name
- **assigned_employee_id** (VARCHAR) - Assigned mentor/manager
- **background_check_status** (ENUM) - Status (CLEARED, FAILED, PENDING)
- **document_verification_status** (ENUM) - Status (VERIFIED, REJECTED, PENDING)
- **pipeline_status** (ENUM) - Overall status
- **verified_record** (BOOLEAN) - All checks passed
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: HR owns, IT can UPDATE status updates, HR can READ

---

### Project Management Tables

#### **projects**
*Purpose*: Project definitions
- **project_id** (INT) - Auto-increment identifier
- **name** (VARCHAR) - Project name
- **description** (TEXT) - Project description
- **manager_name** (VARCHAR) - Project manager
- **start_date** (DATE) - Start date
- **end_date** (DATE) - Target end date
- **status** (VARCHAR) - Status (Planning, Active, Paused, Completed, Cancelled)
- **objectives** (TEXT) - Project objectives
- **progress_pct** (DECIMAL) - Progress percentage (0-100)
- **budget_total** (DECIMAL) - Total budget
- **budget_spent** (DECIMAL) - Amount spent to date
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: ProjectManagement owns, all subsystems can READ, BusinessControl can READ (for governance)

---

#### **tasks** (within projects)
*Purpose*: Tasks/work items within projects
- **task_id** (INT) - Auto-increment identifier
- **project_id** (INT) - Foreign key to projects
- **task_name** (VARCHAR) - Task name
- **description** (TEXT) - Task description
- **start_date** (DATE) - Start date
- **due_date** (DATE) - Due date
- **status** (VARCHAR) - Status (Open, In-Progress, Completed, Blocked, Cancelled)
- **priority** (VARCHAR) - Priority (Low, Medium, High, Critical)
- **assigned_to** (INT) - Employee assigned (foreign key)
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: ProjectManagement owns, assigned employees can READ/UPDATE their tasks

---

#### **dependencies** (task dependencies)
*Purpose*: Task dependency relationships
- **dependency_id** (INT) - Auto-increment identifier
- **task_id** (INT) - Task that depends on...
- **depends_on_task_id** (INT) - ...this task
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: ProjectManagement owns, all can READ

---

#### **resources** (project resources)
*Purpose*: People/resources assigned to projects
- **resource_id** (INT) - Auto-increment identifier
- **project_id** (INT) - Foreign key to projects
- **name** (VARCHAR) - Resource name
- **role** (VARCHAR) - Role (Developer, Designer, Manager, etc.)
- **availability** (BOOLEAN) - Available status
- **skill_set** (VARCHAR) - Skills
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: ProjectManagement owns, all can READ

---

#### **project_team_members**
*Purpose*: Team members assigned to project
- **project_team_member_id** (INT) - Auto-increment identifier
- **project_id** (INT) - Foreign key to projects
- **user_id** (INT) - Foreign key to users
- **role_in_project** (VARCHAR) - Role (Lead, Contributor, Stakeholder, etc.)
- **joined_at** (TIMESTAMP) - When joined
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: ProjectManagement owns, team members can READ their projects

---

#### **assignment** (task assignment)
*Purpose*: Assignment of resources to tasks
- **assignment_id** (INT) - Auto-increment identifier
- **task_id** (INT) - Foreign key to tasks
- **resource_id** (INT) - Foreign key to resources
- **assigned_on** (DATE) - Assignment date
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: ProjectManagement owns

---

#### **budget** (project budget)
*Purpose*: Budget allocation for projects
- **budget_id** (INT) - Auto-increment identifier
- **project_id** (INT) - Foreign key to projects
- **allocated_amount** (DECIMAL) - Allocated budget
- **approved_amount** (DECIMAL) - Approved budget
- **fiscal_period** (VARCHAR) - Period (Q1, Q2, etc.)
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: ProjectManagement/BusinessControl own, all can READ

---

### Business Intelligence / Analytics Tables

#### **dashboards**
*Purpose*: BI dashboards for data visualization
- **dashboard_id** (INT) - Auto-increment identifier
- **dashboard_name** (VARCHAR) - Name
- **dashboard_description** (TEXT) - Description
- **owner_subsystem** (VARCHAR) - Owning subsystem
- **created_by** (INT) - Creator user ID
- **is_public** (BOOLEAN) - Public/private
- **created_at** (TIMESTAMP) - Record creation date
- **updated_at** (TIMESTAMP) - Last modification

*Permissions*: Reporting/BusinessIntelligence own, all can READ

---

#### **kpis** (Key Performance Indicators)
*Purpose*: KPI definitions
- **kpi_id** (INT) - Auto-increment identifier
- **kpi_name** (VARCHAR) - KPI name
- **kpi_formula** (TEXT) - Calculation formula
- **target_value** (DECIMAL) - Target value
- **measurement_unit** (VARCHAR) - Unit
- **owner_department** (VARCHAR) - Responsible department
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: Reporting/BusinessIntelligence own, all can READ

---

#### **kpi_snapshots**
*Purpose*: Historical KPI values over time
- **snapshot_id** (INT) - Auto-increment identifier
- **kpi_id** (INT) - Foreign key to kpis
- **snapshot_date** (DATE) - Date of snapshot
- **measured_value** (DECIMAL) - Measured value
- **variance_from_target** (DECIMAL) - Difference from target
- **trend** (VARCHAR) - Trend (Up, Down, Stable)
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: Reporting owns, all can READ

---

#### **reports**
*Purpose*: Report definitions
- **report_id** (INT) - Auto-increment identifier
- **report_name** (VARCHAR) - Report name
- **report_type** (VARCHAR) - Type (Financial, Sales, Inventory, HR, etc.)
- **query_definition** (TEXT) - SQL query or filter
- **owner_subsystem** (VARCHAR) - Owner
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: Reporting owns, all can READ

---

#### **report_runs**
*Purpose*: Execution history of reports
- **run_id** (INT) - Auto-increment identifier
- **report_id** (INT) - Foreign key to reports
- **executed_by** (INT) - User who ran
- **execution_date** (TIMESTAMP) - When executed
- **row_count** (INT) - Number of rows returned
- **duration_ms** (INT) - Execution time in milliseconds
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: Reporting owns, all can READ their own runs

---

#### **analysis_results**
*Purpose*: Data analysis results
- **analysis_id** (INT) - Auto-increment identifier
- **analysis_name** (VARCHAR) - Analysis name
- **analysis_type** (VARCHAR) - Type (Trend, Correlation, Forecast, Anomaly)
- **result_summary** (TEXT) - Summary of findings
- **result_data** (JSON) - Detailed results
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: DataAnalytics owns, Reporting/BusinessIntelligence can READ

---

#### **trend_results**
*Purpose*: Trend analysis results
- **trend_id** (INT) - Auto-increment identifier
- **metric_name** (VARCHAR) - Metric being trended
- **trend_direction** (VARCHAR) - Direction (Up, Down, Stable)
- **percent_change** (DECIMAL) - Percentage change
- **time_period** (VARCHAR) - Time period analyzed
- **confidence_level** (DECIMAL) - Statistical confidence (0-1)
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: DataAnalytics owns, all can READ

---

#### **forecast_results**
*Purpose*: Forecasting results
- **forecast_id** (INT) - Auto-increment identifier
- **forecast_type** (VARCHAR) - Type (Sales, Demand, Revenue, etc.)
- **forecast_value** (DECIMAL) - Forecasted value
- **forecast_period** (VARCHAR) - Period (Next Month, Quarter, Year)
- **accuracy_percentage** (DECIMAL) - Forecast accuracy
- **created_at** (TIMESTAMP) - Record creation date

*Permissions*: DataAnalytics owns, all can READ

---

### Local Exception Handling

Exception handling is part of the SDK itself instead of a separate subsystem.
The runtime classes are:

- `ExceptionCode`
- `DatabaseOperationException`
- `LocalExceptionHandler`
- `UnauthorizedResourceAccessException`
- `ExceptionLogger`

`ExceptionLogger` writes into `audit_logs`, not into a separate exception
database. That keeps the deployment self-contained while still preserving the
failure context for local debugging.

---

## Cross-Subsystem Data Access Patterns

### Common Queries

**CRM needs customers with sales data:**
```sql
SELECT c.customer_id, c.name, o.order_id, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE c.status = 'Active'
  AND o.order_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
```

**Financial needs to reconcile customer payments:**
```sql
SELECT c.customer_id, c.name, i.invoice_id, i.invoice_amount, p.payment_amount
FROM customers c
INNER JOIN invoices i ON c.customer_id = (SELECT customer_id FROM orders WHERE order_id = i.order_id)
LEFT JOIN payments p ON i.invoice_id = p.invoice_id
WHERE i.invoice_status = 'Sent'
```

**Manufacturing needs BOM and inventory:**
```sql
SELECT bom.bom_id, bom.product_name, bi.component_id, bi.quantity_required, ii.current_stock
FROM bills_of_materials bom
INNER JOIN bom_items bi ON bom.bom_id = bi.bom_id
INNER JOIN inventory_items ii ON bi.component_id = ii.item_id
WHERE bom.is_active = TRUE
  AND ii.current_stock < ii.minimum_level
```

---

## Permission Matrix Setup Examples

### Setup for CRM Subsystem

```json
{
  "subsystem_name": "CRM",
  "permissions": [
    {
      "table": "customers",
      "can_create": true,
      "can_read": true,
      "can_update": true,
      "can_delete": false,
      "readable_columns": ["*"],
      "writable_columns": ["name", "email", "phone", "segment", "status"],
      "row_filter": "region IN (SELECT allowed_regions FROM crm_config WHERE team_id = ?)"
    },
    {
      "table": "leads",
      "can_create": true,
      "can_read": true,
      "can_update": true,
      "can_delete": false,
      "readable_columns": ["*"],
      "writable_columns": ["status", "notes"],
      "row_filter": null
    },
    {
      "table": "orders",
      "can_create": false,
      "can_read": true,
      "can_update": false,
      "can_delete": false,
      "readable_columns": ["customer_id", "order_id", "order_status", "order_date"],
      "writable_columns": [],
      "row_filter": null
    }
  ]
}
```

### Setup for Manufacturing Subsystem

```json
{
  "subsystem_name": "Manufacturing",
  "permissions": [
    {
      "table": "production_orders",
      "can_create": true,
      "can_read": true,
      "can_update": true,
      "can_delete": false,
      "readable_columns": ["*"],
      "writable_columns": ["order_status", "due_date"],
      "row_filter": null
    },
    {
      "table": "inventory_items",
      "can_create": false,
      "can_read": true,
      "can_update": true,
      "can_delete": false,
      "readable_columns": ["item_id", "product_name", "current_stock", "minimum_level"],
      "writable_columns": ["current_stock"],
      "row_filter": null
    },
    {
      "table": "bills_of_materials",
      "can_create": false,
      "can_read": true,
      "can_update": false,
      "can_delete": false,
      "readable_columns": ["*"],
      "writable_columns": [],
      "row_filter": null
    }
  ]
}
```

---

## Index Strategy for Performance

*Note: Schema already includes optimal indexes. Key indexes:*

- Primary keys on all ID columns
- Unique indexes on natural keys (email, code, name where appropriate)
- Foreign key indexes for join performance
- Composite indexes on frequently filtered columns (status, date ranges)
- Timestamp indexes for time-series queries
- Subsystem ID indexes in permission_matrix and integration_registry

---

## Reference Material

- **Database Schema**: See schema.sql in resources
- **Configuration**: See application-local-template.properties
- **Integration Guide**: See INTEGRATION.md
- **Exception Codes**: See ErpExceptionRegistry.java
- **Architecture**: See DATABASE_ARCHITECTURE.md

---

*This document is maintained by the ERP Team. Last updated: 2026*
