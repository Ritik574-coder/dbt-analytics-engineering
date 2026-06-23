SELECT 
    product_id,

    CASE 
        WHEN supplier_name IS NULL OR TRIM(supplier_name) = '' THEN 'Unknown'
        ELSE TRIM(dbo.TitleCase(supplier_name))
    END as supplier_name,

    CASE 
        WHEN supplier_country IS NULL OR TRIM(supplier_country) = '' THEN 'Unknown'
        WHEN supplier_country = 'USA' THEN 'United States'
        ELSE TRIM(dbo.TitleCase(supplier_country))
    END as supplier_country,
        
    CASE 
        WHEN TRY_CONVERT(DECIMAL(5,2), weight_kg) IS NULL OR TRY_CONVERT(DECIMAL(5,2), weight_kg) < 0 THEN NULL 
        ELSE TRY_CONVERT(DECIMAL(5,2), weight_kg)
    END as weight_kg,

    CASE 
        WHEN TRY_CONVERT(INT, warranty_years) IS NULL OR TRY_CONVERT(INT, warranty_years) < 0  OR TRY_CONVERT(INT, warranty_years) > 20 THEN NULL 
        ELSE TRY_CONVERT(INT, warranty_years)
    END as warranty_years,

    CASE 
        WHEN TRY_CONVERT(DECIMAL(3,1), rating_avg) IS NULL OR TRY_CONVERT(DECIMAL(3,1), rating_avg) < 0 OR TRY_CONVERT(DECIMAL(3,1), rating_avg) > 5 THEN NULL 
        ELSE TRY_CONVERT(DECIMAL(3,1), rating_avg)
    END as rating_avg,

    CASE 
        WHEN TRY_CONVERT(INT, review_count) IS NULL OR TRY_CONVERT(INT, review_count) < 0 THEN NULL 
        ELSE TRY_CONVERT(INT, review_count)
    END as review_count
FROM {{ ref('stg_products') }} ;