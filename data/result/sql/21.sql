WITH filtered_data AS 
(
    SELECT  SUBSTR(date,1,10) AS temp_day
            ,volume
    FROM    ant_icube_dev.di_massive_yahoo_finance_dataset
    WHERE   company = 'MSFT'
    AND     SUBSTR(date,1,4) = '2018'
)
,ranked_data AS 
(
    SELECT  temp_day
            ,volume
            ,ROW_NUMBER() OVER (ORDER BY temp_day DESC ) AS rank_num
    FROM    filtered_data
)
SELECT  temp_day AS `date`
        ,SUM(volume) AS `volume`
FROM    ranked_data
WHERE   rank_num <= 10
GROUP BY temp_day
ORDER BY date
;