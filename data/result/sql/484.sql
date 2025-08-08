WITH completed_orders AS (
    SELECT 
        o.customer_id,
        CAST(p.amount AS DOUBLE) AS order_amount
    FROM 
        ant_icube_dev.online_shop_orders o
    INNER JOIN 
        ant_icube_dev.online_shop_payment p 
        ON o.order_id = p.order_id
    WHERE 
        p.transaction_status = 'Completed'
),
customer_summary AS (
    SELECT 
        customer_id,
        SUM(order_amount) AS total_amount
    FROM 
        completed_orders
    GROUP BY 
        customer_id
    HAVING 
        SUM(order_amount) > 500
)
SELECT 
    customer_id AS `客户id`,
    total_amount AS `总金额`,
    RANK() OVER (ORDER BY total_amount DESC) AS `排名`
FROM 
    customer_summary
ORDER BY 
    `排名`;