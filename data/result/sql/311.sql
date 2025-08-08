with

driver_rides as (

select

d.experience_years,

cast(r.distance_km as double) as distance_km

from

ant_icube_dev.city_ride_data_drivers d

inner join ant_icube_dev.city_ride_data_rides r

on d.driver_id = r.driver_id

where

d.city = 'Chicago'

),

experience_avg as (

select

experience_years,

avg(distance_km) as group_avg

from

driver_rides

group by

experience_years

),

city_avg as (

select

avg(distance_km) as city_total_avg

from

driver_rides

)

select

experience_years as `经验年限`,

group_avg as `平均距离`,

case

when group_avg > (select city_total_avg from city_avg) then 'Yes'

else 'No'

end as `是否超过总平均`

from

experience_avg;