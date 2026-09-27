
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."dim_customers__dbt_tmp__dbt_tmp_vw" AS SELECT 
    p.customer_id, 
    TRIM(CONCAT(p.title, '' '', p.first_name, '' '', p.last_name)) as customer_name,
    p.gender,
    p.date_of_birth,
    c.email,
    c.phone,
    l.address,
    l.zip_code,
    l.city,
    l.region,
    l.state,
    l.state_abbr,
    l.country,
    s.company,
    s.customer_segment,
    c.preferred_channel,
    s.is_active,
    s.loyalty_points,
    s.annual_income_usd,
    s.account_created_date
FROM "RetailDB"."bronze"."int_customer_profile" as p 

LEFT JOIN "RetailDB"."bronze"."int_customers_contact" as c 
    ON p.customer_id = c.customer_id 

LEFT JOIN "RetailDB"."bronze"."int_customer_location" as l
    ON p.customer_id = l.customer_id

LEFT JOIN "RetailDB"."bronze"."int_customer_segmentation" as s  
    ON s.customer_id = p.customer_id ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."dim_customers__dbt_tmp" FROM "RetailDB"."bronze"."dim_customers__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."dim_customers__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_dim_customers__dbt_tmp_cci'
        AND object_id=object_id('bronze_dim_customers__dbt_tmp')
    )
    DROP index "bronze"."dim_customers__dbt_tmp".bronze_dim_customers__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_dim_customers__dbt_tmp_cci
    ON "bronze"."dim_customers__dbt_tmp"

   


  