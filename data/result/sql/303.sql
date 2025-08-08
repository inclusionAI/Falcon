with chicago_drivers as (

select

active_status,

experience_years

from

ant_icube_dev.city_ride_data_drivers

where

city = 'Chicago'

)



select

active_status as `active_status`,

avg(cast(experience_years as double)) as `average_experience`

from

chicago_drivers

group by

active_status

order by

`average_experience` desc;