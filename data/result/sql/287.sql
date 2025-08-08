with active_drivers as (

select

driver_id,

city,

average_rating

from

ant_icube_dev.city_ride_data_drivers

where

active_status = 'Active'

),

driver_ride_counts as (

select

d.driver_id,

d.city,

d.average_rating,

count(r.driver_id) as rides_count

from

active_drivers d

left join

ant_icube_dev.city_ride_data_rides r

on

d.driver_id = r.driver_id

group by

d.driver_id, d.city, d.average_rating

)

select

city as `城市`,

avg(rides_count) as `平均行程次数`,

avg(cast(average_rating as double)) as `平均评分`

from

driver_ride_counts

group by

city;