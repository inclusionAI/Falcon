WITH

-- 关联司机与行程数据，并过滤纽约地区且使用折扣码的记录

joined_data AS (

SELECT

r.ride_id,

r.driver_id,

r.city,

r.promo_code,

CAST(r.rating AS DOUBLE) AS ride_rating,

CAST(d.average_rating AS DOUBLE) AS driver_avg_rating,

CAST(r.fare AS DOUBLE) AS original_fare

FROM

ant_icube_dev.city_ride_data_rides r

INNER JOIN

ant_icube_dev.city_ride_data_drivers d ON r.driver_id = d.driver_id

WHERE

r.city = 'New York'

AND r.promo_code IS NOT NULL

),

-- 筛选评分高于司机平均的行程

filtered_rides AS (

SELECT

ride_id,

promo_code,

original_fare

FROM

joined_data

WHERE

ride_rating > driver_avg_rating

),

-- 根据折扣码类型计算实际支付金额

payment_calculation AS (

SELECT

ride_id,

original_fare * (

CASE

WHEN promo_code = 'SAVE20' THEN 0.8

WHEN promo_code = 'DISCOUNT10' THEN 0.9

WHEN promo_code = 'WELCOME5' THEN 0.95

ELSE 1.0

END

) AS actual_fare

FROM

filtered_rides

),

-- 使用 RANK() 计算支付金额的排名

ranked_payments AS (

SELECT

ride_id,

actual_fare,

RANK() OVER (ORDER BY actual_fare DESC) AS payment_rank

FROM

payment_calculation

)



-- 输出支付金额最高的前五单

SELECT

ride_id AS `ride_id`,

actual_fare AS `实际支付金额`

FROM

ranked_payments

WHERE

payment_rank <= 5  -- 只选择前五个排名

ORDER BY

actual_fare DESC;  -- 可选，对最终结果按实际支付金额高到低排序