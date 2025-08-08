with youtube_items as (
    select
        id,
        price_in_usd
    from
        ant_icube_dev.google_merchandise_items
    where
        brand = 'YouTube'
),
filtered_events as (
    select
        e.country,
        cast(i.price_in_usd as decimal) as price
    from
        ant_icube_dev.google_merchandise_events e
    inner join youtube_items i
        on e.item_id = i.id
    where
        e.type = 'add_to_cart'
        and e.device = 'mobile'
),
country_total as (
    select
        country,
        sum(price) as country_sales
    from
        filtered_events
    group by
        country
),
global_total as (
    select
        sum(country_sales) as total_sales
    from
        country_total
)
select
    ct.country as `国家`,
    ct.country_sales / (select total_sales from global_total) as `销售额占比`
from
    country_total ct;