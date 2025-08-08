WITH 订单数据 AS (

SELECT

customerid,

orderstatus,

totalamount,

COUNT(*) OVER (PARTITION BY customerid, orderstatus) AS order_count

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders

),

过滤后的订单 AS (

SELECT

customerid,

orderstatus,

CAST(totalamount AS DOUBLE) AS amount

FROM

订单数据

WHERE

order_count < 2

),

用户去重 AS (

SELECT

customerid,

email,

RANK() OVER (PARTITION BY customerid ORDER BY signupdate DESC) AS rn

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_customers

),

用户邮箱 AS (

SELECT

customerid,

SPLIT(email, '@')[1] AS email_domain

FROM

用户去重

WHERE

rn = 1

)

SELECT

orderstatus AS `订单状态`,

email_domain AS `邮箱域名`,

SUM(amount) AS `总金额`

FROM

过滤后的订单

JOIN

用户邮箱

USING

(customerid)

GROUP BY

`订单状态`, `邮箱域名`;