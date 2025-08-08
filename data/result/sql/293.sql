WITH experienced_drivers AS (

SELECT

driver_id

FROM

ant_icube_dev.city_ride_data_drivers

WHERE

CAST(experience_years AS INT) > 15

),



-- 计算满足条件的城市行程统计

ride_stats AS (

SELECT

r.city,

AVG(CAST(r.duration_min AS DOUBLE)) AS avg_duration,

SUM(CAST(r.fare AS DOUBLE)) AS total_fare

FROM

ant_icube_dev.city_ride_data_rides r

INNER JOIN

experienced_drivers ed

ON

r.driver_id = ed.driver_id

GROUP BY

r.city

HAVING

avg_duration > 40

AND  total_fare > 800

)



-- 最终输出符合指标的城市数据

SELECT

city AS `城市`,

avg_duration AS `平均行程时长`,

total_fare AS `总车费`

FROM

ride_stats;