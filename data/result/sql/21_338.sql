WITH stock_zero_products AS (

SELECT

category,

price

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_products

WHERE

CAST(stockquantity AS BIGINT) = 0

),

category_stats AS (

SELECT

category,

COUNT(*) AS zero_stock_count,

AVG(CAST(price AS DOUBLE)) AS avg_price

FROM

stock_zero_products

GROUP BY

category

)

SELECT

category AS `商品类别`,

zero_stock_count AS `库存量为零的商品数量`,

avg_price AS `平均售价`

FROM

category_stats;