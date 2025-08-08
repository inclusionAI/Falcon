with purchase_events as (
    select 
        e.device,
        i.brand,
        cast(i.price_in_usd as decimal) as price
    from 
        ant_icube_dev.google_merchandise_events e
        join ant_icube_dev.google_merchandise_items i on e.item_id = i.id
        join ant_icube_dev.google_merchandise_users u on e.user_id = u.id
    where 
        e.type = 'purchase'
),
device_sales as (
    select 
        brand,
        device,
        sum(price) as device_total
    from 
        purchase_events
    group by 
        brand, device
),
brand_sales as (
    select 
        brand,
        sum(price) as brand_total
    from 
        purchase_events
    group by 
        brand
)
select 
    a.brand as `brand`,
    a.device as `device`,
    round((a.device_total / b.brand_total) * 100, 2) as `sales_ratio`
from 
    device_sales a
    join brand_sales b on a.brand = b.brand;