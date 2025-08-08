WITH data_with_quarter AS 
(
    SELECT  index
            ,CONCAT(SUBSTR(date,1,4),'-Q',ceil(CAST(SUBSTR(date,6,2) AS INT) / 3)) AS quarter
            ,CAST(high AS DOUBLE) AS high
            ,CAST(low AS DOUBLE) AS low
    FROM    ant_icube_dev.stock_exchange_index_data
)
,index_amplitude AS 
(
    SELECT  index
            ,quarter
            ,MAX(high) - MIN(low) AS amplitude
    FROM    data_with_quarter
    GROUP BY index
             ,quarter
)
SELECT  info.exchange AS `exchange`
        ,ia.quarter AS `quarter`
        ,AVG(ia.amplitude) AS `avg_amplitude`
FROM    index_amplitude ia
JOIN    ant_icube_dev.stock_exchange_index_info info
ON      ia.index = info.index
GROUP BY info.exchange
         ,ia.quarter
;