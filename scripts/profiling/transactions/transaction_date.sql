--#############################################################################################
--################################## SHIP DATE CLEAINING DATA #################################
--#############################################################################################
-- Order date data validating 
SELECT 
    order_date,
    record_created
FROM bronze.sales_transactions_view 
WHERE order_date > record_created ;

SELECT 
    ship_date,
    delivery_date 
FROM bronze.sales_transactions_view 
WHERE ship_date > delivery_date ; 


-- Ship Date Correction And Validation
WITH date_cleaning AS 
(
      SELECT 
            order_date,
            ship_date,
            delivery_date,
      CASE
            WHEN DATEDIFF(DAY ,order_date, ship_date) < 0 THEN DATEFROMPARTS(YEAR(ship_date), DAY(ship_date), MONTH(ship_date))
            WHEN DATEDIFF(DAY ,order_date, ship_date) > 15 THEN DATEFROMPARTS(YEAR(ship_date), DAY(ship_date), MONTH(ship_date))
            WHEN ship_date IS NULL THEN DATEADD(DAY, 7, order_date)
            ELSE ship_date 
      END as new_ship
FROM bronze.sales_transactions_view 
 ) 
SELECT 
      order_date,
      ship_date,
      delivery_date,
      new_ship,
      DATEDIFF(DAY, order_date, ship_date) as old_day,
      DATEDIFF(DAY, order_date, new_ship) as new_date
FROM date_cleaning 
WHERE ship_date IS NULL 
OR DATEDIFF(DAY, order_date, new_ship) < 0 
OR DATEDIFF(DAY, order_date, new_ship) > 15 ;

-- Median Shipping Lead Time Analysis
WITH date_cleaning AS 
(
      SELECT 
            order_date,
            ship_date,
            delivery_date,
      CASE
            WHEN DATEDIFF(DAY ,order_date, ship_date) < 0 THEN DATEFROMPARTS(YEAR(ship_date), DAY(ship_date), MONTH(ship_date))
            WHEN DATEDIFF(DAY ,order_date, ship_date) > 15 THEN DATEFROMPARTS(YEAR(ship_date), DAY(ship_date), MONTH(ship_date))
      END as new_ship
FROM bronze.sales_transactions_view 
 ) 
SELECT DISTINCT
PERCENTILE_CONT(0.5)
WITHIN GROUP (
    ORDER BY DATEDIFF(DAY, order_date, new_ship)
) OVER () AS median_ship_days
FROM date_cleaning
WHERE new_ship IS NOT NULL;

-- Monthly Shipping Lead Time Analysis
SELECT
    YEAR(order_date) AS yr,
    MONTH(order_date) AS mn,
    AVG(DATEDIFF(DAY, order_date, ship_date) * 1.0) AS avg_ship_days
FROM bronze.sales_transactions_view
WHERE ship_date IS NOT NULL
AND DATEDIFF(DAY, order_date , ship_date) < 0 
AND DATEDIFF(DAY, order_date , ship_date) > 40 
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY YEAR(order_date),
    MONTH(order_date) DESC ;


SELECT
    YEAR(order_date) AS yr,
    MONTH(order_date) AS mn,
    AVG(DATEDIFF(DAY, order_date, ship_date) * 1.0) AS avg_ship_days
FROM bronze.sales_transactions_view
WHERE ship_date IS NOT NULL
  AND DATEDIFF(DAY, order_date, ship_date) BETWEEN 0 AND 40
GROUP BY
    YEAR(order_date),
    MONTH(order_date);

-- Ship Date Imputation Using Monthly Lead Time
WITH monthly_avg AS (
    SELECT
        YEAR(order_date) AS yr,
        MONTH(order_date) AS mn,
        AVG(DATEDIFF(DAY, order_date, ship_date)) AS avg_ship_days
    FROM bronze.sales_transactions_view
    WHERE ship_date IS NOT NULL
      AND ship_date >= order_date
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
)
SELECT
    t.order_date,
    t.ship_date,
    DATEADD(
        DAY,
        CAST(m.avg_ship_days AS INT),
        t.order_date
    ) AS cleaned_ship_date
FROM bronze.sales_transactions_view t
JOIN monthly_avg m
    ON YEAR(t.order_date) = m.yr
   AND MONTH(t.order_date) = m.mn
WHERE t.ship_date IS NULL
   OR t.ship_date < t.order_date;





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
      ,unit_selling_price
      ,line_total_before_tax
      ,tax_rate_pct
      ,tax_amount
      ,line_total_with_tax
      ,order_date
      ,ship_date
      ,delivery_date
      ,record_created
      ,last_modified
FROM bronze.sales_transactions_view ;


-- Ship Date Correction And Validation

WITH date_cleaning AS 
(
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
    ,unit_selling_price
    ,line_total_before_tax
    ,tax_rate_pct
    ,tax_amount
    ,line_total_with_tax
    ,order_date
    ,CASE
        WHEN DATEDIFF(DAY ,order_date, ship_date) < 0 THEN DATEFROMPARTS(YEAR(ship_date), DAY(ship_date), MONTH(ship_date))
        WHEN DATEDIFF(DAY ,order_date, ship_date) > 15 THEN DATEFROMPARTS(YEAR(ship_date), DAY(ship_date), MONTH(ship_date))
        WHEN ship_date IS NULL THEN DATEADD(DAY, 7, order_date)
        ELSE ship_date 
    END as ship_date 
    ,delivery_date
    ,record_created
    ,last_modified
FROM bronze.sales_transactions_view 
 )
,delivery_cleaning AS
(
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
    ,unit_selling_price
    ,line_total_before_tax
    ,tax_rate_pct
    ,tax_amount
    ,line_total_with_tax
    ,order_date
    ,ship_date 
    ,CASE 
        WHEN DATEDIFF(DAY, ship_date , delivery_date) >  17 THEN DATEFROMPARTS(YEAR(delivery_date), DAY(delivery_date), MONTH(delivery_date))
        WHEN DATEDIFF(DAY, ship_date , delivery_date) < -15 THEN DATEFROMPARTS(YEAR(delivery_date), DAY(delivery_date), MONTH(delivery_date))
        ELSE delivery_date
    END as delivery_date
    ,record_created
    ,last_modified
FROM date_cleaning 
)
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
    ,unit_selling_price
    ,line_total_before_tax
    ,tax_rate_pct
    ,tax_amount
    ,line_total_with_tax
    ,order_date
    ,ship_date
    ,CASE 
       WHEN DATEDIFF(DAY, ship_date , delivery_date) < 0 THEN ship_date 
       ELSE delivery_date
    END as delivery_date
    ,record_created
    ,last_modified
FROM delivery_cleaning 

;
