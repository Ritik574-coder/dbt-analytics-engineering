SELECT 
    product_id,
    supplier_name,
    supplier_country,
    warranty_years,
    rating_avg,
    review_count
FROM {{ ref('stg_products') }} ;