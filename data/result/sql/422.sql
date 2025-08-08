WITH filtered_customers AS (
SELECT customer_id
FROM ant_icube_dev.blinkit_customers
WHERE SUBSTR(registration_date, 1, 4) = '2023'
),
customer_orders AS (
SELECT
o.customer_id,
SUM(CAST(o.order_total AS DOUBLE)) AS total_spent
FROM ant_icube_dev.blinkit_orders o
JOIN filtered_customers fc ON o.customer_id = fc.customer_id
GROUP BY o.customer_id
),
avg_spent AS (
SELECT AVG(total_spent) AS avg_total
FROM customer_orders
)
SELECT
co.customer_id AS `customer_id`,
co.total_spent AS `total_spent`
FROM customer_orders co
WHERE co.total_spent > (SELECT avg_total FROM avg_spent);