SELECT 
    transaction_id,

    ship_date,
    delivery_date,

    shipping_method,
    sales_channel,
    payment_method
FROM {{ ref('stg_transactions') }} ;