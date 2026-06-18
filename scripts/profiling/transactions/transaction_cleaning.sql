SELECT
    * 
FROM bronze.sales_transactions_view ; 

SELECT 
    order_line_number,
    quantity_ordered,
    unit_list_price,
    discount_pct,
    unit_selling_price,
    line_total_before_tax,
    tax_rate_pct,
    tax_amount ,
    line_total_with_tax ,
    cost_price  gross_profit 
FROM bronze.sales_transactions_view
WHERE order_line_number IS NULL 
OR quantity_ordered IS NULL 
OR unit_list_price IS NULL 
OR discount_pct IS NULL 
OR unit_selling_price IS NULL 
OR line_total_before_tax IS NULL ; 


SELECT
    transaction_id,
    quantity_ordered,
    unit_selling_price,
    cost_price,
    gross_profit,
    ROUND((quantity_ordered * unit_selling_price) - cost_price, 2) AS recalculated_gp
FROM bronze.sales_transactions_view
WHERE ABS(
      gross_profit -
      ROUND((quantity_ordered * unit_selling_price) - cost_price, 2)
) > 0.01;

SELECT 
    quantity_ordered * unit_selling_price as new_cost_price ,
    cost_price ,
    line_total_before_tax
FROM bronze.sales_transactions_view
WHERE quantity_ordered * unit_selling_price  != line_total_before_tax;


SELECT
    st.cost_price,
    p.cost_price_usd, 
    st.unit_list_price*st.quantity_ordered as new_cost,
    st.quantity_ordered,
    st.unit_list_price
FROM bronze.sales_transactions_view as st  
LEFT JOIN silver.products as p  
ON st.product_id = p.product_id ; 


-- uinte selling price calculateing 
SELECT 
ROUND(unit_list_price * (1 - discount_pct/100), 2) as unit_selling_price,
unit_selling_price
FROM bronze.sales_transactions_view 
WHERE ROUND(unit_list_price * (1 - discount_pct/100), 2) != unit_selling_price;

-- calculating line_total before tax vale 
SELECT 
    quantity_ordered * unit_selling_price as line_total_before_tax_,
    line_total_before_tax  ,
    ROUND(
    quantity_ordered *
    ROUND(unit_list_price * (1 - discount_pct/100.0), 2)
,2) AS line_total_before_tax__
FROM bronze.sales_transactions_view 
WHERE quantity_ordered * unit_selling_price != line_total_before_tax; 

-- calculating tax amount value 
SELECT 
ROUND(line_total_before_tax * tax_rate_pct/100, 2) as tax_amount,
tax_amount
FROM bronze.sales_transactions_view  
WHERE ROUND(line_total_before_tax * tax_rate_pct/100, 2) != tax_amount

-- calculating line_total_with_tax value 
SELECT 
line_total_with_tax, 
line_total_before_tax + tax_amount as line_total_with_tax ,
line_total_before_tax
FROM bronze.sales_transactions_view 
WHERE line_total_before_tax + tax_amount != line_total_with_tax;


WITH profit_analysis AS
(
SELECT
    st.transaction_id,
    st.line_total_before_tax,
    st.line_total_with_tax,
    st.gross_profit,
    st.quantity_ordered * p.cost_price_usd AS cost_price_
FROM bronze.sales_transactions_view st
LEFT JOIN silver.products p
ON st.product_id = p.product_id
)

SELECT
    line_total_before_tax,
    cost_price_,
    gross_profit,
    ROUND(line_total_before_tax - cost_price_, 2) AS recalculated_gp
FROM profit_analysis;