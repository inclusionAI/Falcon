WITH router_products AS (
    SELECT 
        productkey,
        productname  -- 保留产品名称用于验证
    FROM ant_icube_dev.tech_sales_product_lookup
    WHERE LOWER(productname) LIKE '%router%'  -- 忽略大小写确保匹配
),
valid_sales AS (
    SELECT
        s.customerkey,
        COALESCE(cast(TRIM(s.orderquantity) AS DOUBLE), 0.0) AS qty  -- 安全处理数量值
    FROM ant_icube_dev.tech_sales_sales_data s
    JOIN router_products r ON s.productkey = r.productkey
),
city_orders AS (
    SELECT
        c.city,
        v.qty
    FROM valid_sales v
    JOIN ant_icube_dev.tech_sales_customer_lookup c 
        ON v.customerkey = c.customer_id
    WHERE c.city IS NOT NULL AND c.city != ''  -- 确保城市信息有效
)
SELECT
    city AS `城市`,
    SUM(qty) AS `路由器订单数量`  -- 聚合每个城市的总订单数量
FROM city_orders
GROUP BY city
ORDER BY `路由器订单数量` DESC;  -- 按数量降序排列