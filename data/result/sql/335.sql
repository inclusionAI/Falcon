WITH zero_stock_products AS (

-- 筛选出库存为零的商品记录

SELECT

category,

productid

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_products

WHERE

CAST(stockquantity AS INT) = 0

),

category_statistics AS (

-- 按商品类别统计库存为零的商品数量

SELECT

category,

COUNT(*) AS `zero_stock_count`

FROM

zero_stock_products

GROUP BY

category

),

ranked_categories AS (

-- 为每个类别的零库存商品数量进行排名

SELECT

category,

`zero_stock_count`,

RANK() OVER (ORDER BY `zero_stock_count` DESC) AS `rank`

FROM

category_statistics

)

-- 最终选择零库存商品数量最多的类别，包括并列情况

SELECT

category AS `商品类别`

FROM

ranked_categories

WHERE

`rank` = 1  -- 选择排名第一的类别，包括并列情况