SELECT
    review_id,

    CASE
        WHEN TRY_CONVERT(INT, rating) BETWEEN 1 AND 5
        THEN TRY_CONVERT(INT, rating)
        ELSE NULL
    END AS rating,
        
    rating_text
FROM {{ ref('stg_reviews') }} ;