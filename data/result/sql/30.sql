WITH daily_prices AS
(
    SELECT  company,
            cast(cast(date as timestamp) as date) as trade_date
            ,CAST(open AS DOUBLE)         AS open_price
            ,CAST(close AS DOUBLE)       AS close_price
    FROM    ant_icube_dev.di_massive_yahoo_finance_dataset
)
,daily_changes AS
(
    SELECT  company
            ,trade_date
            ,(close_price - open_price) / close_price * 100 AS increase_percent
    FROM    daily_prices
)

SELECT  company           AS `company`
        ,increase_percent AS `涨幅值`,
        trade_date as `date`
FROM    daily_changes
WHERE   increase_percent > 20;