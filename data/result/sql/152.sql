with brand_avg_price as (
    select 
        brand,
        avg(cast(price_in_usd as decimal)) as avg_price
    from 
        ant_icube_dev.google_merchandise_items
    group by 
        brand
)
select
    i.brand as `brand`,
    count(i.id) as `count`
from
    ant_icube_dev.google_merchandise_items i
inner join
    brand_avg_price a
on 
    i.brand = a.brand
where
    cast(i.price_in_usd as decimal) > a.avg_price
group by
    i.brand;