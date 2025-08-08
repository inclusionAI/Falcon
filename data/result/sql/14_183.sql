with sales_with_store_info as (
    select
        s.store_id,
        s.product_id,
        to_date(s.date, 'yyyy-mm-dd') as sale_date,
        to_date(st.store_open_date, 'yyyy-mm-dd') as store_open_date,
        cast(s.units as int) as units
    from
        ant_icube_dev.mexico_toy_sales s
    join
        ant_icube_dev.mexico_toy_stores st
        on s.store_id = st.store_id
),
monthly_grouped as (
    select
        store_id,
        product_id,
        (year(sale_date) - year(store_open_date)) * 12 + (month(sale_date) - month(store_open_date)) as month_since_open,
        sum(units) as monthly_units
    from
        sales_with_store_info
    group by
        store_id,
        product_id,
        (year(sale_date) - year(store_open_date)) * 12 + (month(sale_date) - month(store_open_date))
),
cumulative_calculation as (
    select
        store_id,
        product_id,
        month_since_open,
        sum(monthly_units) over (partition by store_id, product_id order by month_since_open) as cumulative_units
    from
        monthly_grouped
)
select
    store_id as `store_id`,
    product_id as `product_id`,
    month_since_open as `month_since_open`,
    cumulative_units as `cumulative_units`
from
    cumulative_calculation
where
    cumulative_units <= 100;