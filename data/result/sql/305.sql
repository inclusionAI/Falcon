WITH active_drivers AS (

SELECT

driver_id,

city,

CAST(experience_years AS INT) AS experience_years,

CAST(average_rating AS DOUBLE) AS average_rating

FROM

ant_icube_dev.city_ride_data_drivers

WHERE

active_status = 'Active'

),

city_avg_rating AS (

SELECT

city,

AVG(average_rating) AS avg_city_rating

FROM

active_drivers

GROUP BY

city

),

driver_ranks AS (

SELECT

ad.driver_id,

ad.city,

ad.experience_years,

ad.average_rating,

car.avg_city_rating,

RANK() OVER (PARTITION BY ad.city ORDER BY ad.experience_years DESC) AS experience_rank

FROM

active_drivers ad

JOIN

city_avg_rating car

ON

ad.city = car.city

)

SELECT

driver_id AS `driver_id`,

city AS `city`,

experience_rank AS `经验年数排名`

FROM

driver_ranks

WHERE

average_rating > avg_city_rating;