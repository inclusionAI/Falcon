with mobile_purchases as (
    select
        e.item_id,
        e.device,
        e.type
    from
        ant_icube_dev.google_merchandise_events e
    where
        e.device = 'mobile'
        and e.type = 'purchase'
),
brand_mapping as (
    select
        i.id as item_id,
        i.brand
    from
        ant_icube_dev.google_merchandise_items i
)
select
    `brand` as `品牌`,
    count(*) as `总购买次数`
from
    mobile_purchases mp
    join brand_mapping bm on mp.item_id = bm.item_id
group by
    `brand`
having
    count(*) > 1;