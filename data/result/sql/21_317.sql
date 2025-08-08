with
-- 连接订单表和用户表以获取城市信息
order_customer_info as (
select
o.totalamount,
c.city
from
ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o
join
ant_icube_dev.di_data_cleaning_for_customer_database_e_customers c
on
o.customerid = c.customerid
)

-- 计算各城市总金额并排序
select
city as `城市`,
sum(cast(totalamount as double)) as `订单总金额`
from
order_customer_info
group by
city
order by
`订单总金额` desc;