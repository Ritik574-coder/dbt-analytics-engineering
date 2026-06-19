SELECT
    review_id,
    txn_id,
    customer_id,
    customer_name,
    product_id,
    product_name,
    review_date,
    verified_purchase
FROM {{ ref('stg_reviews') }} ;