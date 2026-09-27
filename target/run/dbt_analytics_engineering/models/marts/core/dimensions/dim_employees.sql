
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."dim_employees__dbt_tmp__dbt_tmp_vw" AS SELECT 
    p.employee_id,
    e.store_id,
    e.manager_id,
    CONCAT(p.first_name, '' '', p.last_name) as employee_name,
    e.job_title,
    e.department,
    e.performance_rating,
    e.store_name,      
    e.store_city,
    c.email,
    c.phone,
    e.annual_salary_usd,  
    e.commission_rate_pct,    
    e.years_employed,    
    e.is_active,
    p.hire_date 
FROM "RetailDB"."bronze"."int_employee_profile" as p 

LEFT JOIN "RetailDB"."bronze"."int_employee_contact" as c  
    ON p.employee_id = c.employee_id

LEFT JOIN "RetailDB"."bronze"."int_employee_employment" as e  
    ON p.employee_id = e.employee_id ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."dim_employees__dbt_tmp" FROM "RetailDB"."bronze"."dim_employees__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."dim_employees__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_dim_employees__dbt_tmp_cci'
        AND object_id=object_id('bronze_dim_employees__dbt_tmp')
    )
    DROP index "bronze"."dim_employees__dbt_tmp".bronze_dim_employees__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_dim_employees__dbt_tmp_cci
    ON "bronze"."dim_employees__dbt_tmp"

   


  