WITH high_rated_drivers AS (
    SELECT 
        driver_id,
        name AS driver_name
    FROM ant_icube_dev.city_ride_data_drivers
    WHERE cast(average_rating AS DOUBLE) > 4.5
),
november_2024_rides AS (
    SELECT 
        driver_id,
        COUNT(*) AS ride_count
    FROM ant_icube_dev.city_ride_data_rides
    WHERE 
        -- 使用您的日期格式解析：MM/dd/yyyy
        TO_DATE(date, 'MM/dd/yyyy') BETWEEN 
            TO_DATE('11/01/2024', 'MM/dd/yyyy') AND 
            TO_DATE('11/30/2024', 'MM/dd/yyyy')
    GROUP BY driver_id
),
driver_ride_counts AS (
    SELECT 
        h.driver_name,
        COALESCE(n.ride_count, 0) AS november_rides
    FROM high_rated_drivers h
    LEFT JOIN november_2024_rides n 
        ON h.driver_id = n.driver_id
),
max_rides AS (
    SELECT MAX(november_rides) AS max_count
    FROM driver_ride_counts
)
SELECT 
    driver_name AS `驾驶员姓名`
FROM driver_ride_counts
WHERE november_rides = (SELECT max_count FROM max_rides)
AND november_rides > 0  -- 排除零订单驾驶员
ORDER BY driver_name;