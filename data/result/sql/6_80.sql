WITH overall_avg AS
(
    SELECT AVG(CAST(profit AS DOUBLE)) AS avg_profit
    FROM ant_icube_dev.di_sales_dataset
),
payment_stats AS
(
    SELECT paymentmode,
           AVG(CAST(profit AS DOUBLE)) AS payment_avg,
           COUNT(order_id) AS total_orders
    FROM ant_icube_dev.di_sales_dataset
    GROUP BY paymentmode
)
SELECT paymentmode AS `支付方式`
FROM payment_stats
WHERE payment_avg > (SELECT avg_profit FROM overall_avg)
AND total_orders > 50;