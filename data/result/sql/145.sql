WITH 
-- 步骤1: 筛选高价值用户（LTV>50）
high_value_users AS (
    SELECT 
        id
    FROM 
        ant_icube_dev.google_merchandise_users
    WHERE 
        CAST(ltv AS DOUBLE) > 50
),

-- 步骤2: 关联用户事件和商品信息
event_details AS (
    SELECT 
        e.device,
        CAST(i.price_in_usd AS DOUBLE) AS price
    FROM 
        ant_icube_dev.google_merchandise_events e
    JOIN 
        high_value_users u 
        ON e.user_id = u.id
    JOIN 
        ant_icube_dev.google_merchandise_items i 
        ON e.item_id = i.id
    WHERE 
        e.type = 'purchase'
)

-- 步骤3: 计算不同设备的总销售额
SELECT 
    device AS `设备`,
    SUM(price) AS `客单价`
FROM 
    event_details -- 直接使用步骤2的结果
GROUP BY 
    device;