with filtered_stores as (
    select 
        store_id, 
        store_city
    from 
        ant_icube_dev.mexico_toy_stores
    where 
        store_open_date < date '2008-01-01'
),
sales_with_prices as (
    select 
        s.store_id,
        p.product_price
    from 
        ant_icube_dev.mexico_toy_sales s
    join 
        ant_icube_dev.mexico_toy_products p
    on 
        s.product_id = p.product_id
    join 
        filtered_stores f
    on 
        s.store_id = f.store_id
),
city_price_aggregation as (
    select 
        f.store_city,
        avg(cast(substr(trim(p.product_price), 2) as double)) as avg_price
    from 
        sales_with_prices p
    join 
        filtered_stores f
    on 
        p.store_id = f.store_id
    group by 
        f.store_city
)
select 
    store_city as `store_city`
from 
    city_price_aggregation
where 
    round(avg_price, 2) < 14.99