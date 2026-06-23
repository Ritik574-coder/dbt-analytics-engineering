SELECT 
    inventory_snapshot_sk,

    CASE 
        WHEN snapshot_date LIKE '[A-Z][a-z][a-z][a-z] __, ____' THEN TRY_CONVERT(DATE ,snapshot_date)
        WHEN snapshot_date LIKE '[A-Z][a-z][a-z] __, ____'      THEN TRY_CONVERT(DATE ,snapshot_date)
        WHEN snapshot_date LIKE '____/__/__'                    THEN TRY_CONVERT(DATE ,snapshot_date)
        WHEN snapshot_date LIKE '____-__-__'                    THEN TRY_CONVERT(DATE ,snapshot_date)
    
        WHEN snapshot_date LIKE '__/__/____' AND SUBSTRING(snapshot_date, 4, 2) > 12 THEN TRY_CONVERT(DATE, snapshot_date, 101)
        WHEN snapshot_date LIKE '__/__/____' AND LEFT(snapshot_date, 2) > 12         THEN TRY_CONVERT(DATE, snapshot_date, 103)
        WHEN snapshot_date LIKE '__-__-____' AND SUBSTRING(snapshot_date, 4, 2) > 12 THEN TRY_CONVERT(DATE, snapshot_date, 110)
        WHEN snapshot_date LIKE '__-__-____' AND LEFT(snapshot_date, 2) > 12         THEN TRY_CONVERT(DATE, snapshot_date, 105)
        ELSE TRY_CONVERT(DATE, snapshot_date)
    END as snapshot_date,

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