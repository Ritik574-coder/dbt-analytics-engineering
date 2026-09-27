
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."int_review_rating__dbt_tmp__dbt_tmp_vw" AS SELECT
    review_id,

    CASE
        WHEN TRY_CONVERT(INT, rating) BETWEEN 1 AND 5
        THEN TRY_CONVERT(INT, rating)
        ELSE NULL
    END AS rating,
        
    rating_text
FROM "RetailDB"."bronze"."stg_reviews" ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."int_review_rating__dbt_tmp" FROM "RetailDB"."bronze"."int_review_rating__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."int_review_rating__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_int_review_rating__dbt_tmp_cci'
        AND object_id=object_id('bronze_int_review_rating__dbt_tmp')
    )
    DROP index "bronze"."int_review_rating__dbt_tmp".bronze_int_review_rating__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_int_review_rating__dbt_tmp_cci
    ON "bronze"."int_review_rating__dbt_tmp"

   


  