WITH 
-- 计算每个店铺的总销量
sales_summary AS (
    SELECT 
        store_id,
        SUM(CAST(units AS BIGINT)) AS total_sales
    FROM 
        ant_icube_dev.mexico_toy_sales
    GROUP BY 
        store_id
),

-- 计算每个店铺的平均库存量
inventory_avg AS (
    SELECT 
        store_id,
        AVG(CAST(stock_on_hand AS BIGINT)) AS avg_stock
    FROM 
        ant_icube_dev.mexico_toy_inventory
    GROUP BY 
        store_id
)

-- 全连接并输出所有店铺的三个字段
SELECT 
    COALESCE(ss.store_id, ia.store_id) AS store_id,
    COALESCE(ss.total_sales, 0) AS total_sales,  -- 如果无销售记录则显示0
    COALESCE(ia.avg_stock, 0) AS avg_stock       -- 如果无库存记录则显示0
FROM 
    sales_summary ss
FULL JOIN 
    inventory_avg ia ON ss.store_id = ia.store_id
ORDER BY 
    store_id;