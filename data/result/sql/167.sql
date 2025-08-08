with 
overall_avg_unemployment as (
    select avg(cast(unemployment as double)) as avg_unemp
    from ant_icube_dev.walmart_features
),
high_unemp_stores as (
    select distinct f.store
    from ant_icube_dev.walmart_features f
    where cast(f.unemployment as double) > (select avg_unemp from overall_avg_unemployment)
),
store_total_sales as (
    select 
        s.store,
        sum(cast(s.weekly_sales as double)) as total_sales
    from ant_icube_dev.walmart_sales s
    join high_unemp_stores h on s.store = h.store
    group by s.store
),
combined_store_info as (
    select 
        t.store,
        t.total_sales,
        st.size
    from store_total_sales t
    join ant_icube_dev.walmart_stores st on t.store = st.store
)
select 
    store as `store`,
    total_sales as `weekly_sales`,
    size as `size`
from combined_store_info
order by total_sales desc
limit 5;