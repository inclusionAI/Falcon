with latest_rides as (
select
driver_id,
max(to_date(date, 'MM/dd/yyyy')) as latest_date
from
ant_icube_dev.city_ride_data_rides
group by
driver_id
),
promo_rides as (
select
r.driver_id,
sum(cast(r.distance_km as double)) as total_distance
from
ant_icube_dev.city_ride_data_rides r
inner join latest_rides lr
on r.driver_id = lr.driver_id
and to_date(r.date, 'MM/dd/yyyy') = lr.latest_date
where
promo_code is not null
and promo_code <> ''
group by
r.driver_id
having
sum(cast(r.distance_km as double)) > 20
)
select
d.driver_id as `driver_id`,
d.name as `name`
from
ant_icube_dev.city_ride_data_drivers d
inner join promo_rides pr
on d.driver_id = pr.driver_id;