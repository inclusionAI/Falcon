with ny_rides as (
    select
        driver_id,
        distance_km,
        fare
    from
        ant_icube_dev.city_ride_data_rides
    where
        city = 'New York'
),
driver_stats as (
    select
        driver_id,
        sum(cast(distance_km as double)) as sum_distance,
        sum(cast(fare as double)) as total_fare
    from
        ny_rides
    group by
        driver_id
),
ranked_drivers as (
    select
        driver_id,
        sum_distance,
        total_fare,
        row_number() over (
            order by
                sum_distance desc
        ) as rn,
        count(*) over () as total_count
    from
        driver_stats
)
select
    driver_id as `driver_id`,
    sum_distance,
    total_fare
from
    ranked_drivers
where
    rn <= ceil(total_count * 0.1)
    and total_fare < 500;