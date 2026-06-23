SELECT
    review_id,
    
    helpful_votes,

    CASE 
        WHEN TRIM(LOWER(review_channel)) IN ('app', 'mobile app', 'mobile')   THEN 'Mobile App'
        WHEN TRIM(LOWER(review_channel)) IN ('in store', 'in-store', 'store') THEN 'In Store'
        WHEN TRIM(LOWER(review_channel)) IN ('online', 'web')                 THEN 'Online'
        WHEN TRIM(LOWER(review_channel)) = 'phone'                            THEN 'Phone Call'
        WHEN TRIM(LOWER(review_channel)) = 'catalog'                          THEN 'Catalog'
        ELSE 'Unknown'
    END AS review_channel,

    CASE
        WHEN REPLACE(REPLACE(TRIM(dbo.TitleCase(review_title)), CHAR(13), ''), CHAR(10), '') = '' THEN 'Unknown'
        ELSE REPLACE(REPLACE(TRIM(dbo.TitleCase(review_title)), CHAR(13), ''), CHAR(10), '')
    END as review_title
FROM {{ ref('stg_reviews') }} ;