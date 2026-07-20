SELECT 
    inventory_snapshot_sk,

{{ standardize_date('snapshot_date') }} as snapshot_date,

    CASE 
        WHEN TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
        ELSE TRY_CONVERT(INT, product_id)
    END  as product_id,

    CASE 
        WHEN product_name IS NULL OR product_name = '' THEN 'Unknown'
        ELSE TRIM(product_name)
    END as product_name,

    CASE 
        WHEN sku IS NULL OR sku = '' THEN 'Unknown'
        ELSE TRIM(sku)
    END as sku,

    CASE 
        WHEN {{ trim_lower('category') }} = 'electronics' THEN 'Electronics'
        WHEN {{ trim_lower('category') }} = 'clothing'    THEN 'Clothing'
        WHEN {{ trim_lower('category') }} = 'kitchen'     THEN 'Kitchen'
        WHEN {{ trim_lower('category') }} = 'office'      THEN 'Office'
        WHEN {{ trim_lower('category') }} = 'sports'      THEN 'Sports'
        WHEN {{ trim_lower('category') }} = 'health'      THEN 'Health'
        WHEN {{ trim_lower('category') }} = 'beauty'      THEN 'Beauty'
        WHEN {{ trim_lower('category') }} = 'footwear'    THEN 'Footwear'
        WHEN {{ trim_lower('category') }} = 'toys'        THEN 'Toys'
        WHEN {{ trim_lower('category') }} = 'bags'        THEN 'Bags'
        ELSE 'Unknown'
    END AS category
FROM {{ ref('stg_inventory') }} ;