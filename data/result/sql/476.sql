WITH employees_2014 AS (
  SELECT
    employeeid,
    firstname,
    lastname
  FROM
    ant_icube_dev.grocery_sales_employees
  WHERE
    hiredate >= '2014-01-01'  -- 确保日期比较正确
),

allergic_products AS (
  SELECT
    productid,
    price  -- 添加价格字段
  FROM
    ant_icube_dev.grocery_sales_products
  WHERE
    isallergic = 'True'
),

valid_sales_records AS (
  SELECT
    s.salespersonid,
    -- 使用正确的计算方式
    CAST(s.quantity AS DOUBLE) * CAST(p.price AS DOUBLE) AS total_sales
  FROM
    ant_icube_dev.grocery_sales_sales s
    INNER JOIN allergic_products p
      ON s.productid = p.productid
)

SELECT
  e.employeeid AS `employeeid`
FROM
  employees_2014 e
  INNER JOIN valid_sales_records v
    ON e.employeeid = v.salespersonid
GROUP BY
  e.employeeid,
  e.firstname,
  e.lastname
ORDER BY
  `total_sales` DESC;