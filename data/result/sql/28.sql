WITH daily_data AS
(
    SELECT  company
            ,cast(cast(date as timestamp) as date) as date
            ,CAST(high AS DOUBLE)  AS high
            ,CAST(low AS DOUBLE)   AS low
            ,CAST(close AS DOUBLE) AS close
    FROM    ant_icube_dev.di_massive_yahoo_finance_dataset
    WHERE   high NOT IN ('', 'null')
    AND     low NOT IN ('', 'null')
    AND     close NOT IN ('', 'null')
)
,window_calc AS
(
    SELECT  company
            ,date
            ,(high - low)                                                                                   AS price_diff
            ,AVG(close) OVER (PARTITION BY company ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS avg_30d_close
    FROM    daily_data
)
SELECT  company AS `company`
        ,date   AS `date`
FROM    window_calc
WHERE   price_diff > (
                        avg_30d_close * 0.5
                     )
AND     date IS NOT NULL