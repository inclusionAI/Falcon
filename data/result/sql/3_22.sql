WITH daily_diff AS (
    SELECT 
        SUBSTR(date,1,10) AS temp_day,
        (CAST(high AS DOUBLE) - CAST(low AS DOUBLE)) AS diff
    FROM ant_icube_dev.di_massive_yahoo_finance_dataset
    WHERE company = 'TSLA'
),
cumulative_sum AS (
    SELECT 
        temp_day,
        SUM(diff) OVER (ORDER BY temp_day) AS cumulative_diff
    FROM daily_diff
)
SELECT 
    MAX(cumulative_diff) AS `累计差值总和`
FROM cumulative_sum;