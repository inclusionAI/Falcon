WITH profit_calculation AS (
  SELECT 
    customername,
    -- 解析带时区的时间戳（参考图片格式）
    TO_TIMESTAMP(order_date, 'yyyy-MM-dd HH:mm:ssXXX') AS order_timestamp,
    CAST(profit AS DOUBLE) AS profit_num,
    CAST(amount AS DOUBLE) AS amount_num,
    order_id,
    -- 关键性能优化：提前过滤无效数据
    CAST(profit AS DOUBLE) / NULLIF(CAST(amount AS DOUBLE), 0) AS profit_ratio
  FROM ant_icube_dev.di_sales_dataset
  WHERE amount IS NOT NULL 
    AND amount > 0  -- 确保可计算利润率
),
filtered_records AS (
  SELECT 
    *,
    -- 全局利润率排名（从高到低）
    DENSE_RANK() OVER(ORDER BY profit_ratio DESC) AS profit_rank
  FROM profit_calculation
  WHERE profit_ratio > 0.45  -- 关键筛选条件（>50%）
)
SELECT
  customername AS `客户名称`,
  order_id AS `订单ID`
FROM filtered_records
ORDER BY profit_rank;