/*=============================================================================================
--====CREATING DDL FOR BRONZE LAYER
===============================================================================================
purpose : 
	these script will create tables for bronze layer ,
	if table is already created if will drop table and recreate .
	
	the script will create these following table .
        - sales_transactions
        - customers 
        - products
        - stores
        - employees
        - returns
        - reviews
        - inventory_snapshots

WARNING :
	execute these script will drop you tables if exists
	all data will permanently deleted .
	
	ensure that backup are available before executing these script .
	
Author : Ritik__
Created on : 2026-06-16
Version : 1.0
project : DataWarehouse | RetailDB
schema : Bronze

Environment :
	Development / Testing
	
Dependencies :
    - SQL Server Management Studio (SSMS)
=============================================================================================*/

-- Safety check to ensure we are connected to the correct database
IF DB_NAME() NOT IN ('RetailDB')
BEGIN
    THROW 50000, 'Error: Not connected to RetailDB database. Please switch to RetailDB before running this script.', 1;
    RETURN;
END;
GO

---- Switch to RetailDB database
USE RetailDB;
GO

/*=============================================================
source : API | Table  : customers |schema : bronze
=============================================================*/

IF OBJECT_ID('bronze.customers', 'U') IS NOT NULL 
BEGIN 
    PRINT '>> dropping table bronze.customers..';
    DROP TABLE bronze.customers ;
END ;
GO

PRINT '>> creating table bronze.customers...';
CREATE TABLE bronze.customers
(
    customer_id             INT          NULL,
    title                   VARCHAR(10)  NULL,
    first_name              VARCHAR(50)  NULL,
    last_name               VARCHAR(50)  NULL,
    full_name               VARCHAR(120) NULL,
    gender                  VARCHAR(50)  NULL,
    date_of_birth           VARCHAR(50)  NULL,
    age                     INT          NULL,
    email                   VARCHAR(200) NULL,
    phone                   VARCHAR(30)  NULL,
    address                 VARCHAR(200) NULL,
    city                    VARCHAR(50)  NULL,
    state                   VARCHAR(50)  NULL,
    state_abbr              VARCHAR(10)  NULL,
    state_full              VARCHAR(50)  NULL,
    zip_code                INT          NULL,
    country                 VARCHAR(100) NULL,
    region                  VARCHAR(50)  NULL,
    customer_segment        VARCHAR(50)  NULL,
    loyalty_points          INT          NULL,
    is_active               VARCHAR(50)  NULL,
    account_created_date    VARCHAR(50)  NULL,
    preferred_channel       VARCHAR(50)  NULL,
    annual_income_usd       INT          NULL,
    company                 VARCHAR(100) NULL
) ;
GO

/*=============================================================
source : API | Table  : employees |schema : bronze
=============================================================*/
IF OBJECT_ID('bronze.employees', 'U') IS NOT NULL
BEGIN 
    PRINT '>> dropping table bronze.employees....';
    DROP TABLE bronze.employees ;
END ;
GO

PRINT '>> creating bronze.employees table... ' ;
CREATE TABLE bronze.employees
(
    employee_id             INT           NULL,
    first_name              VARCHAR(50)   NULL,
    last_name               VARCHAR(50)   NULL,
    full_name               VARCHAR(100)  NULL,
    email                   VARCHAR(200)  NULL,
    phone                   VARCHAR(30)   NULL,
    job_title               VARCHAR(50)   NULL,
    department              VARCHAR(50)   NULL,
    store_id                INT           NULL,
    store_name              VARCHAR(150)  NULL,
    store_city              VARCHAR(100)  NULL,
    hire_date               VARCHAR(50)   NULL,
    years_employed          INT           NULL,
    annual_salary_usd       INT           NULL,
    commission_rate_pct     FLOAT         NULL,
    is_active               VARCHAR(50)   NULL,
    performance_rating      VARCHAR(50)   NULL,
    manager_id              INT           NULL
);
GO

/*=============================================================
source : API | Table  : inventory_snapshots |schema : bronze
=============================================================*/
IF OBJECT_ID('bronze.inventory_snapshots', 'U') IS NOT NULL
BEGIN 
    PRINT '>> dropping table bronze.inventory_snapshots...';
    DROP TABLE bronze.inventory_snapshots ;
END ;
GO

