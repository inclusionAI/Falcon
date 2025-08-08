WITH cte_users AS (

SELECT

customerid,

city

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_customers

),

cte_avg_amount AS (

SELECT

u.customerid,

u.city,

AVG(CAST(o.totalamount AS DOUBLE)) AS avg_amount

FROM

cte_users u

JOIN

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o ON u.customerid = o.customerid

GROUP BY

u.customerid, u.city

),

cte_filtered AS (

SELECT

customerid,

city

FROM

cte_avg_amount

WHERE

avg_amount > 150

)

SELECT

city AS `city`,

COUNT(DISTINCT customerid) AS `客户数量`

FROM

cte_filtered

GROUP BY

city;