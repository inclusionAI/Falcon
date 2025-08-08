WITH payment_avg AS
(
    SELECT  paymentmode
            ,AVG(CAST(amount AS DOUBLE)) AS avg_amount
    FROM    ant_icube_dev.di_sales_dataset
    GROUP BY paymentmode
)
,high_value_transactions AS
(
    SELECT  a.paymentmode
            ,a.customername
    FROM    ant_icube_dev.di_sales_dataset a
    JOIN    payment_avg b
    ON      a.paymentmode = b.paymentmode
    WHERE   CAST(a.amount AS DOUBLE) > b.avg_amount
)
,customer_count AS
(
    SELECT  paymentmode
            ,COUNT(DISTINCT customername) AS customer_cnt
    FROM    high_value_transactions
    GROUP BY paymentmode
)
SELECT  paymentmode                               AS `paymentmode`
        ,customer_cnt                             AS `customer_count`
FROM    customer_count
ORDER BY customer_cnt DESC;