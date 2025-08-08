WITH toronto_indexes AS 
(
    SELECT  index
    FROM    ant_icube_dev.stock_exchange_index_info
    WHERE   currency = 'CAD'
)
--两个表关联后的多伦多的每日的交易量
,joined_data AS 
(
    SELECT  d.date
            ,d.volume
    FROM    ant_icube_dev.stock_exchange_index_data d
    INNER JOIN toronto_indexes i
    ON      d.index = i.index
)
,date_converted AS 
(
    SELECT  YEAR(TO_DATE(date)) AS year
            ,volume
    FROM    joined_data
)

,aggregated AS 
(
    SELECT  year
            ,COUNT(*) AS total_days
            ,SUM(CASE    WHEN CAST(volume AS BIGINT) > 1000000000 THEN 1 ELSE 0 END) AS high_volume_days
    FROM    date_converted
    GROUP BY year
)

SELECT  year AS `年份`
        ,CASE   WHEN total_days = 0 THEN 0.0
                ELSE ROUND((high_volume_days) / total_days,2)
        END AS `占比`
        ,RANK() OVER (ORDER BY (high_volume_days) / total_days DESC ) AS `排名`
FROM    aggregated
ORDER BY `年份`
;