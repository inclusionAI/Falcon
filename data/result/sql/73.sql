WITH filtered_data AS
(
    SELECT  paymentmode
            ,CAST(amount AS DOUBLE) AS amount
    FROM    ant_icube_dev.di_sales_dataset
    WHERE   state = 'New York'
)
SELECT  paymentmode  AS `支付方式`
        ,AVG(amount) AS `平均订单金额`
FROM    filtered_data
GROUP BY paymentmode
HAVING  AVG(amount) > 500
ORDER BY paymentmode;