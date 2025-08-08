with high_ltv_users as (
    select 
        id 
    from 
        ant_icube_dev.google_merchandise_users 
    where 
        cast(ltv as double) > (select avg(cast(ltv as double)) from ant_icube_dev.google_merchandise_users)
),
latest_mobile_add_events as (
    select 
        user_id,
        device,
        row_number() over (partition by user_id order by date desc) as event_rank
    from 
        ant_icube_dev.google_merchandise_events
    where 
        type = 'purchase'
)
select distinct
    e.user_id as `id`
from 
    latest_mobile_add_events e
inner join 
    high_ltv_users h 
on 
    e.user_id = h.id
where 
    e.event_rank = 1 
and e.device = 'desktop'