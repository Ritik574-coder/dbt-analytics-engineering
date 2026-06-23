SELECT
    transaction_id,
    order_id,
    customer_id,
    product_id,
    store_id,
    employee_id,
    CASE 
        WHEN order_line_number < 1 THEN NULL 
        WHEN order_line_number > 20 THEN NULL
        ELSE order_line_number
    END as order_line_number
FROM {{ ref('stg_transactions') }} ;