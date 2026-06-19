SELECT 
    return_id,
    refund_amount,
    refund_method
FROM {{ ref('stg_returns') }} ;