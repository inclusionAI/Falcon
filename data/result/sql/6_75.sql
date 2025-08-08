WITH state_avg AS
(
    SELECT  state
            ,AVG(CAST(amount AS DOUBLE)) AS avg_amount
    FROM    ant_icube_dev.di_sales_dataset
    GROUP BY state
)
,order_detail AS
(
    SELECT  a.order_id
            ,a.state
            ,CAST(a.amount AS DOUBLE) AS order_amount
            ,b.avg_amount
    FROM    ant_icube_dev.di_sales_dataset a
    JOIN    state_avg b
    ON      a.state = b.state
)
SELECT  order_id                     AS `order_id`
        ,state                       AS `state`
        ,order_amount                AS `amount`
        ,(order_amount - avg_amount) AS `amount_diff`
FROM    order_detail
WHERE   order_amount > avg_amount;