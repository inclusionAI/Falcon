WITH

-- 筛选出洛杉矶和旧金山且经验超过15年的司机

qualified_drivers AS (

SELECT

driver_id

FROM

ant_icube_dev.city_ride_data_drivers

WHERE

city IN ('Los Angeles', 'San Francisco')

AND CAST(experience_years AS INT) > 15

),



-- 获取关联订单的距离信息

ride_details AS (

SELECT

CAST(r.distance_km AS DOUBLE) AS distance_km

FROM

ant_icube_dev.city_ride_data_rides r

INNER JOIN

qualified_drivers qd

ON

r.driver_id = qd.driver_id

)



-- 计算超过20公里的订单占比

SELECT

SUM(CASE WHEN distance_km > 20 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS `占比`

FROM

ride_details;