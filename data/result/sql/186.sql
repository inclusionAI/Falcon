with stores_opened_in_q4 as (
    select store_id
    from ant_icube_dev.mexico_toy_stores
    where store_open_date between '2017-10-01' and '2017-12-31'
),
art_products as (
    select 
        product_id,
        cast(regexp_replace(product_price, '[^0-9.]', '') as double) as product_price,
        cast(regexp_replace(product_cost, '[^0-9.]', '') as double) as product_cost
    from ant_icube_dev.mexico_toy_products
    where product_category = 'Art & Crafts'
)
select
    sum(cast(s.units as bigint) * (ap.product_price - ap.product_cost)) as `销售总利润`
from
    ant_icube_dev.mexico_toy_sales s
    inner join stores_opened_in_q4 st on s.store_id = st.store_id
    inner join art_products ap on s.product_id = ap.product_id;