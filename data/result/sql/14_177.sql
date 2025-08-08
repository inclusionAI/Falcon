with store_info as (
    select
        store_id,
        to_date(store_open_date) as store_open_date,
        store_city
    from
        ant_icube_dev.mexico_toy_stores
),
sales_data as (
    select
        s.store_id,
        to_date(s.date) as sale_date,
        s.sale_id
    from
        ant_icube_dev.mexico_toy_sales s
)
select
    si.store_city as `store_city`,
    count(distinct sd.sale_id) as `valid_order_count`
from
    sales_data sd
inner join
    store_info si
on
    sd.store_id = si.store_id
where
    sd.sale_date > si.store_open_date
group by
    si.store_city;