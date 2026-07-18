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
        WHEN TRIM(LOWER(category)) = 'electronics' THEN 'Electronics'
        WHEN TRIM(LOWER(category)) = 'clothing'    THEN 'Clothing'
        WHEN TRIM(LOWER(category)) = 'kitchen'     THEN 'Kitchen'
        WHEN TRIM(LOWER(category)) = 'office'      THEN 'Office'
        WHEN TRIM(LOWER(category)) = 'sports'      THEN 'Sports'
        WHEN TRIM(LOWER(category)) = 'health'      THEN 'Health'
        WHEN TRIM(LOWER(category)) = 'beauty'      THEN 'Beauty'
        WHEN TRIM(LOWER(category)) = 'footwear'    THEN 'Footwear'
        WHEN TRIM(LOWER(category)) = 'toys'        THEN 'Toys'
        WHEN TRIM(LOWER(category)) = 'bags'        THEN 'Bags'
        ELSE 'Unknown'
    END AS category
FROM {{ ref('stg_inventory') }} ;