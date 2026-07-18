SELECT
    review_id,
    txn_id,

    customer_id,
    customer_name,

    product_id,
    product_name,

    {{ standardize_date('review_date') }} as review_date,

    CASE 
        WHEN TRIM(LOWER(verified_purchase)) IN ('1', 'y', 'yes', 'true', 'verified') THEN 'Verified'
        WHEN TRIM(LOWER(verified_purchase)) IN ('0', 'n', 'no', 'false')             THEN 'Not Verified'    
        ELSE 'Unknown'
    END AS verified_purchase
FROM {{ ref('stg_reviews') }} ;