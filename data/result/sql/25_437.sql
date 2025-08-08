WITH sales_in_asia AS (
  SELECT
    s.productkey,
    s.orderquantity
  FROM
    ant_icube_dev.tech_sales_sales_data s
    INNER JOIN ant_icube_dev.tech_sales_customer_lookup c
      ON s.customerkey = c.customer_id
  WHERE
    c.city IN ('Sumgait', 'Shirvan', 'Baku')
),

mobile_accessories AS (
  SELECT
    productkey,
    modelname
  FROM
    ant_icube_dev.tech_sales_product_lookup
  WHERE
    LOWER(productname) LIKE '%charger%'
),

combined_data AS (
  SELECT
    sa.orderquantity,
    ma.modelname
  FROM
    sales_in_asia sa
    INNER JOIN mobile_accessories ma
      ON sa.productkey = ma.productkey
),

sales_total AS (
  SELECT
    modelname AS modelname,
    SUM(CAST(TRIM(orderquantity) AS INT)) AS total_sales
  FROM
    combined_data
  GROUP BY
    modelname
),

ranked_models AS (
  SELECT
    modelname,
    total_sales,
    -- 使用DENSE_RANK确保并列情况正确处理
    DENSE_RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
  FROM
    sales_total
)

SELECT
  modelname AS `modelname`
FROM
  ranked_models
WHERE
  sales_rank <= 3  -- 获取所有前三名（包括并列）
ORDER BY
  sales_rank,
  total_sales DESC,
  modelname;  -- 添加modelname排序使并列项有序显示