SELECT
    transaction_id,

    promo_id,
    promo_name,

    order_status,
    is_returned,
    data_source
FROM {{ ref('stg_transactions') }} ;