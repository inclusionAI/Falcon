WITH yearly_profit AS
(
    SELECT  SUBSTR(order_date, 1, 4)     AS `年份`
            ,SUM(CAST(profit AS BIGINT)) AS `总利润`
    FROM    ant_icube_dev.di_sales_dataset
    WHERE   city = 'Los Angeles'
    GROUP BY SUBSTR(order_date, 1, 4)
)
SELECT  `年份`
        ,`总利润`
FROM    yearly_profit
WHERE   `总利润` > 5000
ORDER BY `年份`;