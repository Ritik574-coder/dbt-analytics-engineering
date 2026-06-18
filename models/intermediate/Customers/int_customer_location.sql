SELECT 
    customer_id,
    address,
    city,
    state_abbr,
    state,
    zip_code,
    country,
    region
FROM {{ ref('stg_customers') }} ;