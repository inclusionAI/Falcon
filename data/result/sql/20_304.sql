with ny_rides as (
select
driver_id
from
ant_icube_dev.city_ride_data_rides
where
city = 'New York'
),
active_high_rating_drivers as (
select
driver_id,
average_rating
from
ant_icube_dev.city_ride_data_drivers
where
active_status = 'Active'
and cast(average_rating as double) > 4.5
)
select
a.driver_id as `driver_id`,
count(r.driver_id) as `ride_count`
from
active_high_rating_drivers a
inner join ny_rides r on a.driver_id = r.driver_id
group by
a.driver_id,
a.average_rating;