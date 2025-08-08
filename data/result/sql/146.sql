with purchase_events as (
    select 
        item_id,
        min(date) as first_purchase_date
    from 
        ant_icube_dev.google_merchandise_events
    where 
        type = 'purchase'
    group by 
        item_id
)
select
    i.id as `id`,
    i.name as `name`,
    pe.first_purchase_date as `首次购买时间`
from
    purchase_events pe
join
    ant_icube_dev.google_merchandise_items i
on 
    pe.item_id = i.id
order by
    pe.first_purchase_date;