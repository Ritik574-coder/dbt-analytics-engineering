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
        BULK INSERT bronze.customers
        FROM '/data/raw_customers.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            FIELDQUOTE = '"',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        ); 

        SET @end_time = GETDATE() ;

        PRINT '[INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND ,@start_time , @end_time) AS NVARCHAR) + ' second' ;
        PRINT '-------------------------------'

        SET @start_time = GETDATE() ;

        PRINT '>> [INFO] Truncating Table : bronze.employees | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        TRUNCATE TABLE bronze.employees ;

        PRINT '>> [INFO] Loading Table : bronze.employees | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        BULK INSERT bronze.employees
        FROM '/data/raw_employees.csv'
        WITH(
                FORMAT = 'CSV',
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                FIELDQUOTE = '"',
                ROWTERMINATOR = '0x0a',
                TABLOCK
        );

        SET @end_time = GETDATE() ;

        PRINT '>> [INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second' ;
        PRINT '--------------------------------' ;

        SET @start_time = GETDATE() ;

        PRINT '>> [INFO] Truncating Table : bronze.inventory_snapshots | ' + CONVERT(NVARCHAR ,GETDATE(), 120) ;
        TRUNCATE TABLE bronze.inventory_snapshots ;

        PRINT '>> [INFO] Loading Table : bronze.inventory_snapshots | ' + CONVERT(NVARCHAR, GETDATE(), 120);
        BULK INSERT bronze.inventory_snapshots
        FROM '/data/raw_inventory_snapshots.csv'
        WITH(
                FORMAT = 'CSV',
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                FIELDQUOTE = '"',
                ROWTERMINATOR = '0x0a',
                TABLOCK
        );

        SET @end_time = GETDATE() ;

        PRINT '>> [INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND ,@start_time ,@end_time) AS NVARCHAR) + ' second' ;
        PRINT '--------------------------------' ;

        SET @start_time  = GETDATE() ;

        PRINT '>> [INFO] Truncating Table : bronze.products | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        TRUNCATE table bronze.products ;

        PRINT '>> [INFO] Loading Table : bronze.products | ' + CAST(DATEDIFF(SECOND , @start_time, @end_time) AS NVARCHAR) + ' second' ;
        BULK INSERT bronze.products
        FROM '/data/raw_products.csv'
        WITH(
                FORMAT = 'CSV',
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                FIELDQUOTE = '"',
                ROWTERMINATOR = '0x0a',
                TABLOCK
        ) ;

        SET @end_time = GETDATE() ;

        PRINT '>> [INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND ,@start_time, @end_time) AS NVARCHAR) + ' second' ;
        PRINT '---------------------------------------' ;

        SET @start_time = GETDATE() ;

        PRINT '>> [INFO] Truncating Table : bronze.returns | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        TRUNCATE table bronze.returns ;

        PRINT '>> [INFO] Loading Table : bronze.returns | ' + CAST(DATEDIFF(SECOND , @start_time, @end_time) AS NVARCHAR) + ' second' ;
        BULK INSERT bronze.returns
        FROM '/data/raw_returns.csv'
        WITH(
                FORMAT = 'CSV',
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                FIELDQUOTE = '"',
                ROWTERMINATOR = '0x0a',
                TABLOCK
        ) ;

        SET @end_time = GETDATE() ;

        PRINT '>> [INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND ,@start_time, @end_time) AS NVARCHAR) + ' second' ;
        PRINT '---------------------------------------' ;

        SET @start_time = GETDATE() ;

        PRINT '>> [INFO] Truncating Table : bronze.reviews | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        TRUNCATE table bronze.reviews ;

        PRINT '>> [INFO] Loading Table : bronze.reviews | ' + CAST(DATEDIFF(SECOND , @start_time, @end_time) AS NVARCHAR) + ' second' ;
        BULK INSERT bronze.reviews
        FROM '/data/raw_reviews.csv'
        WITH(
                FORMAT = 'CSV',
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                FIELDQUOTE = '"',
                ROWTERMINATOR = '0x0a',
                TABLOCK
        ) ;

        SET @end_time = GETDATE() ;

        PRINT '>> [INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND ,@start_time, @end_time) AS NVARCHAR) + ' second' ;
        PRINT '---------------------------------------' ;

        SET @start_time = GETDATE() ;

        PRINT '>> [INFO] Truncating Table : bronze.sales_transactions | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        TRUNCATE table bronze.sales_transactions ;

        PRINT '>> [INFO] Loading Table : bronze.sales_transactions | ' + CAST(DATEDIFF(SECOND , @start_time, @end_time) AS NVARCHAR) + ' second' ;
        BULK INSERT bronze.sales_transactions
        FROM '/data/raw_sales_transactions.csv'
        WITH(
                FORMAT = 'CSV',
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                FIELDQUOTE = '"',
                ROWTERMINATOR = '0x0a',
                TABLOCK
        ) ;

        SET @end_time = GETDATE() ;

        PRINT '>> [INFO] Loading Duration : ' + CAST(DATEDIFF(SECOND ,@start_time, @end_time) AS NVARCHAR) + ' second' ;
        PRINT '---------------------------------------' ;

        SET @start_time = GETDATE() ;

        PRINT '>> [INFO] Truncating Table : bronze.stores | ' + CONVERT(NVARCHAR, GETDATE(), 120) ;
        TRUNCATE table bronze.stores ;

        PRINT '>> [INFO] Loading Table : bronze.stores | ' + CAST(DATEDIFF(SECOND , @start_time, @end_time) AS NVARCHAR) + ' second' ;
        BULK INSERT bronze.stores
        FROM '/data/raw_stores.csv'
        WITH(
                FORMAT = 'CSV',
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                FIELDQUOTE = '"',
                ROWTERMINATOR = '0x0a',
                TABLOCK 
        ) ;

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