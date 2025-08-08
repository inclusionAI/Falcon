WITH order_product AS (

SELECT

o.productid,

p.category,

CAST(o.totalamount AS DOUBLE) AS totalamount

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

INNER JOIN

ant_icube_dev.di_data_cleaning_for_customer_database_e_products p

ON

o.productid = p.productid

),



category_avg_amount AS (

SELECT

category,

AVG(totalamount) AS avg_amount

FROM

order_product

GROUP BY

category

HAVING

AVG(totalamount) > 200

),



product_order_count AS (

SELECT

p.category,

o.productid,

COUNT(*) AS order_cnt

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

INNER JOIN

ant_icube_dev.di_data_cleaning_for_customer_database_e_products p

ON

o.productid = p.productid

GROUP BY

p.category,

o.productid

),



ranked_products AS (

SELECT

category,

productid,

order_cnt,

RANK() OVER (

PARTITION BY category

ORDER BY order_cnt DESC

) AS rnk  -- 将rn改为rnk避免关键字冲突

FROM

product_order_count

)



SELECT

r.category AS `category`,

r.productid AS `productid`,

r.order_cnt AS `order_count`

FROM

ranked_products r

INNER JOIN

category_avg_amount c

ON

r.category = c.category

WHERE

r.rnk = 1;  -- 使用rnk=1获取所有并列第一的产品