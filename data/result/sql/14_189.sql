with sales_profit as (
    select
        pr.product_category,
        st.store_city,
        (cast(trim(replace(pr.product_price, '$', '')) as decimal) - cast(trim(replace(pr.product_cost, '$', '')) as decimal)) * cast(s.units as int) as profit
    from
        ant_icube_dev.mexico_toy_sales s
        join ant_icube_dev.mexico_toy_stores st on s.store_id = st.store_id
        join ant_icube_dev.mexico_toy_products pr on s.product_id = pr.product_id
),
city_sales as (
    select
        product_category,
        store_city,
        sum(cast(trim(replace(pr.product_price, '$', '')) as decimal) * cast(s.units as int)) as total_sales
    from
        ant_icube_dev.mexico_toy_sales s
        join ant_icube_dev.mexico_toy_stores st on s.store_id = st.store_id
        join ant_icube_dev.mexico_toy_products pr on s.product_id = pr.product_id
    group by
        product_category, store_city
),
city_rank as (
    select
        product_category,
        store_city,
        row_number() over (partition by product_category order by total_sales desc) as rank
    from
        city_sales
),
top_cities as (
    select
        product_category,
        store_city
    from
        city_rank
    where
        rank <= 3
)
select
    sp.product_category as `product_category`,
    sum(sp.profit) as `total_profit`
from
    sales_profit sp
    join top_cities tc on sp.product_category = tc.product_category and sp.store_city = tc.store_city
group by
    sp.product_category;