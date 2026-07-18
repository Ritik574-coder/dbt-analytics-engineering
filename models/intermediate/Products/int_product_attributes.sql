SELECT
    CASE 
        WHEN TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
        ELSE TRY_CONVERT(INT, product_id)
    END as product_id,

    CASE 
        WHEN TRIM(sku) = '' OR sku IS NULL OR LEN(TRIM(sku)) != 13 THEN 'Unknown'
        ELSE TRIM(UPPER(sku))
    END as sku,

    CASE 
        WHEN TRIM(product_name) = '' OR product_name IS NULL THEN 'Unknown'
        ELSE TRIM(dbo.TitleCase(product_name))
    END as product_name,

    CASE 
        WHEN TRIM(brand) = '' OR brand IS NULL THEN 'Unknown'
        ELSE TRIM(dbo.TitleCase(brand))
    END as brand,

    CASE 
        WHEN category IS NULL OR TRIM(category) = '' THEN 'Unknown'
        ELSE TRIM(dbo.titleCase(category))
    END AS category,

    CASE 
        WHEN sub_category IS NULL OR TRIM(sub_category) = '' THEN 'Unknown'
        ELSE dbo.TitleCase(TRIM(sub_category))
    END AS sub_category,

    CASE 
        WHEN department IS NULL OR TRIM(department) = '' THEN 'Unknown'
        ELSE dbo.TitleCase(TRIM(department))
    END AS department,

    {{ standardize_date('launched_date') }} as launched_date,

    CASE 
        WHEN product_url IS NULL OR TRIM(product_url) = '' OR product_url NOT LIKE 'https://%' THEN 'Unknown'
        ELSE REPLACE(REPLACE(TRIM(LOWER(product_url)), CHAR(13), ''),CHAR(10), '')
    END as product_url
FROM {{ ref('stg_products') }} ;

