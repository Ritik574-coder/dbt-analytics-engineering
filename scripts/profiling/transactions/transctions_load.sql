CREATE TABLE silver.sales_transactions
(
    transaction_id         VARCHAR(30),
    order_id               INT,
    customer_id            INT,
    product_id             INT,
    store_id               INT,
    employee_id            INT,

    promo_id               INT,
    promo_name             VARCHAR(100),

    sales_channel          VARCHAR(50),
    payment_method         VARCHAR(50),
    shipping_method        VARCHAR(50),
    order_status           VARCHAR(50),
    is_returned            VARCHAR(10),
    data_source            VARCHAR(20),

    order_line_number      TINYINT,
    quantity_ordered       INT,

    unit_list_price        DECIMAL(10,2),
    discount_pct           INT,
    unit_selling_price     DECIMAL(10,2),

    line_total_before_tax  DECIMAL(12,2),
    tax_rate_pct           INT,
    tax_amount             DECIMAL(12,2),
    line_total_with_tax    DECIMAL(12,2),

--    cost_price             DECIMAL(10,2),
--    gross_profit           DECIMAL(12,2),

    order_date             DATE,
    ship_date              DATE,
    delivery_date          DATE,

    record_created         DATE,
    last_modified          DATE
);

INSERT INTO silver.sales_transactions
(
       transaction_id
      ,order_id
      ,customer_id
      ,product_id
      ,store_id
      ,employee_id
      ,promo_id
      ,promo_name
      ,sales_channel
      ,payment_method
      ,shipping_method
      ,order_status
      ,is_returned
      ,data_source
      ,order_line_number
      ,quantity_ordered
      ,unit_list_price
      ,discount_pct
      ,unit_selling_price
      ,line_total_before_tax
      ,tax_rate_pct
      ,tax_amount
      ,line_total_with_tax
--      ,cost_price
--      ,gross_profit 
      ,order_date
      ,ship_date
      ,delivery_date
      ,record_created
      ,last_modified
)
SELECT
      transaction_id
      ,order_id
      ,customer_id
      ,product_id
      ,store_id
      ,employee_id
      ,promo_id
      ,promo_name
      ,sales_channel
      ,payment_method
      ,shipping_method
      ,order_status
      ,is_returned
      ,data_source
      ,order_line_number
      ,quantity_ordered
      ,unit_list_price
      ,discount_pct

      ,ROUND(unit_list_price * (1 - discount_pct/100), 2) as unit_selling_price

      ,ROUND(quantity_ordered * ROUND(unit_list_price * (1 - discount_pct/100.0), 2),2) AS line_total_before_tax

      ,tax_rate_pct
      ,tax_amount

      ,ROUND(quantity_ordered * ROUND(unit_list_price * (1 - discount_pct/100.0), 2),2) + tax_amount AS line_total_with_tax

--      ,cost_price
--      ,gross_profit

      ,CASE 
            WHEN order_month != MONTH(order_date) THEN DATEFROMPARTS(YEAR(order_date), DAY(order_date), MONTH(order_date))
            ELSE order_date
      END AS order_date

      ,ship_date
      ,delivery_date

      ,CASE 
            WHEN record_created IS NULL 
            OR record_created NOT LIKE '____-__-__' 
            OR TRY_CONVERT(DATE, record_created) IS NULL 
            OR YEAR(record_created) < 2019  THEN NULL 
            ELSE record_created
      END as record_created

      ,CASE 
            WHEN last_modified IS NULL 
            OR last_modified NOT LIKE '____-__-__' 
            OR TRY_CONVERT(DATE, last_modified) IS NULL 
            OR YEAR(last_modified) < 2019  THEN NULL 
            ELSE last_modified
      END as last_modified
