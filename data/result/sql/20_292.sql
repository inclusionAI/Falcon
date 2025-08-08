WITH high_rated_drivers AS (
SELECT
driver_id
FROM
ant_icube_dev.city_ride_data_drivers
WHERE
CAST(average_rating AS DOUBLE) > 4.5
),
-- 获取高评分司机的行程数据并转换费用类型
filtered_rides AS (
SELECT
r.city,
CAST(r.fare AS DOUBLE) AS fare
FROM
ant_icube_dev.city_ride_data_rides r
INNER JOIN
high_rated_drivers hrd
ON
r.driver_id = hrd.driver_id
),
-- 计算城市维度的行程次数和平均费用
city_metrics AS (
SELECT
city,
COUNT(*) AS ride_count,
AVG(fare) AS fare_avg
FROM
filtered_rides
GROUP BY
city
)
-- 过滤最终符合条件的城市
SELECT
city,
ride_count,
fare_avg
FROM
city_metrics
WHERE
ride_count > 30
AND fare_avg < 50;