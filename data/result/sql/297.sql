WITH filtered_drivers_rides AS (
    SELECT
        r.driver_id,
        r.rating,
        r.distance_km
    FROM
        ant_icube_dev.city_ride_data_drivers d
        JOIN ant_icube_dev.city_ride_data_rides r ON d.driver_id = r.driver_id
    WHERE
        d.city = 'San Francisco'
),
ranked_rides AS (
    SELECT
        driver_id,
        CAST(distance_km AS DOUBLE) AS distance_km,
        RANK() OVER (
            PARTITION BY driver_id
            ORDER BY
                CAST(rating AS DOUBLE) DESC
        ) AS ride_rank
    FROM
        filtered_drivers_rides
),
top3_rides AS (
    SELECT
        driver_id,
        distance_km
    FROM
        ranked_rides
    WHERE
        ride_rank <= 3
),
driver_total_distance AS (
    SELECT
        driver_id,
        SUM(distance_km) AS total_distance
    FROM
        top3_rides
    GROUP BY
        driver_id
    HAVING
        SUM(distance_km) > 100
)
SELECT
    DISTINCT driver_id AS `司机ID`
FROM
    driver_total_distance;