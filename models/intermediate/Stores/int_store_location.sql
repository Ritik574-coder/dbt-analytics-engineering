SELECT
    store_id,
    address,
    city,
    state,
    state_full,
    zip_code,
    country,
    region,
    district,
    phone
FROM {{ ref('stg_stores') }} ;