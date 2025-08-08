WITH active_drivers AS (

SELECT

driver_id,

city

FROM

ant_icube_dev.city_ride_data_drivers

WHERE

active_status = 'Active'

),



-- 关联rides表并提取所需字段

rides_joined AS (

SELECT

r.driver_id,

d.city,

r.fare

FROM

ant_icube_dev.city_ride_data_rides r

INNER JOIN

active_drivers d

ON

r.driver_id = d.driver_id

)



-- 按城市聚合并筛选结果

SELECT

city AS `city`,

COUNT(*) AS `total_rides`,

SUM(CAST(fare AS DOUBLE)) AS `total_fare`

FROM

rides_joined

GROUP BY

city

HAVING

total_rides > 50

AND total_fare > 1000;