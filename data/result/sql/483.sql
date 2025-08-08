WITH category_avg AS (

SELECT

p.categoryid,

AVG(CAST(p.price AS DOUBLE)) AS avg_price

FROM

ant_icube_dev.grocery_sales_products p

INNER JOIN

ant_icube_dev.grocery_sales_categories c

ON

p.categoryid = c.categoryid

GROUP BY

p.categoryid

)

SELECT

c.categoryname AS `产品类别`,

p.productname AS `产品名称`,

CAST(p.price AS DOUBLE) - ca.avg_price AS `价差`

FROM

ant_icube_dev.grocery_sales_products p

INNER JOIN

ant_icube_dev.grocery_sales_categories c

ON

p.categoryid = c.categoryid

INNER JOIN

category_avg ca

ON

p.categoryid = ca.categoryid

WHERE

p.resistant = 'Durable'

AND CAST(p.price AS DOUBLE) > ca.avg_price;