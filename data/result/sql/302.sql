with filtered_rides as (

select

driver_id,

fare

from

ant_icube_dev.city_ride_data_rides

where

city = 'San Francisco'

and promo_code = 'SAVE20'

),

joined_data as (

select

fr.driver_id,

cast(fr.fare as double) as fare

from

filtered_rides fr

join

ant_icube_dev.city_ride_data_drivers d

on

fr.driver_id = d.driver_id

),

driver_income as (

select

driver_id,

sum(fare) as total_income

from

joined_data

group by

driver_id

)

select

driver_id as `driver_id`,

total_income as `总收入`

from

driver_income;