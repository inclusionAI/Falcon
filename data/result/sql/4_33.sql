WITH electronic_customers AS
(
    -- 筛选无纸化账单客户并转换结算天数为数值类型
    SELECT  CAST(daystosettle AS INT) AS days_to_settle
    FROM    ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
    WHERE   paperlessbill = 'Electronic'
),
max_settlement AS
(
    -- 计算无纸化客户最大结算天数
    SELECT  MAX(days_to_settle) AS max_days
    FROM    electronic_customers
),
overall_stats AS
(
    -- 计算整体客户结算天数平均值
    SELECT  AVG(CAST(daystosettle AS INT)) AS avg_days
    FROM    ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
)
-- 使用标量子查询代替 CROSS JOIN
SELECT
    (SELECT max_days FROM max_settlement) - (SELECT avg_days FROM overall_stats) AS `差异值`;