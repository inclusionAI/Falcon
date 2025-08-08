WITH total_sales AS
(
    SELECT  store
            ,isholiday
            ,SUM(weekly_sales) AS total_sales
    FROM    ant_icube_dev.walmart_sales
    GROUP BY store
            ,isholiday
)
,avg_temperature AS
(
    SELECT  store
            ,AVG(temperature) AS avg_temperature
            ,isholiday
    FROM    ant_icube_dev.walmart_features
    GROUP BY store
            ,isholiday
)
,join_data AS
(
    SELECT  avg_temperature.store
            ,avg_temperature
            ,total_sales
            ,avg_temperature.isholiday
    FROM    total_sales
    JOIN    avg_temperature
    ON      total_sales.store = avg_temperature.store
    AND     total_sales.isholiday = avg_temperature.isholiday
)
SELECT  store
        ,isholiday
        ,total_sales
        ,avg_temperature
FROM    join_data
WHERE   total_sales > 5000
AND     avg_temperature > 60;