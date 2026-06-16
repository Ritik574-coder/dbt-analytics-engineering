SELECT
     review_id
    ,txn_id
    ,customer_id
    ,customer_name
    ,product_id
    ,product_name
    ,rating
    ,rating_text
    ,review_date
    ,verified_purchase
    ,helpful_votes
    ,review_channel
    ,review_title
FROM {{ source('bronze', 'reviews') }} ;