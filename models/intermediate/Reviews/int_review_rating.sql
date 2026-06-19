SELECT
    review_id,
    rating,
    rating_text
FROM {{ ref('stg_reviews') }} ;