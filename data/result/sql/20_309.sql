WITH filtered_rides AS (

SELECT

city,

ride_id,

distance_km,

promo_code,

fare

FROM

ant_icube_dev.city_ride_data_rides

WHERE

promo_code IS NOT NULL

AND promo_code <> ''

),



ranked_rides AS (

SELECT

city,

ride_id,

distance_km,

promo_code,

fare,

-- 改为RANK处理并列里程情况

RANK() OVER (

PARTITION BY city

ORDER BY CAST(distance_km AS DOUBLE) DESC

) AS rank

FROM

filtered_rides

)



SELECT

city AS `城市`,

ride_id AS `订单id`

FROM

ranked_rides

WHERE

rank <= 3;  -- 获取每个城市里程排名前三的行程（含并列）