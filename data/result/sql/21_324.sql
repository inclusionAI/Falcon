WITH avg_stock AS (

SELECT AVG(CAST(stockquantity AS BIGINT)) AS avg_val

FROM ant_icube_dev.di_data_cleaning_for_customer_database_e_products

),

-- 步骤2：筛选库存低于平均值的商品ID

low_stock_products AS (

SELECT productid

FROM ant_icube_dev.di_data_cleaning_for_customer_database_e_products

WHERE CAST(stockquantity AS BIGINT) < (SELECT avg_val FROM avg_stock)

)

-- 步骤3：关联订单表获取订单数据

SELECT DISTINCT

o.orderid AS `orderid`

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

INNER JOIN

low_stock_products p ON o.productid = p.productid;