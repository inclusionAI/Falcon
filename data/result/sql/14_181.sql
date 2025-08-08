with avg_stock_cte as (
    select avg(cast(stock_on_hand as bigint)) as avg_stock
    from ant_icube_dev.mexico_toy_inventory
),
store_inventory as (
    select 
        s.store_id,
        s.store_name,
        s.store_city,
        sum(cast(i.stock_on_hand as bigint)) as total_stock
    from 
        ant_icube_dev.mexico_toy_inventory i
        join ant_icube_dev.mexico_toy_stores s 
        on i.store_id = s.store_id
    group by 
        s.store_id, s.store_name, s.store_city
),
filtered_stores as (
    select 
        store_id,
        store_name,
        store_city,
        total_stock
    from 
        store_inventory 
    where 
        total_stock > (select avg_stock from avg_stock_cte)
)
select 
    store_id as `store_id`,
    store_name as `store_name`,
    store_city as `store_city`,
    total_stock as `total_stock`,
    rank() over (order by total_stock desc) as `库存排名`
from 
    filtered_stores
order by 
    `库存排名`;