WITH weak_products AS (
SELECT productid, categoryid
FROM ant_icube_dev.grocery_sales_products
WHERE resistant = 'Weak'
),
filtered_sales AS (
SELECT
s.productid,
CAST(s.quantity AS BIGINT) AS quantity,
p.categoryid
FROM ant_icube_dev.grocery_sales_sales s
INNER JOIN weak_products p ON s.productid = p.productid
WHERE
substr(s.salesdate, 1, 7) > '2018-03'
),
aggregated_sales AS (
SELECT
productid,
categoryid,
SUM(quantity) AS total_quantity
FROM filtered_sales
GROUP BY productid, categoryid
HAVING SUM(quantity) > 100
),
ranked_sales AS (
SELECT
productid,
categoryid,
total_quantity,
ROW_NUMBER() OVER (
PARTITION BY categoryid
ORDER BY total_quantity DESC
) AS category_rank
FROM aggregated_sales
)
SELECT
productid AS `productid`,
categoryid AS `categoryid`,
total_quantity AS `total_quantity`,
category_rank AS `category_rank`
FROM ranked_sales
WHERE category_rank <= 5;