SELECT 
    COUNT(*) AS `天数`
FROM ant_icube_dev.di_massive_yahoo_finance_dataset
WHERE 
    company = 'AAPL'
    AND SUBSTR(date, 1, 4) = '2018'
    AND CAST(close AS DOUBLE) > CAST(open AS DOUBLE);