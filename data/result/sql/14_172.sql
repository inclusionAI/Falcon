with products_cte as (
    select 
        product_id,
        product_category,
        cast(regexp_replace(product_cost, '[^0-9.]', '') as decimal) as cost,
        cast(regexp_replace(product_price, '[^0-9.]', '') as decimal) as price
    from ant_icube_dev.mexico_toy_products
),

joined_data as (
    select 
        p.product_category,
        st.store_city,
        (p.price - p.cost)/p.price as profit_margin
    from ant_icube_dev.mexico_toy_sales s
    join products_cte p 
        on s.product_id = p.product_id
    join ant_icube_dev.mexico_toy_stores st 
        on s.store_id = st.store_id
)

select 
    product_category as `玩具品类`,
    store_city as `城市`,
    avg(profit_margin) * 100 as `平均利润率`
from joined_data
group by 
    product_category, 
    store_city;