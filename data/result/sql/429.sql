WITH sales_by_category_payment AS (

SELECT

p.category,

o.payment_method,

SUM(CAST(oi.quantity AS DOUBLE) * CAST(oi.unit_price AS DOUBLE)) AS sales

FROM

ant_icube_dev.blinkit_order_items oi

JOIN

ant_icube_dev.blinkit_orders o ON oi.order_id = o.order_id

JOIN

ant_icube_dev.blinkit_products p ON oi.product_id = p.product_id

GROUP BY

p.category, o.payment_method

),

category_avg AS (

SELECT

category,

AVG(sales) AS avg_sales

FROM

sales_by_category_payment

GROUP BY

category

)

SELECT

scp.category AS `品类`,

scp.payment_method AS `支付方式`,

scp.sales AS `销售额`,

ca.avg_sales AS `品类平均销售额`

FROM

sales_by_category_payment scp

JOIN

category_avg ca ON scp.category = ca.category;