WITH earliest_customers AS (

SELECT

customerid,

city

FROM (

SELECT

customerid,

city,

RANK() OVER (PARTITION BY city ORDER BY signupdate ASC) AS rn

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_customers

) t

WHERE rn = 1  -- 选择排名最高的客户（即最早注册的客户）

)

SELECT

ec.city AS `城市`,

SUM(CAST(o.totalamount AS DOUBLE)) AS `总金额`

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

INNER JOIN

earliest_customers ec ON o.customerid = ec.customerid

GROUP BY

ec.city

HAVING

SUM(CAST(o.totalamount AS DOUBLE)) > 100;