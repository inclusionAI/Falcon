WITH data_prepared AS
(
    SELECT  company
            ,date
            ,CAST(volume AS BIGINT) AS `volume`
    FROM    ant_icube_dev.di_massive_yahoo_finance_dataset
    WHERE   volume IS NOT NULL
    AND     volume != ''
)
,moving_avg AS
(
    SELECT  company
            ,`date`
            ,`volume`
            ,AVG(`volume`) OVER (PARTITION BY company ORDER BY `date` ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS `avg_30d_volume`
    FROM    data_prepared
)
SELECT  company           AS `company`
        ,`date`           AS `date`
        ,`volume`         AS `volume`
        ,`avg_30d_volume` AS `avg_30d_volume`
FROM    moving_avg
WHERE   `volume` < 0.1 * `avg_30d_volume`