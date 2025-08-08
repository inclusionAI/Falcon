with joined_data as (
    select
        s.store_id,
        st.store_city,
        p.product_category,
        cast(s.units as bigint) as units
    from
        ant_icube_dev.mexico_toy_sales s
    inner join
        ant_icube_dev.mexico_toy_stores st
    on
        s.store_id = st.store_id
    inner join
        ant_icube_dev.mexico_toy_products p
    on
        s.product_id = p.product_id
),

city_category_sales as (
    select
        store_city,
        product_category,
        sum(units) as total_units
    from
        joined_data
    group by
        store_city,
        product_category
),

ranked_categories as (
    select
        store_city,
        product_category,
        total_units,
        row_number() over (
            partition by store_city
            order by total_units desc
        ) as sales_rank
    from
        city_category_sales
)

select
    store_city as `store_city`,
    product_category as `product_category`,
    total_units as `total_units`
from
    ranked_categories
where
    sales_rank = 1;