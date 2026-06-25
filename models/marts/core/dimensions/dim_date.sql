WITH dates AS (
    SELECT order_date AS date_day FROM {{ ref('int_transaction_fulfillment') }}
    UNION
    SELECT ship_date AS date_day FROM {{ ref('int_transaction_fulfillment') }}
    UNION
    SELECT delivery_date AS date_day FROM {{ ref('int_transaction_fulfillment') }}
    UNION
    SELECT return_date AS date_day FROM {{ ref('int_return_transaction') }}
    UNION
    SELECT review_date AS date_day FROM {{ ref('int_review_transaction') }}
    UNION
    SELECT snapshot_date AS date_day FROM {{ ref('int_inventory_product') }}
)

SELECT
    date_day,
    YEAR(date_day) AS year_number,
    DATEPART(QUARTER, date_day) AS quarter_number,
    MONTH(date_day) AS month_number,
    DATENAME(MONTH, date_day) AS month_name,
    DAY(date_day) AS day_of_month,
    DATEPART(WEEK, date_day) AS week_number,
    DATENAME(WEEKDAY, date_day) AS day_name,
    DATEPART(WEEKDAY, date_day) AS day_of_week_number,
    CASE
        WHEN DATEPART(WEEKDAY, date_day) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type
FROM dates
WHERE date_day IS NOT NULL;
