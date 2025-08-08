WITH system_avg AS (

SELECT AVG(CAST(totalamount AS DOUBLE)) AS overall_avg

FROM ant_icube_dev.di_data_cleaning_for_customer_database_e_orders

),

city_stats AS (

SELECT

c.city,

AVG(CAST(o.totalamount AS DOUBLE)) AS city_avg

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

JOIN ant_icube_dev.di_data_cleaning_for_customer_database_e_customers c

ON o.customerid = c.customerid

GROUP BY

c.city

)

SELECT

city AS `城市`,

city_avg AS `平均订单金额`

FROM city_stats

WHERE city_avg > (

SELECT overall_avg 

FROM system_avg

);