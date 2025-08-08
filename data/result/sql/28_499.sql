WITH avg_payment AS (
    SELECT AVG(CAST(amount AS DOUBLE)) AS avg_amount
    FROM ant_icube_dev.online_shop_payment
)
SELECT
    c.customer_id AS `customer_id`,
    SUM(CAST(p.amount AS DOUBLE)) AS `总消费金额`,
    c.email AS `email`,
    c.phone_number AS `phone_number`
FROM
    ant_icube_dev.online_shop_orders o
INNER JOIN
    ant_icube_dev.online_shop_payment p
    ON o.order_id = p.order_id
INNER JOIN
    ant_icube_dev.online_shop_customers c
    ON o.customer_id = c.customer_id
WHERE
    CAST(p.amount AS DOUBLE) > (SELECT avg_amount FROM avg_payment)
GROUP BY
    c.customer_id,
    c.email,
    c.phone_number;