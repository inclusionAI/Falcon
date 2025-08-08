WITH commercial_stores AS (
    SELECT store_id
    FROM ant_icube_dev.mexico_toy_stores
    WHERE store_location = 'Commercial'
),

-- 关联库存表并聚合库存量
inventory_aggregation AS (
    SELECT 
        i.product_id,
        SUM(CAST(i.stock_on_hand AS BIGINT)) AS total_stock
    FROM ant_icube_dev.mexico_toy_inventory i
    INNER JOIN commercial_stores cs 
        ON i.store_id = cs.store_id
    GROUP BY i.product_id
),

-- 关联商品表获取商品信息
product_details AS (
    SELECT 
        p.product_id,
        p.product_name
    FROM ant_icube_dev.mexico_toy_products p
)

-- 最终查询并取TOP10
SELECT 
    pd.product_name AS `product_name`,
    ia.total_stock AS `stock_on_hand`
FROM inventory_aggregation ia
INNER JOIN product_details pd 
    ON ia.product_id = pd.product_id
ORDER BY ia.total_stock DESC
LIMIT 10;