WITH active_drivers AS (

SELECT

driver_id,

city

FROM

ant_icube_dev.city_ride_data_drivers

WHERE

active_status = 'Active'

),

joined_data AS (

SELECT

r.fare,

d.city

FROM

ant_icube_dev.city_ride_data_rides r

INNER JOIN

active_drivers d

ON

r.driver_id = d.driver_id

),

ranked_rides AS (

SELECT

city,

fare,

-- 改为RANK处理并列高价行程

RANK() OVER (

PARTITION BY city

ORDER BY CAST(fare AS DOUBLE) DESC

) AS fare_rank

FROM

joined_data

),

top_five AS (

SELECT

city,

CAST(fare AS DOUBLE) AS fare

FROM

ranked_rides

WHERE

fare_rank <= 5  -- 获取每个城市排名前5的高价行程（含并列）

)

SELECT

city AS `城市`

FROM

top_five

GROUP BY

city

HAVING

AVG(fare) > 50;