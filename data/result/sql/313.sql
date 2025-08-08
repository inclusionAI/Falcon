WITH active_drivers AS (

SELECT

driver_id,

city,

CAST(experience_years AS DOUBLE) AS exp_years

FROM

ant_icube_dev.city_ride_data_drivers

WHERE

active_status = 'Active'

),

driver_ratings AS (

SELECT

r.driver_id,

CAST(r.rating AS DOUBLE) AS rt

FROM

ant_icube_dev.city_ride_data_rides r

INNER JOIN

active_drivers d

ON

r.driver_id = d.driver_id

),

city_corr AS (

SELECT

d.city AS `城市`,

CORR(d.exp_years, r.rt) AS `关联系数`

FROM

active_drivers d

INNER JOIN

driver_ratings r

ON

d.driver_id = r.driver_id

GROUP BY

d.city

),

ranked_cities AS (

SELECT

`城市`,

`关联系数`,

RANK() OVER (ORDER BY `关联系数` DESC) AS `排名`

FROM

city_corr

)

SELECT

`城市`,

`关联系数`

FROM

ranked_cities

WHERE

`排名` = 1

ORDER BY

`关联系数` DESC, `城市`;