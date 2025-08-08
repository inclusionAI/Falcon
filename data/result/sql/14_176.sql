with product_profit as (
    select 
        product_id,
        cast(regexp_replace(product_price, '[^0-9.]', '') as double) - cast(regexp_replace(product_cost, '[^0-9.]', '') as double) as profit
    from 
        ant_icube_dev.mexico_toy_products
),
high_profit_products as (
    select 
        product_id 
    from 
        product_profit 
    where 
        profit > 5
),
valid_inventory as (
    select 
        i.store_id,
        i.stock_on_hand,
        i.product_id
    from 
        ant_icube_dev.mexico_toy_inventory i
    inner join 
        high_profit_products h 
    on 
        i.product_id = h.product_id
),
city_stocks as (
    select 
        s.store_city,
        cast(v.stock_on_hand as int) as stock
    from 
        valid_inventory v
    inner join 
        ant_icube_dev.mexico_toy_stores s 
    on 
        v.store_id = s.store_id
)
select 
    store_city as `store_city`,
    sum(stock) as `total_stock`
from 
    city_stocks
group by 
    store_city;