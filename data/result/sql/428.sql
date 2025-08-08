with
-- 步骤1: 筛选2024年注册客户并提取注册月份
registered_2024 as (
select
customer_id,
substr(registration_date, 1, 7) as reg_month
from
ant_icube_dev.blinkit_customers
where
substr(registration_date, 1, 4) = '2024'
),

-- 步骤2: 计算客户当月订单总金额
customer_monthly_orders as (
select
r.customer_id,
r.reg_month,
sum(cast(o.order_total as decimal)) as total_amount
from
registered_2024 r
join
ant_icube_dev.blinkit_orders o
on r.customer_id = o.customer_id
and substr(o.order_date, 1, 7) = r.reg_month
group by
r.customer_id, r.reg_month
),

-- 步骤3: 计算各月份平均订单金额
monthly_avg as (
select
reg_month,
avg(total_amount) as avg_amount
from
customer_monthly_orders
group by
reg_month
)

-- 最终结果: 获取超过月均值的客户详细信息
select
c.*
from
ant_icube_dev.blinkit_customers c
inner join
customer_monthly_orders cmo
on c.customer_id = cmo.customer_id
inner join
monthly_avg ma
on cmo.reg_month = ma.reg_month
and cmo.total_amount > ma.avg_amount;