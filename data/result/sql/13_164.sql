with promo_sales as (
    select 
        s.store,
        s.dept,
        sum(s.weekly_sales) as total_sales
    from 
        ant_icube_dev.walmart_sales s
    join 
        ant_icube_dev.walmart_stores st 
    on 
        s.store = st.store
    where 
        s.isholiday = 'True'
    group by 
        s.store, s.dept
),
ranked_sales as (
    select 
        store,
        dept,
        total_sales,
        row_number() over (partition by store order by total_sales desc) as sales_rank
    from 
        promo_sales
)
select 
    store as `store`,
    dept as `dept`,
    total_sales as `total_sales`,
    sales_rank as `sales_rank`
from 
    ranked_sales
where 
    sales_rank <= 5