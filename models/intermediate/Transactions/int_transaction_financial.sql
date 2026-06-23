WITH int_transaction_financial AS 
(
SELECT 
    transaction_id,

    CASE 
        WHEN quantity_ordered < 1 THEN NULL 
        WHEN quantity_ordered > 30 THEN NULL
        ELSE quantity_ordered
    END as quantity_ordered ,

    CASE 
        WHEN unit_list_price IS NULL THEN NULL 
        ELSE TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(unit_list_price, '$', ''), ',', '')) 
    END as unit_list_price,

    CASE 
        WHEN discount_pct IS NULL OR discount_pct < 0 OR discount_pct > 100 THEN NULL 
        ELSE ROUND(discount_pct, 0)
    END as discount_pct,

    CASE 
        WHEN line_total_before_tax IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_before_tax, '$', ''), ',', '')) < 0 THEN NULL 
        ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_before_tax, '$', ''), ',', ''))
    END as line_total_before_tax,

    CASE 
        WHEN tax_rate_pct IS NULL OR TRY_CONVERT(INT, ROUND(tax_rate_pct, 0)) < 0 OR TRY_CONVERT(INT, ROUND(tax_rate_pct, 0)) > 100 THEN NULL 
        ELSE TRY_CONVERT(INT, ROUND(tax_rate_pct, 0))
    END as tax_rate_pct,

    CASE 
        WHEN tax_amount IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(tax_amount, '$', ''), ',', '')) < 0 THEN NULL 
        ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(tax_amount, '$', ''), ',', ''))
    END as tax_amount,

    CASE 
        WHEN line_total_with_tax IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_with_tax, '$', ''), ',', '')) < 0 THEN NULL 
        ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_with_tax, '$', ''), ',', ''))
    END as line_total_with_tax
FROM {{ ref('stg_transactions') }} 
)
SELECT
    transaction_id,
    quantity_ordered,
    unit_list_price,
    discount_pct,
    ROUND(unit_list_price * (1 - discount_pct/100), 2) as unit_selling_price,
    ROUND(quantity_ordered * ROUND(unit_list_price * (1 - discount_pct/100.0), 2),2) AS line_total_before_tax,
    tax_rate_pct,
    tax_amount,
    ROUND(quantity_ordered * ROUND(unit_list_price * (1 - discount_pct/100.0), 2),2) + tax_amount AS line_total_with_tax
FROM int_transaction_financial ;
