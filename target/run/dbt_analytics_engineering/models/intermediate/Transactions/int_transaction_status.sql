
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."int_transaction_status__dbt_tmp__dbt_tmp_vw" AS SELECT
    transaction_id,

    promo_id,

    CASE TRIM(LOWER(promo_name))
        WHEN ''winter clearance'' THEN ''Winter Clearance''
        WHEN ''bundle deal''      THEN ''Bundle Deal''
        WHEN ''no promo''         THEN ''No Promo''
        WHEN ''flash sale''       THEN ''Flash Sale''
        WHEN ''black friday''     THEN ''Black Friday''
        WHEN ''holiday special''  THEN ''Holiday Special''
        WHEN ''weekend deal''     THEN ''Weekend Deal''
        WHEN ''loyalty reward''   THEN ''Loyalty Reward''
        WHEN ''cyber monday''     THEN ''Cyber Monday''
        ELSE TRIM(promo_name)
    END AS promo_name,

    CASE TRIM(LOWER(order_status))
        WHEN ''pending''    THEN ''Pending''
        WHEN ''processing'' THEN ''Processing''
        WHEN ''shipped''    THEN ''Shipped''
        WHEN ''delivered''  THEN ''Delivered''
        WHEN ''returned''   THEN ''Returned''
        WHEN ''cancelled''  THEN ''Cancelled''
        ELSE TRIM(order_status)
    END AS order_status,

    CASE 
        WHEN TRIM(LOWER(is_returned)) IN (''yes'', ''y'', ''true'', ''1'') 
            THEN ''True''

        WHEN TRIM(LOWER(is_returned)) IN (''no'', ''n'', ''false'', ''0'') 
            THEN ''False''
            
        ELSE ''Unknown''
    END AS is_returned,

    CASE TRIM(LOWER(data_source))
        WHEN ''crm''    THEN ''CRM''
        WHEN ''web''    THEN ''Web''
        WHEN ''pos''    THEN ''POS''
        WHEN ''manual'' THEN ''Manual''
        WHEN ''erp''    THEN ''ERP''
        ELSE ''Unknown''
    END AS data_source

FROM "RetailDB"."bronze"."stg_transactions" ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."int_transaction_status__dbt_tmp" FROM "RetailDB"."bronze"."int_transaction_status__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."int_transaction_status__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_int_transaction_status__dbt_tmp_cci'
        AND object_id=object_id('bronze_int_transaction_status__dbt_tmp')
    )
    DROP index "bronze"."int_transaction_status__dbt_tmp".bronze_int_transaction_status__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_int_transaction_status__dbt_tmp_cci
    ON "bronze"."int_transaction_status__dbt_tmp"

   


  