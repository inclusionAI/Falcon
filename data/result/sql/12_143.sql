-- Step 1: 连接用户、事件和商品表，过滤购买事件并计算消费金额
WITH user_purchases AS (
    SELECT
        e.user_id AS user_id,
        CAST(i.price_in_usd AS DOUBLE) AS price
    FROM
        ant_icube_dev.google_merchandise_events e
    JOIN ant_icube_dev.google_merchandise_users u
        ON e.user_id = u.id
    JOIN ant_icube_dev.google_merchandise_items i
        ON e.item_id = i.id
    WHERE
        e.type = 'purchase' AND e.country = 'US'
),

-- Step 2: 计算每个用户的购买次数和总消费金额
user_summary AS (
    SELECT
        user_id,
        COUNT(*) AS purchase_count,
        SUM(price) AS total_spent
    FROM
        user_purchases
    GROUP BY
        user_id
    HAVING
        COUNT(*) > 1
),

-- Step 3: 计算美国用户的总消费金额
total_spent_all AS (
    SELECT
        SUM(price) AS total_all
    FROM
        user_purchases
)

-- Step 4: 最终结果集
SELECT
    us.user_id,
    us.purchase_count AS 购买次数,
    us.total_spent AS 总消费金额,
    ROUND(us.total_spent / (SELECT total_all FROM total_spent_all), 4) AS 消费占比
FROM
    user_summary us