WITH sales_with_category AS (
  SELECT
    -- 使用标准TO_DATE转换格式为MM/dd/yyyy
    TO_DATE(s.orderdate, 'MM/dd/yyyy') AS order_date, 
    CAST(pl.productprice AS DOUBLE) * CAST(s.orderquantity AS DOUBLE) AS sales_amount,
    pc.categoryname
  FROM
    ant_icube_dev.tech_sales_sales_data s
    JOIN ant_icube_dev.tech_sales_product_lookup pl 
      ON s.productkey = pl.productkey
    JOIN ant_icube_dev.tech_sales_product_subcategories ps 
      ON pl.productsubcategorykey = ps.productsubcategorykey
    JOIN ant_icube_dev.tech_sales_product_categories pc 
      ON ps.productcategorykey = pc.productcategorykey
  -- 修复格式字符串错误：使用'MM/dd/yyyy'而非'/dd/yyyy'
  WHERE
    YEAR(TO_DATE(s.orderdate, 'MM/dd/yyyy')) = 2022 -- 只取2022年数据
    AND MONTH(TO_DATE(s.orderdate, 'MM/dd/yyyy')) IN (4,5) -- 只取4、5月数据
),

monthly_sales AS (
  SELECT
    categoryname,
    -- 使用简单字符串截取替代日期函数
    SUBSTR(CAST(order_date AS STRING), 1, 7) AS year_month,  
    SUM(sales_amount) AS total_sales
  FROM sales_with_category
  GROUP BY categoryname, SUBSTR(CAST(order_date AS STRING), 1, 7)
),

filtered_data AS (
  SELECT
    categoryname,
    year_month,
    total_sales,
    LAG(total_sales) OVER (
      PARTITION BY categoryname 
      ORDER BY year_month
    ) AS prev_sales
  FROM monthly_sales
  -- 确保只取2022年4月和5月的数据
  WHERE year_month IN ('2022-04', '2022-05')
),

growth_rates AS (
  SELECT
    categoryname,
    year_month,
    total_sales,
    prev_sales,
    -- 增强空值处理
    CASE 
      WHEN COALESCE(prev_sales, 0) = 0 THEN 0  -- 处理空值或零值
      ELSE (total_sales - prev_sales) / prev_sales 
    END AS growth_rate
  FROM filtered_data
  WHERE year_month = '2022-05' -- 只取5月数据进行比较
)

SELECT
  categoryname AS `产品类别`,
  growth_rate AS `2022年5月环比增长率`
FROM (
  SELECT
    categoryname,
    growth_rate,
    -- 处理并列情况
    DENSE_RANK() OVER (ORDER BY growth_rate DESC) AS rnk
  FROM growth_rates
  WHERE growth_rate IS NOT NULL -- 排除无效值
) ranked
WHERE rnk = 1; -- 取出所有并列第一的类别