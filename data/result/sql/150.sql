WITH youtube_items AS (
    SELECT id
    FROM ant_icube_dev.google_merchandise_items
    WHERE brand = 'YouTube'
),
device_add_to_cart AS (
    SELECT 
        e.device,
        COUNT(*) as cnt
    FROM ant_icube_dev.google_merchandise_events e
    INNER JOIN youtube_items i ON e.item_id = i.id
    WHERE e.type = 'add_to_cart'
    GROUP BY e.device
)
SELECT 
    device as `设备端`,
    cnt as `销售数量`,
    (cnt * 100.0 / SUM(cnt) OVER ()) as `加购物车比例`
FROM device_add_to_cart;