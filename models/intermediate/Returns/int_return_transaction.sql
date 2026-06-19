SELECT
    return_id,
    original_txn_id,
    original_order_id,
    customer_id,
    customer_name,
    product_id,
    product_name,
    quantity_returned,
    return_date
FROM {{ ref('stg_returns') }} ;