/*=============================================================================================
--==== BRONZE LAYER DATA LOADING PROCEDURE (BULK INGESTION)
===============================================================================================

Purpose :
    This stored procedure loads raw data into the Bronze layer tables using BULK INSERT.
    It follows a truncate-and-load strategy (full refresh) for each execution.

    The procedure performs the following steps:
        - Truncates existing data in target Bronze tables
        - Loads fresh data from CSV files located in external storage
        - Logs execution progress and duration for each table
        - Wraps execution inside a transaction for consistency

    The following tables are processed:
        - bronze.customers
        - bronze.employees
        - bronze.inventory_snapshots
        - bronze.products
        - bronze.returns
        - bronze.reviews
        - bronze.sales_transactions
        - bronze.stores

-----------------------------------------------------------------------------------------------

WARNING :
    - This procedure uses TRUNCATE TABLE → all existing data will be permanently deleted
    - Ensure that source files are available and valid before execution
    - Make sure backups are available if data recovery is required
    - Improper file paths or missing files will cause the transaction to fail

-----------------------------------------------------------------------------------------------

Execution Logic :
    - Uses explicit TRANSACTION control
    - Implements TRY...CATCH for error handling
    - Rolls back entire batch if any step fails
    - Tracks execution time for each table and full batch

-----------------------------------------------------------------------------------------------

Source Files :
    Expected file location:
        /data/Dataset/

    File Mapping:
        raw_customers.csv
        raw_employees.csv
        raw_inventory_snapshots.csv
        raw_products.csv
        raw_returns.csv
        raw_reviews.csv
        raw_sales_transactions.csv
        raw_stores.csv

-----------------------------------------------------------------------------------------------

Author      : Ritik__
Created on  : 2026-05-01
Version     : 1.0

Project     : DataWarehouse | DBT_SQLServer
Layer       : Bronze
Schema      : bronze

Environment :
    Development / Testing

Dependencies :
    - SQL Server (BULK INSERT enabled)
    - Access to file system path (/data/Dataset/)
    - Proper file permissions for SQL Server service account

=============================================================================================*/

