WITH los_angeles_drivers AS (
    SELECT
        driver_id,
        experience_years
    FROM
        ant_icube_dev.city_ride_data_drivers
    WHERE
        city = 'Los Angeles'
),
driver_stats AS (
    SELECT
        r.driver_id,
        AVG(CAST(r.fare AS DOUBLE)) AS avg_fare
    FROM
        ant_icube_dev.city_ride_data_rides r
        INNER JOIN los_angeles_drivers d ON r.driver_id = d.driver_id
    GROUP BY
        r.driver_id
    HAVING
        COUNT(*) > 10
)
SELECT
    DISTINCT r.driver_id AS `driver_id`,
    r.ride_id AS `ride_id`,
    d.experience_years AS `驾龄`,
    s.avg_fare AS `平均费用`
FROM
    ant_icube_dev.city_ride_data_rides r
    INNER JOIN los_angeles_drivers d ON r.driver_id = d.driver_id
    INNER JOIN driver_stats s ON r.driver_id = s.driver_id
WHERE
    d.driver_id = r.driver_id -- 进一步确保只选择洛杉矶司机的行程
ORDER BY
    d.experience_years ASC; -- 按经验年限排序