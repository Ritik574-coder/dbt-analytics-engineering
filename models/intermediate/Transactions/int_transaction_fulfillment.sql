WITH transaction_fulfillment AS 
(
    SELECT 
        transaction_id,

        {{ standardize_date('order_date') }} as order_date,
        {{ standardize_date('ship_date') }} as ship_date,
        {{ standardize_date('delivery_date') }} as delivery_date,
        order_month,

        CASE 
            WHEN TRIM(LOWER(shipping_method)) IN ('pickup', 'in-store pickup')       
                THEN 'Store Pickup'

            WHEN TRIM(LOWER(shipping_method)) IN ('overnight', 'overnight shipping') 
                THEN 'Overnight Shipping'

            WHEN TRIM(LOWER(shipping_method)) IN ('same day', 'same day delivery')   
                THEN 'Same Day Delivery'

            WHEN TRIM(LOWER(shipping_method)) IN ('express', 'express shipping')     
                THEN 'Express Shipping'

            WHEN TRIM(LOWER(shipping_method)) IN ('standard', 'standard shipping')   
                THEN 'Standard Shipping'

            WHEN TRIM(LOWER(shipping_method)) IN ('free ship', 'free shipping')      
                THEN 'Free Shipping'

            ELSE TRIM(shipping_method)
        END AS shipping_method,

        CASE 
            WHEN TRIM(LOWER(sales_channel)) IN ('app', 'mobile', 'mobile app')   
                THEN 'Mobile App'

            WHEN TRIM(LOWER(sales_channel)) IN ('store', 'in store', 'in-store') 
                THEN 'In Store'

            WHEN TRIM(LOWER(sales_channel)) IN ('online', 'web')                 
                THEN 'Website'

            WHEN TRIM(LOWER(sales_channel)) IN ('phone')                         
                THEN 'Phone Call'

            WHEN TRIM(LOWER(sales_channel)) IN ('catalog')                       
                THEN 'Catalog'

            ELSE 'Unknown'
        END AS sales_channel,

        CASE TRIM(LOWER(payment_method))
            WHEN 'debit card'        THEN 'Debit Card'
            WHEN 'credit card'       THEN 'Credit Card'
            WHEN 'google pay'        THEN 'Google Pay'
            WHEN 'apple pay'         THEN 'Apple Pay'
            WHEN 'bank transfer'     THEN 'Bank Transfer'
            WHEN 'buy now pay later' THEN 'Buy Now Pay Later'
            WHEN 'bnpl'              THEN 'Buy Now Pay Later'
            WHEN 'gift card'         THEN 'Gift Card'
            WHEN 'paypal'            THEN 'PayPal'
            WHEN 'cash'              THEN 'Cash'
            ELSE TRIM(payment_method)
        END AS payment_method,

        TRY_CONVERT(DATE, record_created_ts) as record_created,
        TRY_CONVERT(DATE, last_modified_ts ) as last_modified
    FROM {{ ref('stg_transactions') }} 
),
order_date_cleaning AS 
(
    SELECT  
        transaction_id,

        CASE 
            WHEN order_month != MONTH(order_date) 
                THEN DATEFROMPARTS(YEAR(order_date), DAY(order_date), MONTH(order_date))

            ELSE order_date
        END AS order_date,

        ship_date,
        delivery_date,

        shipping_method,
        sales_channel,
        payment_method,

        CASE 
            WHEN record_created IS NULL 
              OR record_created NOT LIKE '____-__-__' 
              OR TRY_CONVERT(DATE, record_created) IS NULL 
              OR YEAR(record_created) < 2019  
                THEN NULL 

            ELSE record_created
        END as record_created,

        CASE 
            WHEN last_modified IS NULL 
              OR last_modified NOT LIKE '____-__-__' 
              OR TRY_CONVERT(DATE, last_modified) IS NULL 
              OR YEAR(last_modified) < 2019  
                THEN NULL 

            ELSE last_modified
        END as last_modified

    FROM transaction_fulfillment 
),
ship_date_cleaning AS 
(
    SELECT
        transaction_id,
        order_date ,

        CASE
            WHEN DATEDIFF(DAY ,order_date, ship_date) < 0 
                THEN DATEFROMPARTS(YEAR(ship_date), DAY(ship_date), MONTH(ship_date))

            WHEN DATEDIFF(DAY ,order_date, ship_date) > 15 
                THEN DATEFROMPARTS(YEAR(ship_date), DAY(ship_date), MONTH(ship_date))

            WHEN ship_date IS NULL 
                THEN DATEADD(DAY, 7, order_date)
                
            ELSE ship_date 
        END as ship_date ,

        delivery_date,
        shipping_method,
        sales_channel,
        payment_method,
        record_created,
        last_modified
    FROM order_date_cleaning 
),
int_transaction_fulfillment AS 
(
    SELECT 
        transaction_id,
        order_date,
        ship_date,

        CASE 
            WHEN DATEDIFF(DAY, ship_date , delivery_date) >  17 
                THEN DATEFROMPARTS(YEAR(delivery_date), DAY(delivery_date), MONTH(delivery_date))

            WHEN DATEDIFF(DAY, ship_date , delivery_date) < -15 
                THEN DATEFROMPARTS(YEAR(delivery_date), DAY(delivery_date), MONTH(delivery_date))

            ELSE delivery_date
        END as delivery_date,

        shipping_method,
        sales_channel,
        payment_method,
        record_created,
        last_modified
    FROM ship_date_cleaning 
)
SELECT 
        transaction_id,
        order_date,
        ship_date,
        delivery_date,
        shipping_method,
        sales_channel,
        payment_method,
        record_created,
        last_modified
FROM int_transaction_fulfillment;
