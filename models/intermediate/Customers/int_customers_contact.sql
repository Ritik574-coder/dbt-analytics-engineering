SELECT
    customer_id,
    email,
    phone,
    preferred_channel
FROM {{ ref('stg_customers') }} ;