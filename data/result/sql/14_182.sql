with product_cost_price as (
    select
        product_id,
        cast(regexp_replace(product_cost, '[^0-9.]', '') as double) as product_cost,
        cast(regexp_replace(product_price, '[^0-9.]', '') as double) as product_price
    from
        ant_icube_dev.mexico_toy_products
),
sales_profit as (
    select
        s.store_id,
        st.store_city,
        sum((p.product_price - p.product_cost) * cast(s.units as int)) as total_profit_diff
    from
        ant_icube_dev.mexico_toy_sales s
        join ant_icube_dev.mexico_toy_stores st on s.store_id = st.store_id
        join product_cost_price p on s.product_id = p.product_id
    group by
        s.store_id, st.store_city
)
select
    store_city as `store_city`,
    store_id as `store_id`,
    total_profit_diff as `profit_diff`
from
    sales_profit;