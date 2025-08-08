WITH latest_orders AS (

SELECT

customerid,

totalamount,

RANK() OVER (PARTITION BY customerid ORDER BY orderdate DESC) AS order_rank  -- 修改为RANK()

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders

),

recent_order_amounts AS (

SELECT

customerid,

AVG(CAST(totalamount AS DOUBLE)) AS latest_amount  -- 使用AVG处理并列情况

FROM

latest_orders

WHERE

order_rank = 1

GROUP BY

customerid  -- 按客户分组计算平均值

),

avg_order_amounts AS (

SELECT

customerid,

AVG(CAST(totalamount AS DOUBLE)) AS avg_amount

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders

GROUP BY

customerid

)

SELECT

a.customerid AS `customerid`,

(r.latest_amount - a.avg_amount) AS `差异值`

FROM

avg_order_amounts a

JOIN

recent_order_amounts r

ON

a.customerid = r.customerid;