CREATE OR ALTER PROCEDURE bronze.load_bronze 
AS 
BEGIN
    SET NOCOUNT ON ;
    SET XACT_ABORT ON ; 

    DECLARE 
        @batch_start_time DATETIME,
        @batch_end_time   DATETIME,
        @start_time       DATETIME,
        @end_time         DATETIME ;

    BEGIN TRY 

        SET @batch_start_time = GETDATE() ;

        PRINT '====================================================================';
        PRINT '>> [INFO] Loading Bronze Layer | '+ CONVERT(NVARCHAR, GETDATE(), 120);
        PRINT '====================================================================';

        BEGIN TRANSACTION ;

        SET @start_time = GETDATE() ;

        PRINT '>> [INFO] Truncating table : bronze.customers | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        TRUNCATE TABLE bronze.customers ;

        PRINT '>> [INFO] Loading table : bronze.customers | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        INSERT INTO [RetailDB].[bronze].[customers]
        (
             [customer_id]
            ,[title]
            ,[first_name]
            ,[last_name]
            ,[full_name]
            ,[gender]
            ,[date_of_birth]
            ,[age]
            ,[email]
            ,[phone]
            ,[address]
            ,[city]
            ,[state]
            ,[state_abbr]
            ,[state_full]
            ,[zip_code]
            ,[country]
            ,[region]
            ,[customer_segment]
            ,[loyalty_points]
            ,[is_active]
            ,[account_created_date]
            ,[preferred_channel]
            ,[annual_income_usd]
            ,[company]
        )
        SELECT
             [customer_id]
            ,[title]
            ,[first_name]
            ,[last_name]
            ,[full_name]
            ,[gender]
            ,[date_of_birth]
            ,[age]
            ,[email]
            ,[phone]
            ,[address]
            ,[city]
            ,[state]
            ,[state_abbr]
            ,[state_full]
            ,[zip_code]
            ,[country]
            ,[region]
            ,[customer_segment]
            ,[loyalty_points]
            ,[is_active]
            ,[account_created_date]
            ,[preferred_channel]
            ,[annual_income_usd]
            ,[company]
        FROM [TestDB].[bronze].[customers] ;

        SET @end_time = GETDATE() ;

        PRINT '[INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND ,@start_time , @end_time) AS NVARCHAR) + ' second' ;
        PRINT '-------------------------------'

        SET @start_time = GETDATE() ;

        PRINT '>> [INFO] Truncating Table : bronze.employees | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        TRUNCATE TABLE bronze.employees ;

        PRINT '>> [INFO] Loading Table : bronze.employees | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        INSERT INTO [RetailDB].[bronze].[employees]
        (
             [employee_id]
            ,[first_name]
            ,[last_name]
            ,[full_name]
            ,[email]
            ,[phone]
            ,[job_title]
            ,[department]
            ,[store_id]
            ,[store_name]
            ,[store_city]
            ,[hire_date]
            ,[years_employed]
            ,[annual_salary_usd]
            ,[commission_rate_pct]
            ,[is_active]
            ,[performance_rating]
            ,[manager_id]
        )
        SELECT
            [employee_id]
            ,[first_name]
            ,[last_name]
            ,[full_name]
            ,[email]
            ,[phone]
            ,[job_title]
            ,[department]
            ,[store_id]
            ,[store_name]
            ,[store_city]
            ,[hire_date]
            ,[years_employed]
            ,[annual_salary_usd]
            ,[commission_rate_pct]
            ,[is_active]
            ,[performance_rating]
            ,[manager_id]
        FROM [TestDB].[bronze].[employees] ;

        SET @end_time = GETDATE() ;

        PRINT '>> [INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second' ;
        PRINT '--------------------------------' ;

        SET @start_time = GETDATE() ;

        PRINT '>> [INFO] Truncating Table : bronze.inventory_snapshots | ' + CONVERT(NVARCHAR ,GETDATE(), 120) ;
        TRUNCATE TABLE bronze.inventory_snapshots ;

        PRINT '>> [INFO] Loading Table : bronze.inventory_snapshots | ' + CONVERT(NVARCHAR, GETDATE(), 120);
        INSERT INTO [RetailDB].[bronze].[inventory_snapshots]
        (
             [snapshot_date]
            ,[product_id]
            ,[product_name]
            ,[sku]
            ,[category]
            ,[stock_on_hand]
            ,[stock_reserved]
            ,[stock_available]
            ,[reorder_level]
            ,[unit_cost]
            ,[unit_price]
            ,[inventory_value]
            ,[warehouse_location]
            ,[store_id]    
        )
        SELECT  
             [snapshot_date]
            ,[product_id]
            ,[product_name]
            ,[sku]
            ,[category]
            ,[stock_on_hand]
            ,[stock_reserved]
            ,[stock_available]
            ,[reorder_level]
            ,[unit_cost]
            ,[unit_price]
            ,[inventory_value]
            ,[warehouse_location]
            ,[store_id]
        FROM [TestDB].[bronze].[inventory_snapshots] ;

        SET @end_time = GETDATE() ;

        PRINT '>> [INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND ,@start_time ,@end_time) AS NVARCHAR) + ' second' ;
        PRINT '--------------------------------' ;

        SET @start_time  = GETDATE() ;

        PRINT '>> [INFO] Truncating Table : bronze.products | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        TRUNCATE table bronze.products ;

        PRINT '>> [INFO] Loading Table : bronze.products | ' + CAST(DATEDIFF(SECOND , @start_time, @end_time) AS NVARCHAR) + ' second' ;
        INSERT INTO [RetailDB].[bronze].[products]
        (
             [product_id]
            ,[sku]
            ,[product_name]
            ,[brand]
            ,[category]
            ,[sub_category]
            ,[department]
            ,[base_price_usd]
            ,[cost_price_usd]
            ,[gross_margin_pct]
            ,[weight_kg]
            ,[is_available]
            ,[stock_quantity]
            ,[reorder_level]
            ,[supplier_name]
            ,[supplier_country]
            ,[warranty_years]
            ,[rating_avg]
            ,[review_count]
            ,[launched_date]
            ,[product_url]    
        )
        SELECT 
             [product_id]
            ,[sku]
            ,[product_name]
            ,[brand]
            ,[category]
            ,[sub_category]
            ,[department]
            ,[base_price_usd]
            ,[cost_price_usd]
            ,[gross_margin_pct]
            ,[weight_kg]
            ,[is_available]
            ,[stock_quantity]
            ,[reorder_level]
            ,[supplier_name]
            ,[supplier_country]
            ,[warranty_years]
            ,[rating_avg]
            ,[review_count]
            ,[launched_date]
            ,[product_url]
        FROM [TestDB].[bronze].[products] ;

        SET @end_time = GETDATE() ;

        PRINT '>> [INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND ,@start_time, @end_time) AS NVARCHAR) + ' second' ;
        PRINT '---------------------------------------' ;

        SET @start_time = GETDATE() ;

        PRINT '>> [INFO] Truncating Table : bronze.returns | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        TRUNCATE table bronze.returns ;

        PRINT '>> [INFO] Loading Table : bronze.returns | ' + CAST(DATEDIFF(SECOND , @start_time, @end_time) AS NVARCHAR) + ' second' ;
        INSERT INTO [RetailDB].[bronze].[returns]
        (
             [return_id]
            ,[original_txn_id]
            ,[original_order_id]
            ,[customer_id]
            ,[customer_name]
            ,[product_id]
            ,[product_name]
            ,[quantity_returned]
            ,[return_date]
            ,[return_reason]
            ,[refund_amount]
            ,[refund_method]
            ,[return_channel]
            ,[restocked]
            ,[return_status]
            ,[handled_by_emp_id]
            ,[notes] 
        )
        SELECT 
             [return_id]
            ,[original_txn_id]
            ,[original_order_id]
            ,[customer_id]
            ,[customer_name]
            ,[product_id]
            ,[product_name]
            ,[quantity_returned]
            ,[return_date]
            ,[return_reason]
            ,[refund_amount]
            ,[refund_method]
            ,[return_channel]
            ,[restocked]
            ,[return_status]
            ,[handled_by_emp_id]
            ,[notes]
        FROM [TestDB].[bronze].[returns] ;

        SET @end_time = GETDATE() ;

        PRINT '>> [INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND ,@start_time, @end_time) AS NVARCHAR) + ' second' ;
        PRINT '---------------------------------------' ;

        SET @start_time = GETDATE() ;

        PRINT '>> [INFO] Truncating Table : bronze.reviews | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        TRUNCATE table bronze.reviews ;

        PRINT '>> [INFO] Loading Table : bronze.reviews | ' + CAST(DATEDIFF(SECOND , @start_time, @end_time) AS NVARCHAR) + ' second' ;
        INSERT INTO [RetailDB].[bronze].[reviews]
        (
             [review_id]
            ,[txn_id]
            ,[customer_id]
            ,[customer_name]
            ,[product_id]
            ,[product_name]
            ,[rating]
            ,[rating_text]
            ,[review_date]
            ,[verified_purchase]
            ,[helpful_votes]
            ,[review_channel]
            ,[review_title]   
        )
        SELECT
             [review_id]
            ,[txn_id]
            ,[customer_id]
            ,[customer_name]
            ,[product_id]
            ,[product_name]
            ,[rating]
            ,[rating_text]
            ,[review_date]
            ,[verified_purchase]
            ,[helpful_votes]
            ,[review_channel]
            ,[review_title]
        FROM [TestDB].[bronze].[reviews] ;

        SET @end_time = GETDATE() ;

        PRINT '>> [INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND ,@start_time, @end_time) AS NVARCHAR) + ' second' ;
        PRINT '---------------------------------------' ;

        SET @start_time = GETDATE() ;

        PRINT '>> [INFO] Truncating Table : bronze.sales_transactions | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        TRUNCATE table bronze.sales_transactions ;

        PRINT '>> [INFO] Loading Table : bronze.sales_transactions | ' + CAST(DATEDIFF(SECOND , @start_time, @end_time) AS NVARCHAR) + ' second' ;
        INSERT INTO [RetailDB].[bronze].[sales_transactions]
        (
            [transaction_id]
            ,[order_id]
            ,[order_line_number]
            ,[order_date]
            ,[order_year]
            ,[order_month]
            ,[order_month_name]
            ,[order_quarter]
            ,[order_day_of_week]
            ,[ship_date]
            ,[delivery_date]
            ,[customer_id]
            ,[customer_full_name]
            ,[customer_first_name]
            ,[customer_last_name]
            ,[customer_email]
            ,[customer_phone]
            ,[customer_city]
            ,[customer_state]
            ,[customer_zip]
            ,[customer_region]
            ,[customer_segment]
            ,[customer_gender]
            ,[customer_age]
            ,[customer_age_group]
            ,[product_id]
            ,[product_name]
            ,[sku]
            ,[brand]
            ,[category]
            ,[sub_category]
            ,[department]
            ,[quantity_ordered]
            ,[unit_list_price]
            ,[discount_pct]
            ,[unit_selling_price]
            ,[line_total_before_tax]
            ,[tax_rate_pct]
            ,[tax_amount]
            ,[line_total_with_tax]
            ,[store_id]
            ,[store_name]
            ,[store_city]
            ,[store_state]
            ,[store_region]
            ,[store_type]
            ,[employee_id]
            ,[employee_name]
            ,[employee_job_title]
            ,[promo_id]
            ,[promo_name]
            ,[sales_channel]
            ,[payment_method]
            ,[shipping_method]
            ,[order_status]
            ,[is_returned]
            ,[cost_price]
            ,[gross_profit]
            ,[data_source]
            ,[record_created_ts]
            ,[last_modified_ts]    
        )
        SELECT
            [transaction_id]
            ,[order_id]
            ,[order_line_number]
            ,[order_date]
            ,[order_year]
            ,[order_month]
            ,[order_month_name]
            ,[order_quarter]
            ,[order_day_of_week]
            ,[ship_date]
            ,[delivery_date]
            ,[customer_id]
            ,[customer_full_name]
            ,[customer_first_name]
            ,[customer_last_name]
            ,[customer_email]
            ,[customer_phone]
            ,[customer_city]
            ,[customer_state]
            ,[customer_zip]
            ,[customer_region]
            ,[customer_segment]
            ,[customer_gender]
            ,[customer_age]
            ,[customer_age_group]
            ,[product_id]
            ,[product_name]
            ,[sku]
            ,[brand]
            ,[category]
            ,[sub_category]
            ,[department]
            ,[quantity_ordered]
            ,[unit_list_price]
            ,[discount_pct]
            ,[unit_selling_price]
            ,[line_total_before_tax]
            ,[tax_rate_pct]
            ,[tax_amount]
            ,[line_total_with_tax]
            ,[store_id]
            ,[store_name]
            ,[store_city]
            ,[store_state]
            ,[store_region]
            ,[store_type]
            ,[employee_id]
            ,[employee_name]
            ,[employee_job_title]
            ,[promo_id]
            ,[promo_name]
            ,[sales_channel]
            ,[payment_method]
            ,[shipping_method]
            ,[order_status]
            ,[is_returned]
            ,[cost_price]
            ,[gross_profit]
            ,[data_source]
            ,[record_created_ts]
            ,[last_modified_ts]
        FROM [TestDB].[bronze].[sales_transactions] ;

        SET @end_time = GETDATE() ;

        PRINT '>> [INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND ,@start_time, @end_time) AS NVARCHAR) + ' second' ;
        PRINT '---------------------------------------' ;

        SET @start_time = GETDATE() ;

        PRINT '>> [INFO] Truncating Table : bronze.stores | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        TRUNCATE table bronze.stores ;

        PRINT '>> [INFO] Loading Table : bronze.stores | ' + CAST(DATEDIFF(SECOND , @start_time, @end_time) AS NVARCHAR) + ' second' ;
        INSERT INTO [RetailDB].[bronze].[stores]
        (
             [store_id]
            ,[store_name]
            ,[store_type]
            ,[address]
            ,[city]
            ,[state]
            ,[state_full]
            ,[zip_code]
            ,[country]
            ,[region]
            ,[district]
            ,[phone]
            ,[manager_name]
            ,[opened_date]
            ,[sq_footage]
            ,[num_employees]
            ,[annual_rent_usd]
            ,[is_active]
            ,[has_parking]
            ,[has_cafe]
        )
        SELECT 
             [store_id]
            ,[store_name]
            ,[store_type]
            ,[address]
            ,[city]
            ,[state]
            ,[state_full]
            ,[zip_code]
            ,[country]
            ,[region]
            ,[district]
            ,[phone]
            ,[manager_name]
            ,[opened_date]
            ,[sq_footage]
            ,[num_employees]
            ,[annual_rent_usd]
            ,[is_active]
            ,[has_parking]
            ,[has_cafe]
        FROM [TestDB].[bronze].[stores] ;

        SET @end_time = GETDATE() ;

        COMMIT ;

        PRINT '>> [INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND ,@start_time, @end_time) AS NVARCHAR) + ' second' ;
        PRINT '---------------------------------------' ;

        SET @batch_end_time = GETDATE() ;

        PRINT '====================================================================';
        PRINT 'Loading Bronze Layer Complited' ;
        PRINT 'Total Duration: ' + CAST(DATEDIFF(SECOND ,@batch_start_time, @batch_end_time)AS NVARCHAR) + ' second';
        PRINT '====================================================================';
    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK ;

        PRINT '===================================================';
        PRINT 'Error message : ' + ERROR_MESSAGE() ;
        PRINT 'Error number  : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error state   : ' + CAST(ERROR_STATE() AS NVARCHAR) ;
        PRINT 'Error Line    : ' + CAST(ERROR_LINE() AS VARCHAR)   ;
        PRINT '===================================================';
    
    END CATCH 
END ;