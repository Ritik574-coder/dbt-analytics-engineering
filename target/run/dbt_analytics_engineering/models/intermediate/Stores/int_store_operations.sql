
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."int_store_operations__dbt_tmp__dbt_tmp_vw" AS SELECT
    store_id,

    CASE 
        WHEN sq_footage IS NULL OR sq_footage < 0 
            THEN NULL
            
        ELSE TRY_CONVERT(INT, sq_footage)
    END as sq_footage,

    CASE 
        WHEN num_employees IS NULL OR num_employees < 0 
            THEN NULL

        ELSE TRY_CONVERT(INT, num_employees)
    END as num_employees,

    CASE 
        WHEN annual_rent_usd < 1 OR annual_rent_usd  IS NULL 
            THEN NULL 

        ELSE TRY_CONVERT(INT, annual_rent_usd)
    END as annual_rent_usd,

    CASE 
        WHEN 
    LOWER(TRIM(is_active))
 IN (''true'', ''yes'', ''y'', ''1'', ''active'')     
            THEN ''True''

        WHEN 
    LOWER(TRIM(is_active))
 IN (''false'', ''no'', ''n'', ''0'', ''not active'') 
            THEN ''False''

        ELSE ''Unknown''
    END as is_active,

    CASE 
        WHEN 
    LOWER(TRIM(has_parking))
 IN (''true'', ''yes'', ''y'', ''1'') 
            THEN ''True''

        WHEN 
    LOWER(TRIM(has_parking))
 IN (''false'', ''no'', ''n'', ''0'') 
            THEN ''False''

        ELSE ''Unknown''
    END as has_parking,

    CASE 
        WHEN REPLACE(REPLACE(
    LOWER(TRIM(has_cafe))
, CHAR(13), ''''),CHAR(10), '''') IN (''1'', ''yes'', ''y'',''true'') 
            THEN ''True''

        WHEN REPLACE(REPLACE(
    LOWER(TRIM(has_cafe))
, CHAR(13), ''''),CHAR(10), '''') IN (''0'', ''no'', ''n'',''false'') 
            THEN ''False''

        ELSE ''Unknown''
    END as has_cafe
FROM "RetailDB"."bronze"."stg_stores" ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."int_store_operations__dbt_tmp" FROM "RetailDB"."bronze"."int_store_operations__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."int_store_operations__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_int_store_operations__dbt_tmp_cci'
        AND object_id=object_id('bronze_int_store_operations__dbt_tmp')
    )
    DROP index "bronze"."int_store_operations__dbt_tmp".bronze_int_store_operations__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_int_store_operations__dbt_tmp_cci
    ON "bronze"."int_store_operations__dbt_tmp"

   


  