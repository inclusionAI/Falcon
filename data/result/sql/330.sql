WITH customer_summary AS (

SELECT

c.customerid,

c.city,

SUM(CAST(o.totalamount AS DOUBLE)) AS total_amount,

COUNT(o.orderid) AS order_count

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

JOIN

ant_icube_dev.di_data_cleaning_for_customer_database_e_customers c ON o.customerid = c.customerid

GROUP BY

c.customerid,

c.city

),

ranked_customers AS (

SELECT

customerid,

city,

total_amount,

order_count,

RANK() OVER (PARTITION BY city ORDER BY total_amount DESC) AS rn

FROM

customer_summary

),

top_customers AS (

SELECT

city,

customerid,

AVG(order_count) OVER (PARTITION BY city) AS avg_order_count

FROM

ranked_customers

WHERE

rn <= 3  -- 选择每个城市前 3 名

)

SELECT DISTINCT

city AS `城市`,

customerid AS `客户id`,

avg_order_count AS `平均订单数量`

FROM

top_customers

ORDER BY

`城市`;