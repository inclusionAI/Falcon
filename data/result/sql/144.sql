with cart_events as (
    select
        e.item_id,
        i.category
    from
        ant_icube_dev.google_merchandise_events e
    join ant_icube_dev.google_merchandise_items i
        on e.item_id = i.id
    where
        e.type = 'add_to_cart'
),
item_category_stats as (
    select
        category,
        item_id,
        count(*) as add_to_cart_count
    from
        cart_events
    group by
        category,
        item_id
),
category_total as (
    select
        item_id,
        category,
        sum(add_to_cart_count) over (partition by category) as total_category_count,
        add_to_cart_count
    from
        item_category_stats
),
ranked_items as (
    select
        category,
        item_id,
        add_to_cart_count,
        total_category_count,
        row_number() over (partition by category order by add_to_cart_count desc) as rn
    from
        category_total
)
select
    category as `category`,
    item_id as `item_id`,
    add_to_cart_count as `add_to_cart_count`,
    cast(add_to_cart_count as decimal) / total_category_count as `cart_ratio`
from
    ranked_items
where
    rn <= 10
order by
    category,
    rn;