with sales_detail as (
    select
        cast(s.units as int) as units,
        st.store_location,
        cast(regexp_replace(p.product_price, '[^0-9.]', '') as double) as product_price
    from
        ant_icube_dev.mexico_toy_sales s
        inner join ant_icube_dev.mexico_toy_stores st on s.store_id = st.store_id
        inner join ant_icube_dev.mexico_toy_products p on s.product_id = p.product_id
)
select
    (sum(case when store_location = 'Commercial' then units * product_price else 0 end) 
     / sum(units * product_price)) * 100 as `比例`
from
    sales_detail;