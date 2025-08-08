WITH customer_states AS (
    SELECT 
        customer_id,
        trim(split_part(address, ',', 3)) AS `state`
    FROM ant_icube_dev.online_shop_customers
),
joined_data AS (
    SELECT 
        o.order_id,
        o.customer_id,
        p.payment_method,
        p.transaction_status,
        cs.state
    FROM ant_icube_dev.online_shop_orders o
    JOIN ant_icube_dev.online_shop_payment p ON o.order_id = p.order_id
    JOIN customer_states cs ON o.customer_id = cs.customer_id
),
state_stats AS (
    SELECT 
        state,
        SUM(CASE WHEN payment_method = 'Credit Card' AND transaction_status = 'Completed' THEN 1 ELSE 0 END) AS completed_count,
        SUM(CASE WHEN payment_method = 'Credit Card' THEN 1 ELSE 0 END) AS total_attempts
    FROM joined_data
    GROUP BY state
),
overall_stats AS (
    SELECT 
        SUM(CASE WHEN payment_method = 'Credit Card' AND transaction_status = 'Completed' THEN 1 ELSE 0 END) AS overall_completed,
        SUM(CASE WHEN payment_method = 'Credit Card' THEN 1 ELSE 0 END) AS overall_attempts
    FROM joined_data
),
state_comparison AS (
    SELECT 
        state,
        completed_count / total_attempts AS state_success_rate,
        (SELECT overall_completed / overall_attempts FROM overall_stats) AS overall_success_rate
    FROM state_stats
    WHERE total_attempts > 0
),
low_success_states AS (
    SELECT state
    FROM state_comparison
    WHERE state_success_rate < overall_success_rate
)
SELECT DISTINCT c.email
FROM ant_icube_dev.online_shop_customers c
JOIN customer_states cs ON c.customer_id = cs.customer_id
JOIN low_success_states lss ON cs.state = lss.state
join joined_data jd on c.customer_id = jd.customer_id and jd.transaction_status = 'Failed';