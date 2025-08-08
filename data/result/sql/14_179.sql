with store_sales as (
    select
        s.store_id,
        sum(cast(regexp_replace(p.product_price, '[^0-9.]', '') as double) * cast(s.units as int)) as total_sales
    from
        ant_icube_dev.mexico_toy_sales s
    inner join
        ant_icube_dev.mexico_toy_products p
    on
        s.product_id = p.product_id
    group by
        s.store_id
),
city_sales as (
    select
        st.store_city,
        ss.store_id,
        ss.total_sales
    from
        store_sales ss
    inner join
        ant_icube_dev.mexico_toy_stores st
    on
        ss.store_id = st.store_id
),
city_avg as (
    select
        store_city,
        avg(total_sales) as avg_sales
    from
        city_sales
    group by
        store_city
)
select
    cs.store_city as `store_city`,
    cs.store_id as `store_id`,
    cs.total_sales as `total_sales`
from
    city_sales cs
inner join
    city_avg ca
on
    cs.store_city = ca.store_city
where
    cs.total_sales > ca.avg_sales
order by
    cs.total_sales desc;