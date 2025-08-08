WITH monthly_profit AS
(
    SELECT  paymentmode
            ,year_month
            ,SUM(CAST(profit AS DOUBLE)) AS total_profit
    FROM    ant_icube_dev.di_sales_dataset
    GROUP BY paymentmode
            ,year_month
)
,rank_data AS
(
    SELECT  paymentmode
            ,year_month
            ,total_profit
            ,RANK() OVER (PARTITION BY year_month ORDER BY total_profit DESC) AS profit_rank
    FROM    monthly_profit
)
,avg_profit AS
(
    SELECT  paymentmode
            ,AVG(total_profit) AS avg_monthly_profit
    FROM    monthly_profit
    GROUP BY paymentmode
)
SELECT  r.paymentmode         AS `支付方式`
        ,r.year_month         AS `年月`
        ,r.total_profit       AS `总利润`
        ,r.profit_rank        AS `利润排名`
        ,a.avg_monthly_profit AS `月均利润`
FROM    rank_data r
INNER JOIN  avg_profit a
ON      r.paymentmode = a.paymentmode
ORDER BY r.year_month
        ,r.profit_rank;