PRINT '>> creating bronze.inventory_snapshots table... ';
CREATE TABLE bronze.inventory_snapshots
(
    snapshot_date           VARCHAR(50)   NULL,
    product_id              INT           NULL,
    product_name            VARCHAR(150)  NULL,
    sku                     VARCHAR(100)  NULL,
    category                VARCHAR(100)  NULL,
    stock_on_hand           INT           NULL,
    stock_reserved          INT           NULL,
    stock_available         VARCHAR(50)   NULL,
    reorder_level           INT           NULL,
    unit_cost               VARCHAR(50)   NULL,
    unit_price              VARCHAR(50)   NULL,
    inventory_value         VARCHAR(50)   NULL,
    warehouse_location      VARCHAR(20)   NULL,
    store_id                INT           NULL
);
GO

/*=============================================================
source : API | Table  : products |schema : bronze
=============================================================*/
IF OBJECT_ID('bronze.products', 'U') IS NOT NULL
BEGIN
    PRINT '>> dropping table bronze.products...';
    DROP TABLE bronze.products ;
END ;
GO

PRINT '>> creating bronze.products table... ';
CREATE TABLE bronze.products
(
    product_id              INT           NULL,
    sku                     VARCHAR(100)  NULL,
    product_name            VARCHAR(200)  NULL,
    brand                   VARCHAR(100)  NULL,
    category                VARCHAR(100)  NULL,
    sub_category            VARCHAR(100)  NULL,
    department              VARCHAR(100)  NULL,
    base_price_usd          VARCHAR(50)   NULL,
    cost_price_usd          VARCHAR(50)   NULL,
    gross_margin_pct        FLOAT         NULL,
    weight_kg               FLOAT         NULL,
    is_available            VARCHAR(50)   NULL,
    stock_quantity          INT           NULL,
    reorder_level           INT           NULL,
    supplier_name           VARCHAR(150)  NULL,
    supplier_country        VARCHAR(100)  NULL,
    warranty_years          INT           NULL,
    rating_avg              FLOAT         NULL,
    review_count            INT           NULL,
    launched_date           VARCHAR(50)   NULL,
    product_url             VARCHAR(255)  NULL
);
GO

/*=============================================================
source : API | Table  : returns |schema : bronze
=============================================================*/
IF OBJECT_ID('bronze.returns', 'U') IS NOT NULL
BEGIN 
    PRINT '>> dropping table bronze.returns....' ;
    DROP TABLE bronze.returns ;
END ;
GO

PRINT 'creating table bronze.returns' ;
CREATE TABLE bronze.returns
(
    return_id               INT           NULL,
    original_txn_id         VARCHAR(50)   NULL,
    original_order_id       INT           NULL,
    customer_id             INT           NULL,
    customer_name           VARCHAR(100)  NULL,
    product_id              INT           NULL,
    product_name            VARCHAR(100)  NULL,
    quantity_returned       INT           NULL,
    return_date             VARCHAR(50)   NULL,
    return_reason           VARCHAR(50)   NULL,
    refund_amount           VARCHAR(50)   NULL,
    refund_method           VARCHAR(50)   NULL,
    return_channel          VARCHAR(50)   NULL,
    restocked               VARCHAR(50)   NULL,
    return_status           VARCHAR(50)   NULL,
    handled_by_emp_id       INT           NULL,
    notes                   VARCHAR(100)  NULL
);
GO

/*=============================================================
source : API | Table  : reviews |schema : bronze
=============================================================*/
IF OBJECT_ID('bronze.reviews', 'U') IS NOT NULL
BEGIN 
    PRINT '>> dropping table bronze.reviews....' ;
    DROP TABLE bronze.reviews ;
END ;
GO

PRINT 'creating table bronze.reviews' ;
CREATE TABLE bronze.reviews
(
    review_id               INT           NULL,
    txn_id                  VARCHAR(100)  NULL,
    customer_id             INT           NULL,
    customer_name           VARCHAR(100)  NULL,
    product_id              INT           NULL,
    product_name            VARCHAR(150)  NULL,
    rating                  INT           NULL,
    rating_text             VARCHAR(50)   NULL,
    review_date             VARCHAR(50)   NULL,
    verified_purchase       VARCHAR(50)   NULL,
    helpful_votes           INT           NULL,
    review_channel          VARCHAR(50)   NULL,
    review_title            VARCHAR(100)  NULL
);
GO

/*=============================================================
source : API | Table  : sales_transactions |schema : bronze
=============================================================*/
IF OBJECT_ID('bronze.sales_transactions', 'U') IS NOT NULL
BEGIN
    PRINT '>> dropping table bronze.sales_transactions...';
    DROP TABLE bronze.sales_transactions;
END ;
GO