FROM 
(
SELECT
       transaction_id
      ,order_id
      ,customer_id
      ,product_id 
      ,store_id 
      ,employee_id 
      ,promo_id

      ,CASE TRIM(LOWER(promo_name))
            WHEN 'winter clearance' THEN 'Winter Clearance'
            WHEN 'bundle deal'      THEN 'Bundle Deal'
            WHEN 'no promo'         THEN 'No Promo'
            WHEN 'flash sale'       THEN 'Flash Sale'
            WHEN 'black friday'     THEN 'Black Friday'
            WHEN 'holiday special'  THEN 'Holiday Special'
            WHEN 'weekend deal'     THEN 'Weekend Deal'
            WHEN 'loyalty reward'   THEN 'Loyalty Reward'
            WHEN 'cyber monday'     THEN 'Cyber Monday'
            ELSE TRIM(promo_name)
      END AS promo_name

      ,CASE 
            WHEN TRIM(LOWER(sales_channel)) IN ('app', 'mobile', 'mobile app')   THEN 'Mobile App'
            WHEN TRIM(LOWER(sales_channel)) IN ('store', 'in store', 'in-store') THEN 'In Store'
            WHEN TRIM(LOWER(sales_channel)) IN ('online', 'web')                 THEN 'Website'
            WHEN TRIM(LOWER(sales_channel)) IN ('phone')                         THEN 'Phone Call'
            WHEN TRIM(LOWER(sales_channel)) IN ('catalog')                       THEN 'Catalog'
            ELSE 'Unknown'
      END AS sales_channel

      ,CASE TRIM(LOWER(payment_method))
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
      END AS payment_method

      ,CASE 
            WHEN TRIM(LOWER(shipping_method)) IN ('pickup', 'in-store pickup')       THEN 'Store Pickup'
            WHEN TRIM(LOWER(shipping_method)) IN ('overnight', 'overnight shipping') THEN 'Overnight Shipping'
            WHEN TRIM(LOWER(shipping_method)) IN ('same day', 'same day delivery')   THEN 'Same Day Delivery'
            WHEN TRIM(LOWER(shipping_method)) IN ('express', 'express shipping')     THEN 'Express Shipping'
            WHEN TRIM(LOWER(shipping_method)) IN ('standard', 'standard shipping')   THEN 'Standard Shipping'
            WHEN TRIM(LOWER(shipping_method)) IN ('free ship', 'free shipping')      THEN 'Free Shipping'
            ELSE TRIM(shipping_method)
      END AS shipping_method

      ,CASE TRIM(LOWER(order_status))
            WHEN 'pending'    THEN 'Pending'
            WHEN 'processing' THEN 'Processing'
            WHEN 'shipped'    THEN 'Shipped'
            WHEN 'delivered'  THEN 'Delivered'
            WHEN 'returned'   THEN 'Returned'
            WHEN 'cancelled'  THEN 'Cancelled'
            ELSE TRIM(order_status)
      END AS order_status

      ,CASE 
            WHEN TRIM(LOWER(is_returned)) IN ('yes', 'y', 'true', '1') THEN 'True'
            WHEN TRIM(LOWER(is_returned)) IN ('no', 'n', 'false', '0') THEN 'False'
            ELSE 'Unknown'
      END AS is_returned

      ,CASE TRIM(LOWER(data_source))
            WHEN 'crm'    THEN 'CRM'
            WHEN 'web'    THEN 'Web'
            WHEN 'pos'    THEN 'POS'
            WHEN 'manual' THEN 'Manual'
            WHEN 'erp'    THEN 'ERP'
            ELSE 'Unknown'
      END AS data_source

      ,CASE 
            WHEN order_line_number < 1 THEN NULL 
            WHEN order_line_number > 20 THEN NULL
            ELSE order_line_number
      END as order_line_number

      ,CASE 
            WHEN quantity_ordered < 1 THEN NULL 
            WHEN quantity_ordered > 30 THEN NULL
            ELSE quantity_ordered
      END as quantity_ordered 

      ,CASE 
            WHEN unit_list_price IS NULL THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10, 2), REPLACE(REPLACE(unit_list_price, '$', ''), ',', '')) 
      END as unit_list_price 

      ,CASE 
            WHEN discount_pct IS NULL OR discount_pct < 0 OR discount_pct > 100 THEN NULL 
            ELSE ROUND(discount_pct, 0)
      END as discount_pct

      ,CASE 
            WHEN unit_selling_price IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(unit_selling_price, '$', ''), ',', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(unit_selling_price, '$', ''), ',', ''))
      END as unit_selling_price

      ,CASE 
            WHEN line_total_before_tax IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_before_tax, '$', ''), ',', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_before_tax, '$', ''), ',', ''))
      END as line_total_before_tax

      ,CASE 
            WHEN tax_rate_pct IS NULL OR TRY_CONVERT(INT, ROUND(tax_rate_pct, 0)) < 0 OR TRY_CONVERT(INT, ROUND(tax_rate_pct, 0)) > 100 THEN NULL 
            ELSE TRY_CONVERT(INT, ROUND(tax_rate_pct, 0))
      END as tax_rate_pct

      ,CASE 
            WHEN tax_amount IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(tax_amount, '$', ''), ',', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(tax_amount, '$', ''), ',', ''))
      END as tax_amount

      ,CASE 
            WHEN line_total_with_tax IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_with_tax, '$', ''), ',', '')) < 0 THEN NULL 
            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(line_total_with_tax, '$', ''), ',', ''))
      END as line_total_with_tax

