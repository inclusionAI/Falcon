WITH filtered_data AS 
(
    SELECT  date
            ,close
    FROM    ant_icube_dev.di_massive_yahoo_finance_dataset
    WHERE   company = 'AAPL'
    AND     SUBSTR(date,1,4) = '2018'
)
SELECT  SUBSTR(date,1,7) AS `month`
        ,AVG(CAST(close AS DOUBLE)) AS `平均收盘价`
FROM    filtered_data
GROUP BY SUBSTR(date,1,7)
;