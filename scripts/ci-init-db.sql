IF DB_ID('RetailDB') IS NULL
BEGIN
    CREATE DATABASE RetailDB;
END;
GO

USE RetailDB;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'dbt_ci')
BEGIN
    EXEC('CREATE SCHEMA dbt_ci');
END;
GO