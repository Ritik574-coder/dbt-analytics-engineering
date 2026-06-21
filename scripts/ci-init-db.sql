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

-- creating custom function taht help me to convert string into title case 
CREATE FUNCTION dbo.TitleCase (@text VARCHAR(255))
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @result VARCHAR(255) = ''
    DECLARE @word VARCHAR(255)

    ;WITH words AS (
        SELECT value
        FROM STRING_SPLIT(LOWER(@text), ' ')
    )
    SELECT @result = @result +
        UPPER(LEFT(value,1)) +
        SUBSTRING(value,2,LEN(value)) + ' '
    FROM words

    RETURN RTRIM(@result)
END;