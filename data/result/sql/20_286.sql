WITH filtered_data AS (

SELECT

d.driver_id,

d.experience_years,

CAST(r.fare AS DOUBLE) AS fare

FROM

ant_icube_dev.city_ride_data_drivers d

INNER JOIN

ant_icube_dev.city_ride_data_rides r

ON

d.driver_id = r.driver_id

WHERE

d.city = 'Chicago'

AND r.promo_code IS NOT NULL

AND r.promo_code <> ''

),

driver_avg_fares AS (

SELECT

driver_id,

experience_years,

AVG(fare) AS avg_fare_per_ride  -- 计算每个司机的平均每单收入

FROM

filtered_data

GROUP BY

driver_id, experience_years

),



-- 保留原经验年限组平均计算

group_avg_fares AS (

SELECT

experience_years,

AVG(fare) AS group_avg_fare  -- 每组平均每单收入

FROM

filtered_data

GROUP BY

experience_years

),



-- 保留原排名逻辑

ranked_groups AS (

SELECT

experience_years,

group_avg_fare,

RANK() OVER (ORDER BY group_avg_fare DESC) AS rnk

FROM

group_avg_fares

)



-- 最终结果：展示最高收入组及组内司机的个人收入

SELECT

d.experience_years,

d.avg_fare_per_ride AS driver_avg_fare,  -- 司机个人单均收入

g.group_avg_fare                       -- 所在经验组的平均单均收入

FROM

driver_avg_fares d

JOIN

ranked_groups g

ON d.experience_years = g.experience_years

WHERE

g.rnk = 1  -- 只显示最高收入经验组中的司机

ORDER BY

d.avg_fare_per_ride DESC;  -- 按司机个人收入降序排列