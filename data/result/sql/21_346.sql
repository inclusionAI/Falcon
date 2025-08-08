WITH user_registration AS (
  SELECT 
    customerid,
    -- 注册年份转换日期格式为年份
    YEAR(TO_DATE(signupdate)) AS reg_year
  FROM ant_icube_dev.di_data_cleaning_for_customer_database_e_customers
),
filtered_orders AS (
  SELECT 
    o.customerid,
    o.orderstatus,
    TO_DATE(o.orderdate) AS order_date
  FROM ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o
  WHERE 
    TO_DATE(o.orderdate) >= '2020-01-01'  -- 仅限2020年及之后的订单
),
order_analysis AS (
  SELECT 
    u.reg_year,
    f.orderstatus,
    f.order_date,
    YEAR(f.order_date) AS order_year
  FROM filtered_orders f
  JOIN user_registration u 
    ON f.customerid = u.customerid
),
status_distribution AS (
  SELECT 
    reg_year AS `注册年份`,
    orderstatus AS `订单状态`,
    COUNT(*) AS `订单数量`,
    -- 添加状态占比计算
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY reg_year), 2) AS `状态占比(%)`
  FROM order_analysis
  GROUP BY reg_year, orderstatus
)
SELECT 
  `注册年份`,
  `订单状态`,
  `订单数量`,
  -- 添加年份订单总量
  SUM(`订单数量`) OVER(PARTITION BY `注册年份`) AS `年订单总量`
FROM status_distribution
ORDER BY `注册年份` ASC, `订单数量` DESC;