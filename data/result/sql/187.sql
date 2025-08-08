with sales_stores as (
    select
        s.date,
        s.store_id,
        s.sale_id,
        s.units
    from
        ant_icube_dev.mexico_toy_sales s
    inner join
        ant_icube_dev.mexico_toy_stores st
    on
        s.store_id = st.store_id
)
select
    date as `date`,
    store_id as `store_id`,
    sale_id as `sale_id`,
    units as `units`,
    row_number() over (
        partition by store_id, date
        order by cast(units as int) desc
    ) as `rank`
from
    sales_stores
order by
    store_id,
    date,
    `rank`;