with product_profit as (
    select
        p.product_id,
        p.product_category,
        (
            cast(regexp_extract(p.product_price, '\\d+\\.\\d+', 0) as decimal) 
            - cast(regexp_extract(p.product_cost, '\\d+\\.\\d+', 0) as decimal)
        ) / cast(regexp_extract(p.product_price, '\\d+\\.\\d+', 0) as decimal) as profit_margin
    from
        ant_icube_dev.mexico_toy_products p
    inner join
        ant_icube_dev.mexico_toy_sales s
    on
        p.product_id = s.product_id
),
category_avg as (
    select
        product_category,
        avg(profit_margin) as avg_margin
    from
        product_profit
    group by
        product_category
)
select
    product_id as `product_id`,
    product_category as `product_category`,
    profit_margin as `profit_margin`
from
    product_profit
inner join
    category_avg
using
    (product_category)
where
    profit_margin > avg_margin;