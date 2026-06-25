SELECT
    a.product_id,
    a.sku,
    a.product_name,
    a.brand,
    a.category,
    a.sub_category,
    a.department,
    a.launched_date,
    a.product_url,
    p.base_price_usd,
    p.cost_price_usd,
    p.gross_margin_pct,
    i.is_available,
    i.stock_quantity,
    i.reorder_level,
    s.supplier_name,
    s.supplier_country,
    s.weight_kg,
    s.warranty_years,
    s.rating_avg,
    s.review_count
FROM {{ ref('int_product_attributes') }} AS a
LEFT JOIN {{ ref('int_product_pricing') }} AS p
    ON a.product_id = p.product_id
LEFT JOIN {{ ref('int_product_inventory') }} AS i
    ON a.product_id = i.product_id
LEFT JOIN {{ ref('int_product_supplier') }} AS s
    ON a.product_id = s.product_id
WHERE a.product_id IS NOT NULL;
