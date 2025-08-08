with store_opening_dates as (
    select
        store_id,
        to_date(store_open_date, 'yyyy-mm-dd') as open_date,
        to_date(add_months(to_date(store_open_date, 'yyyy-mm-dd'), 36), 'yyyy-mm-dd') as third_year_date
    from
        ant_icube_dev.mexico_toy_stores
),
valid_sales as (
    select
        s.store_id,
        sum(cast(s.units as bigint)) as total_units
    from
        ant_icube_dev.mexico_toy_sales s
    join
        store_opening_dates sod
    on
        s.store_id = sod.store_id
    where
        to_date(s.date, 'yyyy-mm-dd') >= sod.third_year_date
    group by
        s.store_id
),
store_inventory as (
    select
        store_id,
        sum(cast(stock_on_hand as bigint)) as total_stock
    from
        ant_icube_dev.mexico_toy_inventory
    group by
        store_id
),
turnover_rates as (
    select
        vs.store_id,
        (vs.total_units * 1.0) / si.total_stock as turnover_rate,
        st.store_city
    from
        valid_sales vs
    join
        store_inventory si
    on
        vs.store_id = si.store_id
    join
        ant_icube_dev.mexico_toy_stores st
    on
        vs.store_id = st.store_id
),
city_avg_turnover as (
    select
        store_city,
        avg(turnover_rate) as avg_rate
    from
        turnover_rates
    group by
        store_city
)
select
    tr.store_id,
    tr.turnover_rate as `库存周转率`,
    cat.avg_rate as `同类平均周转率`
from
    turnover_rates tr
join
    city_avg_turnover cat
on
    tr.store_city = cat.store_city
join
    ant_icube_dev.mexico_toy_stores st
on
    tr.store_id = st.store_id
where
    tr.turnover_rate >= cat.avg_rate;