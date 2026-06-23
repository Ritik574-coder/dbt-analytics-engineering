SELECT 
    return_id,
    
    CASE 
          WHEN TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, ',', ''), '$', '')) IS NULL THEN NULL
          WHEN refund_amount IS NULL OR TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, ',', ''), '$', '')) < 0 THEN NULL 
          ELSE TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(refund_amount, ',', ''), '$', ''))
    END as refund_amount,

    CASE 
          WHEN refund_method IS NULL OR TRIM(refund_method) = '' THEN 'Unknown'
          ELSE TRIM(dbo.TitleCase(refund_method))
    END as refund_method
FROM {{ ref('stg_returns') }} ;

