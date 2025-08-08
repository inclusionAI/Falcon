with
-- 筛选UPS快递且订单金额超过500美元的订单及发货信息
filtered_orders as (
select
o.customer_id,
s.shipment_date,
s.delivery_date,
cast(o.total_price as double) as total_price
from
ant_icube_dev.online_shop_orders o
join
ant_icube_dev.online_shop_shipments s
on o.order_id = s.order_id
where
s.carrier = 'UPS'
and cast(o.total_price as double) > 500
),
-- 获取每个客户最近一次发货记录
recent_shipments as (
select
*,
row_number() over (
partition by customer_id
order by shipment_date desc
) as rn
from
filtered_orders
)
-- 计算最终结果并关联客户信息
select
c.customer_id as `客户id`,
c.first_name as `名字`,
c.last_name as `姓氏`,
datediff(
to_date(rs.delivery_date, 'yyyy-MM-dd'),
to_date(rs.shipment_date, 'yyyy-MM-dd')
) as `等待天数`
from
recent_shipments rs
join
ant_icube_dev.online_shop_customers c
on rs.customer_id = c.customer_id
where
rs.rn = 1;