with filtered_orders as (
select
dp.delivery_partner_id,
dp.delivery_status
from
ant_icube_dev.blinkit_orders o
join
ant_icube_dev.blinkit_delivery_performance dp
on
o.order_id = dp.order_id
where
year(to_date(o.order_date)) = 2023
),

delivery_stats as (
select
delivery_partner_id,
count(*) as total_orders,
sum(case when delivery_status = 'On Time' then 1 else 0 end) as on_time_orders
from
filtered_orders
group by
delivery_partner_id
),

ratio_ranking as (
select
delivery_partner_id,
cast(on_time_orders as double) / cast(total_orders as double) as on_time_ratio,
rank() over(order by cast(on_time_orders as double)/cast(total_orders as double) desc) as rnk
from
delivery_stats
where
total_orders > 0
)

select
delivery_partner_id
from
ratio_ranking
where
rnk = 1;