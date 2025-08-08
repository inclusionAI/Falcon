WITH ride_promo AS (
SELECT
r.city,
CASE WHEN r.promo_code IS NOT NULL AND r.promo_code != '' THEN 1 ELSE 0 END AS is_promo,
CAST(d.experience_years AS DOUBLE) AS experience
FROM ant_icube_dev.city_ride_data_rides r
INNER JOIN ant_icube_dev.city_ride_data_drivers d
ON r.driver_id = d.driver_id
),
city_stats AS (
SELECT
city,
COUNT(*) AS total_rides,
SUM(is_promo) AS promo_rides,
AVG(experience) AS avg_experience
FROM ride_promo
GROUP BY city
)
SELECT
city AS `城市`,
promo_rides / total_rides AS `使用优惠码的行程占比`,
avg_experience AS `司机平均驾龄`
FROM city_stats;