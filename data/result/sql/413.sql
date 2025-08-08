with inventory_data as (
select
product_id,
sum(cast(damaged_stock as bigint)) as total_damaged,
sum(cast(stock_received as bigint)) as total_received
from ant_icube_dev.blinkit_inventory
where regexp_extract(damaged_stock,'^(\\d+)',0) = damaged_stock
and regexp_extract(stock_received,'^(\\d+)',0) = stock_received
group by product_id
),
damage_rate_calculation as (
select
product_id,
case
when (total_damaged + total_received) = 0 then 0.0
else total_damaged / (total_damaged + total_received)
end as damage_rate
from inventory_data
where (total_damaged + total_received) > 0
),
high_damage_products as (
select
product_id
from damage_rate_calculation
where damage_rate > 0.05
),
product_info as (
select
p.product_id,
p.brand,
cast(p.shelf_life_days as bigint) as shelf_life_days
from ant_icube_dev.blinkit_products p
inner join high_damage_products hdp
on p.product_id = hdp.product_id
where regexp_extract(p.shelf_life_days,'^(\\d+)',0) = p.shelf_life_days
),
brand_aggregation as (
select
brand,
count(distinct product_id) as product_count,
avg(shelf_life_days) as avg_shelf_life
from product_info
group by brand
),
rank_calculation as (
select
brand,
product_count,
avg_shelf_life,
rank() over (order by avg_shelf_life desc) as shelf_life_rank
from brand_aggregation
)
select
brand as `brand`,
product_count as `product_count`,
avg_shelf_life as `avg_shelf_life`
from rank_calculation;