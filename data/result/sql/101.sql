with app_converted_prices as (
    select 
        app, 
        category, 
        price, 
        cast(replace(trim(price), '$', '') as decimal(10,2)) as converted_price 
    from ant_icube_dev.di_google_play_store_apps 
    where trim(price) != '' and price is not null
),
category_averages as (
    select 
        category, 
        avg(converted_price) as avg_price 
    from app_converted_prices 
    group by category
)
select 
    a.app as `app`
from app_converted_prices a
inner join category_averages c 
    on a.category = c.category
where a.converted_price > 2 * c.avg_price;