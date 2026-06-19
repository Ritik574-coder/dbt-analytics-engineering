SELECT
    review_id,
    helpful_votes,
    review_channel,
    review_title
FROM {{ ref('stg_reviews') }} ;