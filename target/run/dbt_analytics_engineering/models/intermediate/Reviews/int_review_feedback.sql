
  
    USE [RetailDB];
    USE [RetailDB];
    
    

    

    
    USE [RetailDB];
    EXEC('
        CREATE OR ALTER VIEW "bronze"."int_review_feedback__dbt_tmp__dbt_tmp_vw" AS SELECT
    review_id,
    
    helpful_votes,

    CASE 
        WHEN 
    LOWER(TRIM(review_channel))
 IN (''app'', ''mobile app'', ''mobile'')   
            THEN ''Mobile App''

        WHEN 
    LOWER(TRIM(review_channel))
 IN (''in store'', ''in-store'', ''store'') 
            THEN ''In Store''

        WHEN 
    LOWER(TRIM(review_channel))
 IN (''online'', ''web'')                 
            THEN ''Online''

        WHEN 
    LOWER(TRIM(review_channel))
 = ''phone''                            
            THEN ''Phone Call''

        WHEN 
    LOWER(TRIM(review_channel))
 = ''catalog''                          
            THEN ''Catalog''

        ELSE ''Unknown''
    END AS review_channel,

    CASE
        WHEN REPLACE(REPLACE(TRIM(dbo.TitleCase(review_title)), CHAR(13), ''''), CHAR(10), '''') = '''' 
            THEN ''Unknown''
            
        ELSE REPLACE(REPLACE(TRIM(dbo.TitleCase(review_title)), CHAR(13), ''''), CHAR(10), '''')
    END as review_title
FROM "RetailDB"."bronze"."stg_reviews" ;;
    ')

EXEC('
            SELECT * INTO "RetailDB"."bronze"."int_review_feedback__dbt_tmp" FROM "RetailDB"."bronze"."int_review_feedback__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS "bronze"."int_review_feedback__dbt_tmp__dbt_tmp_vw"')



    
    use [RetailDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'bronze_int_review_feedback__dbt_tmp_cci'
        AND object_id=object_id('bronze_int_review_feedback__dbt_tmp')
    )
    DROP index "bronze"."int_review_feedback__dbt_tmp".bronze_int_review_feedback__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX bronze_int_review_feedback__dbt_tmp_cci
    ON "bronze"."int_review_feedback__dbt_tmp"

   


  