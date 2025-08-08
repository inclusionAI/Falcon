WITH 
-- 计算每个商店类型的平均每周销售额
avg_sales AS (
    SELECT 
        s.type, 
        AVG(CAST(ws.weekly_sales AS DOUBLE)) AS avg_weekly_sales
    FROM 
        ant_icube_dev.walmart_sales ws
    JOIN 
        ant_icube_dev.walmart_stores s 
        ON ws.store = s.store
    GROUP BY 
        s.type
),
-- 获取带有商店类型的销售明细数据
sales_with_type AS (
    SELECT 
        ws.date,
        ws.dept,
        ws.isholiday,
        ws.store,
        ws.weekly_sales,
        s.type
    FROM 
        ant_icube_dev.walmart_sales ws
    JOIN 
        ant_icube_dev.walmart_stores s 
        ON ws.store = s.store
)
-- 筛选出销售额超过类型平均值的记录
SELECT 
    swt.date AS `date`,
    swt.dept AS `dept`,
    swt.isholiday AS `isholiday`,
    swt.store AS `store`,
    swt.weekly_sales AS `weekly_sales`,
    swt.type AS `type`
FROM 
    sales_with_type swt
JOIN 
    avg_sales a 
    ON swt.type = a.type
WHERE 
    CAST(swt.weekly_sales AS DOUBLE) > a.avg_weekly_sales;