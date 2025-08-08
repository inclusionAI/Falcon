WITH tsla_data AS (
    SELECT 
         SUBSTR(date,1,10) AS  temp_day,
        close,
        CAST(high AS DOUBLE) AS high_num,
        CAST(low AS DOUBLE) AS low_num
    FROM ant_icube_dev.di_massive_yahoo_finance_dataset
    WHERE company = 'TSLA'
)
SELECT 
    temp_day AS `date`,
    close AS `close`
FROM tsla_data
WHERE high_num - low_num > 10
ORDER BY temp_day DESC;