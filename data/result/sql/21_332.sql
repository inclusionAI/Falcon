WITH tools_products AS (

SELECT productid

FROM ant_icube_dev.di_data_cleaning_for_customer_database_e_products

WHERE category = 'Tools'

),

filtered_orders AS (

SELECT

o.customerid,

o.orderid,

CAST(o.totalamount AS DOUBLE) AS totalamount

FROM ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

INNER JOIN tools_products p ON o.productid = p.productid

),

city_orders AS (

SELECT

c.city,

fo.orderid,

fo.totalamount

FROM filtered_orders fo

INNER JOIN ant_icube_dev.di_data_cleaning_for_customer_database_e_customers c ON fo.customerid = c.customerid

),

city_stats AS (

SELECT

city,

COUNT(DISTINCT orderid) AS order_count,

SUM(totalamount) AS city_total

FROM city_orders

GROUP BY city

)



SELECT

cs.city AS `城市`,

cs.order_count AS `订单数量`,

(cs.city_total / (SELECT SUM(totalamount) FROM filtered_orders)) * 100 AS `订单金额占比`

FROM city_stats cs

WHERE cs.city_total > 0;