SELECT 
    transaction_id,

    quantity_ordered,

    unit_list_price,
    discount_pct,
    unit_selling_price,

    line_total_before_tax,

    tax_rate_pct,
    tax_amount,

    line_total_with_tax
FROM {{ ref('stg_transactions') }} ;