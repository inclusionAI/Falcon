WITH canceled_orders AS (

SELECT

o.productid,

o.customerid

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

WHERE

o.orderstatus = 'Canceled'

),

order_city_category AS (

SELECT

c.city,

p.category

FROM

canceled_orders co

JOIN

ant_icube_dev.di_data_cleaning_for_customer_database_e_customers c

ON co.customerid = c.customerid

JOIN

ant_icube_dev.di_data_cleaning_for_customer_database_e_products p

ON co.productid = p.productid

),

city_category_counts AS (

SELECT

category,

city,

COUNT(*) AS cancel_count

FROM

order_city_category

GROUP BY

category,

city

),

ranked_cities AS (

SELECT

category,

city,

cancel_count,

RANK() OVER (

PARTITION BY category 

ORDER BY cancel_count DESC

) AS rnk  -- 改为rnk避免关键字冲突

FROM

city_category_counts

)

SELECT

category AS `category`,

city AS `city`,

cancel_count AS `cancel_count`

FROM

ranked_cities

WHERE

rnk = 1;  -- 获取所有并列第一的记录