WITH order_payments AS (
    SELECT 
        order_id,
        SUM(CAST(payment_value AS DECIMAL)) AS total_payment
    FROM 
        ant_icube_dev.ecommerce_order_payments
    GROUP BY 
        order_id
),
customer_orders AS (
    SELECT 
        o.customer_id,
        c.customer_city,
        op.total_payment
    FROM 
        order_payments op
    JOIN 
        ant_icube_dev.ecommerce_order_orders o 
        ON op.order_id = o.order_id
    JOIN 
        ant_icube_dev.ecommerce_order_customers c 
        ON o.customer_id = c.customer_id
),
city_customer_totals AS (
    SELECT 
        customer_city,
        customer_id,
        SUM(total_payment) AS total_order_amount
    FROM 
        customer_orders
    GROUP BY 
        customer_city,
        customer_id
),
city_averages AS (
    SELECT 
        customer_city,
        AVG(total_order_amount) AS avg_city_amount
    FROM 
        city_customer_totals
    GROUP BY 
        customer_city
)
SELECT 
    cct.customer_id AS `customer_id`,
    cct.customer_city AS `customer_city`,
    cct.total_order_amount AS `total_order_amount`
FROM 
    city_customer_totals cct
JOIN 
    city_averages ca 
    ON cct.customer_city = ca.customer_city
WHERE 
    cct.total_order_amount > ca.avg_city_amount;