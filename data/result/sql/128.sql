WITH daily_data AS 
(
    SELECT  date--每日
            ,index--指数
            ,CAST(volume AS DOUBLE) AS volume--交易量
    FROM    ant_icube_dev.stock_exchange_index_data
    WHERE   SUBSTR(date,1,4) = '2000'
)
,daily_avg AS 
(
    SELECT  date
            ,AVG(volume) * 0.3 AS avg_volume
    FROM    daily_data
    GROUP BY date
)
SELECT  d.date AS `date`
        ,d.index AS `index`
FROM    daily_data d
JOIN    daily_avg a
ON      d.date = a.date
WHERE   d.volume > a.avg_volume 
;