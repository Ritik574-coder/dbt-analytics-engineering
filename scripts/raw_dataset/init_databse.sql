/*
========================================================================================
Create Database and Schemas
========================================================================================
Script Purpose:
    This script creates a new database named 'RetailDB'.

    If the database already exists, it will be safely dropped and recreated.
    The script also creates three schemas used in the Medallion Architecture:
        - Bronze  (Raw data layer)
        - Silver  (Cleaned and transformed layer)
        - Gold    (Business-ready layer)

WARNING:
    Running this script will permanently DROP the 'RetailDB' database.
    All existing data will be deleted.

    Ensure that proper backups are available before executing this script.

Author      : Ritik__
Created On  : 2026-02-26
Version     : 1.0
Project     : Data Warehousing
Project Name: RetailDB

Environment:
    Development / Testing

Dependencies:
    - Microsoft SQL Server (RDBMS)
    - Appropriate database creation permissions

    Ensure you have the required privileges before executing this script.
========================================================================================
*/

-- Safety check: Ensure script is executed in the master database
IF DB_NAME() NOT IN ('master') 
BEGIN 
    THROW 50000, 'Execute this script in master datbase only.',1 ;
END;
GO

-- Switch to master database
USE master ;
GO

-- Drop and recreate the BusinessDW database
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'RetailDB') 
BEGIN
    PRINT 'Dropping databse RetailDB' ;
    ALTER DATABASE RetailDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE ;
    DROP DATABASE RetailDB ;
END ;
GO

-- Creating database RetailDB 
CREATE DATABASE RetailDB ;
GO

-- Safety check: Ensure script is executed in the RetailDB database
IF DB_NAME() NOT IN ('RetailDB')
BEGIN
    THROW 50000, 'Execute this scrip in RetailDB Database only .',1 ;
END;
GO

-- Switch to RetailDB database
USE RetailDB ;
GO

--===========================================================================
-- Create Bronze schema (Raw ingestion layer)
IF NOT EXISTS(SELECT 1 FROM sys.schemas WHERE name = 'bronze')
BEGIN 
    PRINT 'creating bronze schema' ;
    EXEC(N'CREATE SCHEMA bronze AUTHORIZATION dbo');
END;
GO

-- Create Silver schema (Cleaned and standardized layer)
IF NOT EXISTS(SELECT 1 FROM sys.schemas WHERE name = 'silver') 
BEGIN
    PRINT 'creating silver schema' ;
    EXEC(N'CREATE SCHEMA silver AUTHORIZATION dbo') ;
END;
GO

-- Create Gold schema (Business and analytics layer)
IF NOT EXISTS(SELECT 1 FROM sys.schemas WHERE name = 'gold')
BEGIN
    PRINT 'creating gold schema' ;
    EXEC(N'CREATE SCHEMA gold AUTHORIZATION dbo') ;
END
GO
--===========================================================================
