SELECT
    review_id,
    txn_id,

    customer_id,
    customer_name,

    product_id,
    product_name,

    CASE 
        WHEN review_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,review_date)
        WHEN review_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,review_date)
        WHEN review_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,review_date)
        WHEN review_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,review_date)
    
        WHEN review_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(review_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, review_date, 101)
        WHEN review_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(review_date, 2))         > 12 THEN TRY_CONVERT(DATE, review_date, 103)
        WHEN review_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(review_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, review_date, 110)
        WHEN review_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(review_date, 2))         > 12 THEN TRY_CONVERT(DATE, review_date, 105)
        ELSE TRY_CONVERT(DATE, review_date)
    END as review_date,

    CASE 
        WHEN TRIM(LOWER(verified_purchase)) IN ('1', 'y', 'yes', 'true', 'verified') THEN 'Verified'
        WHEN TRIM(LOWER(verified_purchase)) IN ('0', 'n', 'no', 'false')             THEN 'Not Verified'    
        ELSE 'Unknown'
    END AS verified_purchase
FROM {{ ref('stg_reviews') }} ;