PRINT 'creating table bronze.sales_transactions' ;
CREATE TABLE bronze.sales_transactions
(
    transaction_id          VARCHAR(100)  NULL,
    order_id                INT           NULL,
    order_line_number       INT           NULL,
    order_date              VARCHAR(50)   NULL,
    order_year              INT           NULL,
    order_month             INT           NULL,
    order_month_name        VARCHAR(50)   NULL,
    order_quarter           VARCHAR(50)   NULL,
    order_day_of_week       VARCHAR(50)   NULL,
    ship_date               VARCHAR(50)   NULL,
    delivery_date           VARCHAR(50)   NULL,
    customer_id             INT           NULL,
    customer_full_name      VARCHAR(50)   NULL,
    customer_first_name     VARCHAR(50)   NULL,
    customer_last_name      VARCHAR(50)   NULL,
    customer_email          VARCHAR(50)   NULL,
    customer_phone          VARCHAR(50)   NULL,
    customer_city           VARCHAR(50)   NULL,
    customer_state          VARCHAR(50)   NULL,
    customer_zip            INT           NULL,
    customer_region         VARCHAR(100)  NULL,
    customer_segment        VARCHAR(100)  NULL,
    customer_gender         VARCHAR(50)   NULL,
    customer_age            INT           NULL,
    customer_age_group      VARCHAR(50)   NULL,
    product_id              INT           NULL,
    product_name            VARCHAR(50)   NULL,
    sku                     VARCHAR(50)   NULL,
    brand                   VARCHAR(50)   NULL,
    category                VARCHAR(50)   NULL,
    sub_category            VARCHAR(50)   NULL,
    department              VARCHAR(50)   NULL,
    quantity_ordered        INT           NULL,
    unit_list_price         VARCHAR(50)   NULL,
    discount_pct            FLOAT         NULL,
    unit_selling_price      VARCHAR(50)   NULL,
    line_total_before_tax   VARCHAR(50)   NULL,
    tax_rate_pct            FLOAT         NULL,
    tax_amount              VARCHAR(50)   NULL,
    line_total_with_tax     VARCHAR(50)   NULL,
    store_id                INT           NULL,
    store_name              VARCHAR(50)   NULL,
    store_city              VARCHAR(50)   NULL,
    store_state             VARCHAR(50)   NULL,
    store_region            VARCHAR(50)   NULL,
    store_type              VARCHAR(50)   NULL,
    employee_id             INT           NULL,
    employee_name           VARCHAR(100)  NULL,
    employee_job_title      VARCHAR(100)  NULL,
    promo_id                INT           NULL,
    promo_name              VARCHAR(50)   NULL,
    sales_channel           VARCHAR(50)   NULL,
    payment_method          VARCHAR(50)   NULL,
    shipping_method         VARCHAR(50)   NULL,
    order_status            VARCHAR(50)   NULL,
    is_returned             VARCHAR(50)   NULL,
    cost_price              VARCHAR(50)   NULL,
    gross_profit            VARCHAR(50)   NULL,
    data_source             VARCHAR(50)   NULL,
    record_created_ts       DATETIME2     NULL,
    last_modified_ts        DATETIME2     NULL
);
GO

/*=============================================================
source : API | Table  : stores |schema : bronze
=============================================================*/
IF OBJECT_ID('bronze.stores', 'U') IS NOT NULL
BEGIN 
    PRINT '>> dropping table bronze.stores' ;
    DROP TABLE bronze.stores ;
END ;
GO 

PRINT '>> creating table bronze.stores....';

CREATE TABLE bronze.stores
(
    store_id                INT           NULL,
    store_name              VARCHAR(100)  NULL,
    store_type              VARCHAR(50)   NULL,
    address                 VARCHAR(50)   NULL,
    city                    VARCHAR(50)   NULL,
    state                   VARCHAR(50)   NULL,
    state_full              VARCHAR(50)   NULL,
    zip_code                INT           NULL,
    country                 VARCHAR(50)   NULL,
    region                  VARCHAR(50)   NULL,
    district                VARCHAR(50)   NULL,
    phone                   VARCHAR(50)   NULL,
    manager_name            VARCHAR(50)   NULL,
    opened_date             VARCHAR(50)   NULL,
    sq_footage              INT           NULL,
    num_employees           INT           NULL,
    annual_rent_usd         INT           NULL,
    is_active               VARCHAR(50)   NULL,
    has_parking             VARCHAR(50)   NULL,
    has_cafe                VARCHAR(50)   NULL
);
GO