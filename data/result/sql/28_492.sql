with electronic_products as (
select
product_id,
supplier_id,
product_name,
cast(price as double) as product_price
from
ant_icube_dev.online_shop_products
where
category = 'Accessories'
),
supplier_avg_price as (
select
supplier_id,
avg(product_price) as avg_supplier_price
from
electronic_products
group by
supplier_id
having
avg_supplier_price > 400
),
product_inventory as (
select
product_id,
sum(cast(trim(quantity) as int)) as total_quantity
from
ant_icube_dev.online_shop_order_items
group by
product_id
having
sum(cast(trim(quantity) as int)) > 10
)
select
p.product_id as `product_id`,
p.supplier_id as `supplier_id`
from
electronic_products p
join
supplier_avg_price s on p.supplier_id = s.supplier_id
join
product_inventory i on p.product_id = i.product_id;