SELECT
    CASE 
          WHEN TRY_CONVERT(INT, return_id) < 1 OR TRY_CONVERT(INT, return_id) IS NULL THEN NULL 
          ELSE TRY_CONVERT(INT, return_id)
    END as return_id,

    CASE 
          WHEN original_txn_id IS NULL THEN NULL
          WHEN UPPER(TRIM(original_txn_id)) NOT LIKE 'TXN-%' THEN NULL
          WHEN LEN(UPPER(TRIM(original_txn_id))) < 10 THEN NULL
          ELSE UPPER(TRIM(original_txn_id))
    END as original_txn_id,

    CASE 
          WHEN original_order_id IS NULL OR TRY_CONVERT(INT, original_order_id) < 1 OR TRY_CONVERT(INT, original_order_id) IS NULL THEN NULL 
          ELSE TRY_CONVERT(INT, original_order_id)
    END as original_order_id,

    CASE 
          WHEN customer_id IS NULL OR TRY_CONVERT(INT, customer_id) IS NULL THEN NULL 
          ELSE TRY_CONVERT(INT, customer_id)
    END as customer_id,

    CASE 
          WHEN customer_name IS NULL OR TRIM(customer_name) = '' THEN 'Unknown'
          ELSE dbo.TitleCase(TRIM(customer_name))
    END as customer_name,

    CASE 
          WHEN product_id IS NULL OR TRY_CONVERT(INT, product_id) IS NULL THEN NULL 
          ELSE TRY_CONVERT(INT, product_id)
    END as product_id,

    CASE 
          WHEN product_name IS NULL OR TRIM(product_name) = '' THEN 'Unknown'
          ELSE dbo.TitleCase(TRIM(product_name))
    END as product_name,

    CASE 
          WHEN quantity_returned IS NULL OR TRY_CONVERT(INT, quantity_returned) IS NULL OR TRY_CONVERT(INT, quantity_returned) < 1 THEN NULL 
          ELSE TRY_CONVERT(INT, quantity_returned)
    END as quantity_returned,

{{ standardize_date('return_date') }} as return_date
FROM {{ ref('stg_returns') }} ;


