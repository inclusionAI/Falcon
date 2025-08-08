WITH durable_products AS (

SELECT

productid,

CAST(price AS DOUBLE) AS price,

productname,

resistant

FROM

ant_icube_dev.grocery_sales_products

WHERE

resistant = 'Durable'

),

product_avg AS (

SELECT

AVG(price) AS avg_price

FROM

durable_products

)

SELECT

p.productid AS `产品ID`,

p.productname AS `产品名称`,

p.price AS `价格`

FROM

durable_products p

WHERE

p.price > (SELECT avg_price FROM product_avg);