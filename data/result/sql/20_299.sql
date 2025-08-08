WITH chicago_drivers AS (
    SELECT
        driver_id
    FROM
        ant_icube_dev.city_ride_data_drivers
    WHERE
        city = 'Chicago'
),
promo_rides AS (
    SELECT
        rides.driver_id,
        CAST(rides.duration_min AS DOUBLE) AS duration
    FROM
        ant_icube_dev.city_ride_data_rides rides
        INNER JOIN chicago_drivers ON rides.driver_id = chicago_drivers.driver_id
    WHERE
        rides.promo_code IS NOT NULL
        AND rides.promo_code != ''
),
driver_avg_duration AS (
    SELECT
        driver_id,
        AVG(duration) AS avg_duration
    FROM
        promo_rides
    GROUP BY
        driver_id
)
SELECT
    driver_id AS `driver_id`,
    avg_duration AS `平均时长`
FROM
    driver_avg_duration
WHERE
    avg_duration > 50;