WITH filtered_orders AS (

SELECT

customerid,

totalamount,

orderdate

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders

WHERE

orderstatus = 'Shipped'

)

SELECT

c.customerid as `客户id`,

SUM(fo.totalamount) as `订单总金额`,

MAX(fo.orderdate) as `最近一次下单时间`

FROM

filtered_orders fo

JOIN

ant_icube_dev.di_data_cleaning_for_customer_database_e_customers c

ON

fo.customerid = c.customerid

GROUP BY

c.customerid;