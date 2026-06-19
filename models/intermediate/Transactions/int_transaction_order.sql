SELECT
    transaction_id,
    order_id,
    order_line_number,

    customer_id,
    product_id,
    store_id,
    employee_id,
    promo_id,

    order_date,
    record_created_ts,
    last_modified_ts
FROM {{ ref('stg_transactions') }} ;