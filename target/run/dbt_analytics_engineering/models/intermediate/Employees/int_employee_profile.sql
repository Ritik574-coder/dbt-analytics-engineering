
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."int_employee_profile__dbt_tmp__dbt_tmp_vw" AS SELECT 
    employee_id, 

    CASE 
        WHEN LEN(TRIM(full_name)) - LEN(REPLACE(TRIM(full_name), '' '','''')) = 1 THEN PARSENAME(REPLACE(TRIM(full_name), '' '', ''.''), 2)
    END as first_name,

    PARSENAME(REPLACE(TRIM(full_name),'' '',''.''),1) as last_name,

    


    CASE
        WHEN TRIM(hire_date) LIKE ''[A-Z][a-z][a-z][a-z]% __, ____''
            THEN TRY_CONVERT(DATE, TRIM(hire_date))

        WHEN TRIM(hire_date) LIKE ''[A-Z][a-z][a-z] __, ____''
            THEN TRY_CONVERT(DATE, TRIM(hire_date))

        WHEN TRIM(hire_date) LIKE ''__-__-____''
            AND TRY_CONVERT(INT, SUBSTRING(TRIM(hire_date), 4, 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(hire_date), 110)

        WHEN TRIM(hire_date) LIKE ''__-__-____''
            AND TRY_CONVERT(INT, LEFT(TRIM(hire_date), 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(hire_date), 105)

        WHEN TRIM(hire_date) LIKE ''____-__-__''
            THEN TRY_CONVERT(DATE, TRIM(hire_date))

        WHEN TRIM(hire_date) LIKE ''____/__/__''
            THEN TRY_CONVERT(DATE, TRIM(hire_date))

        WHEN TRIM(hire_date) LIKE ''__/__/____''
            AND TRY_CONVERT(INT, SUBSTRING(TRIM(hire_date), 4, 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(hire_date), 101)

        WHEN TRIM(hire_date) LIKE ''__/__/____''
            AND TRY_CONVERT(INT, LEFT(TRIM(hire_date), 2)) > 12
            THEN TRY_CONVERT(DATE, TRIM(hire_date), 103)

        ELSE TRY_CONVERT(DATE, TRIM(hire_date), 101)

    END

 as hire_date
FROM "RetailDB"."bronze"."stg_employees" ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."int_employee_profile__dbt_tmp" FROM "RetailDB"."bronze"."int_employee_profile__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."int_employee_profile__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_int_employee_profile__dbt_tmp_cci'
        AND object_id=object_id('bronze_int_employee_profile__dbt_tmp')
    )
    DROP index "bronze"."int_employee_profile__dbt_tmp".bronze_int_employee_profile__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_int_employee_profile__dbt_tmp_cci
    ON "bronze"."int_employee_profile__dbt_tmp"

   


  