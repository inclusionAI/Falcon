with city_avg_experience as (

select

city,

avg(cast(experience_years as bigint)) as avg_exp

from

ant_icube_dev.city_ride_data_drivers

group by

city

)

select

d.driver_id as `driver_id`

from

ant_icube_dev.city_ride_data_drivers d

inner join

city_avg_experience c

on

d.city = c.city

where

d.active_status = 'Active'

and cast(d.experience_years as bigint) > c.avg_exp;