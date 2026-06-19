SELECT 
    product_id,
    sku,
    product_name,
    brand,
    category,
    sub_category,
    department,
    launched_date,
    product_url
FROM {{ ref('stg_products') }} ;