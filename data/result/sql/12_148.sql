with filtered_events as (
    select
        item_id
    from
        ant_icube_dev.google_merchandise_events
    where
        type = 'add_to_cart'
        and country = 'US'
),
android_items as (
    select
        id,
        name
    from
        ant_icube_dev.google_merchandise_items
    where
        brand = 'Android'
)
select
    ai.id as `id`,
    ai.name as `name`,
    count(*) as `add_to_cart_count`
from
    filtered_events fe
join
    android_items ai
on
    fe.item_id = ai.id
group by
    ai.id, ai.name;