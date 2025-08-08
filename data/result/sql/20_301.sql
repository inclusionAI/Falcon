WITH filtered_drivers AS (
    SELECT
        driver_id,
        experience_years
    FROM
        ant_icube_dev.city_ride_data_drivers
    WHERE
        active_status = 'Active'
        AND city = 'Los Angeles'
),
joined_data AS (
    SELECT
        fd.driver_id,
        fd.experience_years,
        CAST(r.rating AS DOUBLE) AS rating
    FROM
        filtered_drivers fd
        INNER JOIN ant_icube_dev.city_ride_data_rides r ON fd.driver_id = r.driver_id
)
SELECT
    driver_id AS `driver_id`,
    AVG(rating) AS `平均行程评分`
FROM
    joined_data
GROUP BY
    driver_id
ORDER BY
    MAX(experience_years) ASC; -- 按经验年数排序