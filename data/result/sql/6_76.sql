WITH category_avg AS
(
    SELECT  category
            ,AVG(CAST(profit AS DOUBLE)) AS avg_profit
    FROM    ant_icube_dev.di_sales_dataset
    GROUP BY category
)
SELECT  a.order_id      AS `order_id`
        ,a.category     AS `category`
        ,a.amount       AS `amount`
        ,a.city         AS `city`
        ,a.customername AS `customername`
        ,a.order_date   AS `order_date`
        ,a.paymentmode  AS `paymentmode`
        ,a.profit       AS `profit`
        ,a.quantity     AS `quantity`
        ,a.state        AS `state`
        ,a.sub_category AS `sub_category`
        ,a.year_month   AS `year_month`
FROM    ant_icube_dev.di_sales_dataset a
JOIN    category_avg b
ON      a.category = b.category
WHERE   CAST(a.profit AS DOUBLE) > b.avg_profit + 3000;