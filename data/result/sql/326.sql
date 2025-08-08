WITH 

-- 步骤1: 从订单表获取订单数据，并关联客户表获取城市信息

recent_orders_with_customer AS (

SELECT

o.totalamount,

c.city

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

JOIN

ant_icube_dev.di_data_cleaning_for_customer_database_e_customers c ON o.customerid = c.customerid

)



SELECT

-- 步骤2: 按城市分组计算平均消费金额

city AS `城市`,

AVG(CAST(totalamount AS DOUBLE)) AS `平均消费金额`

FROM

recent_orders_with_customer

GROUP BY

city;