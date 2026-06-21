SELECT 
     transaction_id
    ,rn
    ,order_id
    ,order_line_number
    ,order_date
    ,order_year
    ,order_month
    ,order_month_name
    ,order_quarter
    ,order_day_of_week
    ,ship_date
    ,delivery_date
    ,customer_id
    ,customer_full_name
    ,customer_first_name
    ,customer_last_name
    ,customer_email
    ,customer_phone
    ,customer_city
    ,customer_state
    ,customer_zip
    ,customer_region
    ,customer_segment
    ,customer_gender
    ,customer_age
    ,customer_age_group
    ,product_id
    ,product_name
    ,sku
    ,brand
    ,category
    ,sub_category
    ,department
    ,quantity_ordered
    ,unit_list_price
    ,discount_pct
    ,unit_selling_price
    ,line_total_before_tax
    ,tax_rate_pct
    ,tax_amount
    ,line_total_with_tax
    ,store_id
    ,store_name
    ,store_city
    ,store_state
    ,store_region
    ,store_type
    ,employee_id
    ,employee_name
    ,employee_job_title
    ,promo_id
    ,promo_name
    ,sales_channel
    ,payment_method
    ,shipping_method
    ,order_status
    ,is_returned
    ,cost_price
    ,gross_profit
    ,data_source
    ,record_created_ts
    ,last_modified_ts
FROM 
(
SELECT 
    ROW_NUMBER() OVER(
            PARTITION BY transaction_id
            ORDER BY transaction_id
    ) AS rn,
    *
FROM {{ source('bronze', 'sales_transactions') }}
WHERE transaction_id IS NOT NULL 
)t WHERE rn = 1;
