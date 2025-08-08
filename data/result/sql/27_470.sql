WITH sales_city AS (
SELECT
ci.cityname
FROM
ant_icube_dev.grocery_sales_sales s
JOIN ant_icube_dev.grocery_sales_customers c ON s.customerid = c.customerid
JOIN ant_icube_dev.grocery_sales_cities ci ON c.cityid = ci.cityid
)
SELECT
cityname AS `cityname`,
COUNT(*) AS `购买频次`
FROM
sales_city
GROUP BY
cityname
ORDER BY
`购买频次` DESC;