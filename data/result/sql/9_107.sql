WITH filtered_data AS
(
    SELECT  year
            ,code
            ,CAST(broadband_subscription AS DOUBLE) AS broadband
            ,CAST(cellular_subscription AS DOUBLE)  AS cellular
    FROM    ant_icube_dev.di_global_lnternet_users
    WHERE   broadband_subscription IS NOT NULL
    AND     cellular_subscription IS NOT NULL
    AND     broadband_subscription != ''
    AND     cellular_subscription != ''
)
,qualified_countries AS
(
    SELECT  year
            ,code
    FROM    filtered_data
    WHERE   cellular > broadband * 1.1
)
SELECT  year                  AS `year`
        ,COUNT(DISTINCT code) AS `country_count`
FROM    qualified_countries
GROUP BY year;