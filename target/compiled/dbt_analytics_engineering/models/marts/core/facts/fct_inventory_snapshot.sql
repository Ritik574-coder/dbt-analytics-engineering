SELECT
    p.inventory_snapshot_sk,
    p.snapshot_date,
    p.product_id,
    v.store_id,
    p.sku,
    p.product_name,
    p.category,
    s.stock_on_hand,
    s.stock_reserved,
    s.stock_available,
    s.reorder_level,
    v.unit_cost,
    v.unit_price,
    v.inventory_value,
    v.warehouse_location,
    CASE
        WHEN s.stock_available IS NULL OR s.reorder_level IS NULL THEN 'Unknown'
        WHEN s.stock_available <= s.reorder_level THEN 'Yes'
        ELSE 'No'
    END AS is_reorder_needed
FROM "RetailDB"."bronze"."int_inventory_product" AS p
LEFT JOIN "RetailDB"."bronze"."int_inventory_stock" AS s
    ON p.inventory_snapshot_sk = s.inventory_snapshot_sk
LEFT JOIN "RetailDB"."bronze"."int_inventory_valuation" AS v
    ON p.inventory_snapshot_sk = v.inventory_snapshot_sk
WHERE p.inventory_snapshot_sk IS NOT NULL;