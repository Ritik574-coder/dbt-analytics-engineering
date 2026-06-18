SELECT
    customer_id,
    title,
    first_name,
    last_name,
    gender,
    date_of_birth
FROM {{ ref('stg_customers') }} ;