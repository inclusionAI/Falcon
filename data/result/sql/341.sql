WITH zero_stock_products AS (

SELECT

productid,

category,

price,

productname

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_products

WHERE

CAST(stockquantity AS INT) = 0

),

-- 统计每个商品的历史订单总数量

product_order_stats AS (

SELECT

o.productid,

COUNT(o.orderid) AS total_orders

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

INNER JOIN zero_stock_products zsp

ON o.productid = zsp.productid

GROUP BY

o.productid

)

-- 关联商品信息并输出结果

SELECT

zsp.category AS `category`,

zsp.price AS `price`,

zsp.productid AS `productid`,

zsp.productname AS `productname`,

pos.total_orders AS `total_quantity`

FROM

zero_stock_products zsp

INNER JOIN product_order_stats pos

ON zsp.productid = pos.productid;