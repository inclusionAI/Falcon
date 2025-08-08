WITH promo_rides AS (

SELECT

city,

driver_id,

distance_km,

rating

FROM

ant_icube_dev.city_ride_data_rides

WHERE

promo_code IS NOT NULL

),

city_stats AS (

SELECT

city,

COUNT(*) AS promo_order_count,

AVG(CASE 

WHEN CAST(distance_km AS DOUBLE) > (SELECT AVG(CAST(distance_km AS DOUBLE)) FROM promo_rides pr2 WHERE pr2.city = pr.city) 

THEN CAST(rating AS DOUBLE) 

END) AS avg_rating

FROM

promo_rides pr

GROUP BY

city

)



SELECT

city AS `city`,

promo_order_count AS `promo_order_count`,

avg_rating AS `avg_rating`

FROM

city_stats;