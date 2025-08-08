WITH filtered_data AS 
(
    SELECT  date
            ,index
            ,open
            ,close
            ,volume
    FROM    ant_icube_dev.stock_exchange_index_data
    WHERE   YEAR(TO_DATE(date)) = 2000
    OR      YEAR(TO_DATE(date)) = 2013
    OR      YEAR(TO_DATE(date)) = 2014
)
,converted_data AS 
(
    SELECT  index
            ,CAST(open AS DOUBLE) AS open
            ,CAST(close AS DOUBLE) AS close
            ,CAST(volume AS BIGINT) AS volume_num
    FROM    filtered_data
)
,ranked_data AS 
(
    SELECT  index
            ,open
            ,close
            ,volume_num
            ,ROW_NUMBER() OVER (PARTITION BY index ORDER BY volume_num DESC ) AS rn
    FROM    converted_data
)
SELECT  index AS `index`
        ,SUM(open) AS `open`
        ,SUM(close) AS `close`
        ,(SUM(open) - SUM(close)) AS `diff`
FROM    ranked_data
WHERE   rn = 1
GROUP BY index
;