WITH zero_stock_products AS (
SELECT
productid,
category
FROM
ant_icube_dev.di_data_cleaning_for_customer_database_e_products
WHERE
CAST(stockquantity AS INT) = 0
),
historical_orders AS (
SELECT
DISTINCT productid
FROM
ant_icube_dev.di_data_cleaning_for_customer_database_e_orders
)
SELECT
DISTINCT z.category AS `category`
FROM
zero_stock_products z
JOIN
historical_orders h
ON z.productid = h.productid;