WITH monthly_data AS (
    SELECT 
        company,
        SUBSTR(date, 1, 7) AS `month`,
        CAST(close AS DOUBLE) AS close
    FROM ant_icube_dev.di_massive_yahoo_finance_dataset
    WHERE SUBSTR(date, 1, 4) = '2018'
),
avg_calculation AS (
    SELECT 
        company,
        `month`,
        AVG(close) AS `avg_close`
    FROM monthly_data
    GROUP BY company, `month`
)
SELECT 
    company AS `company`,
    `month` AS `date`,
    `avg_close` AS `月度平均收盘价`
FROM avg_calculation
WHERE `avg_close` > 100
ORDER BY `date`;