--      ,CASE 
--            WHEN cost_price IS NULL OR TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price, '$', ''), ',', '')) < 0 THEN NULL 
--            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(cost_price, '$', ''), ',', ''))
--      END as cost_price
--
--      ,CASE 
--            WHEN gross_profit IS NULL THEN NULL 
--            ELSE TRY_CONVERT(DECIMAL(10,2), REPLACE(REPLACE(gross_profit, '$', ''), ',', ''))
--      END as gross_profit

      ,CASE 
            WHEN order_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE , order_date)
            WHEN order_date LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE , order_date)
            WHEN order_date LIKE '____/__/__'                     THEN TRY_CONVERT(DATE , order_date)
            WHEN order_date LIKE '____-__-__'                     THEN TRY_CONVERT(DATE , order_date)
            WHEN order_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(order_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 101)
            WHEN order_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(order_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, order_date, 110)
            WHEN order_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(order_date, 2)) > 12         THEN TRY_CONVERT(DATE, order_date, 103) 
            WHEN order_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(order_date, 2)) > 12         THEN TRY_CONVERT(DATE, order_date, 105) 
            ELSE TRY_CONVERT(DATE, TRIM(order_date), 101)
      END as order_date

      ,order_month

      ,CASE 
            WHEN ship_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE , ship_date)
            WHEN ship_date LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE , ship_date)
            WHEN ship_date LIKE '____/__/__'                     THEN TRY_CONVERT(DATE , ship_date)
            WHEN ship_date LIKE '____-__-__'                     THEN TRY_CONVERT(DATE , ship_date)
            WHEN ship_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(ship_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, ship_date, 101)
            WHEN ship_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(ship_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, ship_date, 110)
            WHEN ship_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(ship_date, 2)) > 12         THEN TRY_CONVERT(DATE, ship_date, 103) 
            WHEN ship_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(ship_date, 2)) > 12         THEN TRY_CONVERT(DATE, ship_date, 105) 
            ELSE TRY_CONVERT(DATE, TRIM(ship_date), 101)
      END as ship_date

      ,CASE 
            WHEN delivery_date LIKE '[A-Z][a-z][a-z][a-z]% __, ____' THEN TRY_CONVERT(DATE , delivery_date)
            WHEN delivery_date LIKE '[A-Z][a-z][a-z] __, ____'       THEN TRY_CONVERT(DATE , delivery_date)
            WHEN delivery_date LIKE '____/__/__'                     THEN TRY_CONVERT(DATE , delivery_date)
            WHEN delivery_date LIKE '____-__-__'                     THEN TRY_CONVERT(DATE , delivery_date)
            WHEN delivery_date LIKE '__/__/____' AND TRY_CONVERT(INT, SUBSTRING(delivery_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, delivery_date, 101)
            WHEN delivery_date LIKE '__-__-____' AND TRY_CONVERT(INT, SUBSTRING(delivery_date, 4, 2)) > 12 THEN TRY_CONVERT(DATE, delivery_date, 110)
            WHEN delivery_date LIKE '__/__/____' AND TRY_CONVERT(INT, LEFT(delivery_date, 2)) > 12         THEN TRY_CONVERT(DATE, delivery_date, 103) 
            WHEN delivery_date LIKE '__-__-____' AND TRY_CONVERT(INT, LEFT(delivery_date, 2)) > 12         THEN TRY_CONVERT(DATE, delivery_date, 105) 
            ELSE TRY_CONVERT(DATE, TRIM(delivery_date), 101)
      END as delivery_date

      ,TRY_CONVERT(DATE, record_created_ts) as record_created
      ,TRY_CONVERT(DATE, last_modified_ts ) as last_modified
      ,ROW_NUMBER() OVER(PARTITION BY transaction_id ORDER BY last_modified_ts DESC) AS rn
FROM bronze.sales_transactions 
 )t WHERE rn = 1; 



