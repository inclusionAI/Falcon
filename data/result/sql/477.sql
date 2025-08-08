WITH recent_purchases AS (

SELECT

s.customerid,

MAX(s.salesdate) AS last_salesdate

FROM

ant_icube_dev.grocery_sales_sales s

GROUP BY

s.customerid

),

customer_city AS (

SELECT

c.customerid,

c.cityid,

rp.last_salesdate

FROM

ant_icube_dev.grocery_sales_customers c

INNER JOIN

recent_purchases rp

ON

c.customerid = rp.customerid

)

SELECT

customerid AS `客户id`,

last_salesdate AS `最近购买日期`,

cityid AS `城市id`

FROM

customer_city;