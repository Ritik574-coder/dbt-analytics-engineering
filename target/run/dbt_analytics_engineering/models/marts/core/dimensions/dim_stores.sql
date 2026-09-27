
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."dim_stores__dbt_tmp__dbt_tmp_vw" AS SELECT
    p.store_id,
    p.store_name,
    p.store_type,
    p.manager_name,
    p.opened_date,
    l.address,
    l.city,
    l.state,
    l.state_full,
    l.zip_code,
    l.country,
    l.region,
    l.district,
    l.phone,
    o.sq_footage,
    o.num_employees,
    o.annual_rent_usd,
    o.is_active,
    o.has_parking,
    o.has_cafe
FROM "RetailDB"."bronze"."int_store_profile" AS p
LEFT JOIN "RetailDB"."bronze"."int_store_location" AS l
    ON p.store_id = l.store_id
LEFT JOIN "RetailDB"."bronze"."int_store_operations" AS o
    ON p.store_id = o.store_id
WHERE p.store_id IS NOT NULL;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."dim_stores__dbt_tmp" FROM "RetailDB"."bronze"."dim_stores__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."dim_stores__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_dim_stores__dbt_tmp_cci'
        AND object_id=object_id('bronze_dim_stores__dbt_tmp')
    )
    DROP index "bronze"."dim_stores__dbt_tmp".bronze_dim_stores__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_dim_stores__dbt_tmp_cci
    ON "bronze"."dim_stores__dbt_tmp"

   


  