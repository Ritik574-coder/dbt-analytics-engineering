SELECT
    store_id,
    store_name,
    store_type,
    opened_date,
    manager_name
FROM {{ ref('stg_stores') }} ;