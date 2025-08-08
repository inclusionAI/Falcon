with category_avg_price as (
    select 
        product_category,
        avg(cast(trim(replace(product_price, '$', '')) as decimal)) as avg_price
    from 
        ant_icube_dev.mexico_toy_products
    group by 
        product_category
),
valid_inventory as (
    select distinct
        i.store_id
    from 
        ant_icube_dev.mexico_toy_inventory i
    inner join 
        ant_icube_dev.mexico_toy_products p 
        on i.product_id = p.product_id
    inner join 
        category_avg_price cap 
        on p.product_category = cap.product_category
    where 
        cast(trim(i.stock_on_hand) as decimal) > cap.avg_price
)
select 
    store_id,
    store_open_date,
    store_city,
    store_location,
    store_name
from 
    ant_icube_dev.mexico_toy_stores
where 
    store_id in (select store_id from valid_inventory);