with category_avg_cost as (
    select 
        product_category,
        avg(cast(regexp_replace(product_cost, '\\$| ', '') as decimal)) as avg_cost
    from 
        ant_icube_dev.mexico_toy_products
    group by 
        product_category
),
low_cost_products as (
    select 
        p.product_id,
        p.product_category,
        cast(regexp_replace(p.product_cost, '\\$| ', '') as decimal) as product_cost,
        c.avg_cost
    from 
        ant_icube_dev.mexico_toy_products p
    join 
        category_avg_cost c
        on p.product_category = c.product_category
    where 
        cast(regexp_replace(p.product_cost, '\\$| ', '') as decimal) < c.avg_cost
),
commercial_stores as (
    select 
        store_id
    from 
        ant_icube_dev.mexico_toy_stores
    where 
        store_location = 'Commercial'
)
select 
    s.date as `date`,
    s.product_id as `product_id`,
    s.store_id as `store_id`,
    s.units as `units`,
    l.product_cost as `product_cost`,
    l.avg_cost as `category_avg_cost`
from 
    ant_icube_dev.mexico_toy_sales s
join 
    low_cost_products l
    on s.product_id = l.product_id
join 
    commercial_stores c
    on s.store_id = c.store_id;