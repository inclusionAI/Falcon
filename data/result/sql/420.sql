WITH delivery_data AS (
SELECT
dp.delivery_partner_id,
CAST(dp.delivery_time_minutes AS DOUBLE) AS delivery_time
FROM
ant_icube_dev.blinkit_orders o
INNER JOIN
ant_icube_dev.blinkit_delivery_performance dp
ON
o.order_id = dp.order_id
),
partner_avg AS (
SELECT
delivery_partner_id,
AVG(delivery_time) AS avg_delay
FROM
delivery_data
GROUP BY
delivery_partner_id
),
overall_avg AS (
SELECT
AVG(delivery_time) AS overall_avg
FROM
delivery_data
)
SELECT
delivery_partner_id AS `配送人员ID`,
avg_delay AS `平均延迟时间`
FROM
partner_avg
WHERE
avg_delay > (SELECT overall_avg FROM overall_avg);