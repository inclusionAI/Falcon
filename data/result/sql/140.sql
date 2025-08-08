with sale_info as (
    select
        s.datetime,
        cast(s.amount as bigint) as sale_amount,
        cast(p.price as bigint) as item_price
    from
        ant_icube_dev.bakery_sales_sale s
    join
        ant_icube_dev.bakery_sales_price p
    on
        s.product_name = p.name
    where
        s.day_of_week = 'Sun'
        and p.name = 'croissant'
)
select
    datetime as `datetime`
from
    sale_info
where
    sale_amount * item_price > 9000;