
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."fct_reviews__dbt_tmp__dbt_tmp_vw" AS SELECT
    t.review_id,
    t.txn_id,
    t.customer_id,
    t.product_id,
    t.review_date,
    t.verified_purchase,
    r.rating,
    r.rating_text,
    f.helpful_votes,
    f.review_channel,
    f.review_title
FROM "RetailDB"."bronze"."int_review_transaction" AS t
LEFT JOIN "RetailDB"."bronze"."int_review_rating" AS r
    ON t.review_id = r.review_id
LEFT JOIN "RetailDB"."bronze"."int_review_feedback" AS f
    ON t.review_id = f.review_id
WHERE t.review_id IS NOT NULL;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."fct_reviews__dbt_tmp" FROM "RetailDB"."bronze"."fct_reviews__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."fct_reviews__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_fct_reviews__dbt_tmp_cci'
        AND object_id=object_id('bronze_fct_reviews__dbt_tmp')
    )
    DROP index "bronze"."fct_reviews__dbt_tmp".bronze_fct_reviews__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_fct_reviews__dbt_tmp_cci
    ON "bronze"."fct_reviews__dbt_tmp"

   


  