IF DB_ID('retail_analytics') IS NULL
BEGIN
    CREATE DATABASE retail_analytics;
END;
GO

USE retail_analytics;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'dbt_ci')
BEGIN
    EXEC('CREATE SCHEMA dbt_ci');
END;
GO
