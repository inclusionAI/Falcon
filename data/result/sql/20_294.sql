WITH filtered_drivers AS (

SELECT

driver_id,

name

FROM

ant_icube_dev.city_ride_data_drivers

WHERE

active_status = 'Active'

AND city IN ('Los Angeles', 'San Francisco')

),

-- 计算每个司机的总行程距离和平均评分

ride_aggregation AS (

SELECT

r.driver_id,

SUM(CAST(distance_km AS DECIMAL)) AS total_distance,

AVG(CAST(rating AS DECIMAL)) AS avg_rating

FROM

ant_icube_dev.city_ride_data_rides r

INNER JOIN filtered_drivers d ON r.driver_id = d.driver_id

GROUP BY

r.driver_id

HAVING

SUM(CAST(distance_km AS DECIMAL)) > 100

AND AVG(CAST(rating AS DECIMAL)) > 4.0

)

-- 获取符合条件司机的信息

SELECT DISTINCT

d.driver_id AS `driver_id`

FROM

filtered_drivers d

INNER JOIN ride_aggregation ra ON d.driver_id = ra.driver_id;