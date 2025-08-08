WITH active_drivers AS (
SELECT
driver_id,
CAST(average_rating AS DOUBLE) AS average_rating
FROM
ant_icube_dev.city_ride_data_drivers
WHERE
active_status = 'Active'
),
driver_total_duration AS (
SELECT
driver_id,
SUM(CAST(duration_min AS BIGINT)) AS total_duration
FROM
ant_icube_dev.city_ride_data_rides
GROUP BY
driver_id
HAVING
SUM(CAST(duration_min AS BIGINT)) > 100
)
SELECT
AVG(a.average_rating) AS `平均评分`
FROM
active_drivers a
INNER JOIN
driver_total_duration d
ON
a.driver_id = d.driver_id;