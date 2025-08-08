with active_drivers as (

select

driver_id,

city

from

ant_icube_dev.city_ride_data_drivers

where

active_status = 'Active'

),

city_ride_data as (

select

r.distance_km,

r.fare,

r.driver_id,

r.date,

d.city

from

ant_icube_dev.city_ride_data_rides r

inner join active_drivers d on

r.driver_id = d.driver_id

),

city_summary as (

select

city,

sum(cast(distance_km as double)) as `总行驶里程`,

avg(cast(fare as double)) as `平均费用`

from

city_ride_data

group by

city

),

driver_metrics as (

select

driver_id,

city,

sum(cast(distance_km as double)) as total_km,

sum(cast(fare as double)) as total_fare,

count(distinct to_date(date, 'MM/dd/yyyy')) as active_days

from

city_ride_data

group by

driver_id,

city

),

qualified_drivers as (

select

city,

total_fare / active_days as `日均收入`

from

driver_metrics

where

total_km > 200

)

select

cs.city as `城市`,

cs.`总行驶里程`,

cs.`平均费用`,

avg(qd.`日均收入`) as `日均收入`

from

city_summary cs

left join qualified_drivers qd on

cs.city = qd.city

group by

cs.city,

cs.`总行驶里程`,

cs.`平均费用`;