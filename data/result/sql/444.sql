WITH product_return_summary AS (

SELECT

TRIM(productkey) AS productkey,

SUM(CAST(TRIM(returnquantity) AS INT)) AS total_return

FROM

ant_icube_dev.tech_sales_product_returns

GROUP BY

TRIM(productkey)

),

avg_return AS (

SELECT

AVG(total_return) AS avg_total_return

FROM

product_return_summary

),

high_return_products AS (

SELECT

productkey

FROM

product_return_summary

WHERE

total_return > (SELECT avg_total_return FROM avg_return)  -- 直接使用子查询而非 CTE

),

product_subcategory_mapping AS (

SELECT

TRIM(pl.productkey) AS productkey,

TRIM(pl.productsubcategorykey) AS productsubcategorykey,

CAST(TRIM(pl.productprice) AS DOUBLE) AS productprice

FROM

ant_icube_dev.tech_sales_product_lookup pl

WHERE

TRIM(pl.productkey) IN (SELECT productkey FROM high_return_products)

),

joined_subcategories AS (

SELECT

psm.productkey,

TRIM(ps.subcategoryname) AS subcategoryname,

TRIM(ps.productcategorykey) AS productcategorykey,

psm.productprice

FROM

product_subcategory_mapping psm

JOIN

ant_icube_dev.tech_sales_product_subcategories ps ON TRIM(psm.productsubcategorykey) = TRIM(ps.productsubcategorykey)

),

joined_categories AS (

SELECT

js.subcategoryname,

TRIM(pc.categoryname) AS categoryname,

js.productprice

FROM

joined_subcategories js

JOIN

ant_icube_dev.tech_sales_product_categories pc ON TRIM(js.productcategorykey) = TRIM(pc.productcategorykey)

)



SELECT

subcategoryname AS `子类别名称`,

categoryname AS `类别名称`,

AVG(productprice) AS `平均售价`

FROM

joined_categories

GROUP BY

subcategoryname,

categoryname;