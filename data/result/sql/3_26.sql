WITH daily_prices AS
(
    SELECT  company
            ,date
            ,CAST(close AS DOUBLE) AS `close_price`
    FROM    ant_icube_dev.di_massive_yahoo_finance_dataset
)
,moving_avg AS
(
    SELECT  company
            ,date
            ,`close_price`
            ,AVG(`close_price`) OVER (PARTITION BY company ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS `avg_30d`
    FROM    daily_prices
)
SELECT  date
        ,company
        ,`close_price`
        ,`avg_30d`
FROM    moving_avg
WHERE   `close_price` > `avg_30d` * 1.5;