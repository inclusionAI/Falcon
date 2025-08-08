with store_sales as (
    select
        ws.store,
        st.type,
        cast(ws.weekly_sales as double) as weekly_sales
    from
        ant_icube_dev.walmart_sales ws
        join ant_icube_dev.walmart_stores st on ws.store = st.store
),
avg_store_sales as (
    select
        type,
        store,
        avg(weekly_sales) as avg_weekly_sales,
        sum(weekly_sales) as sum_weekly_sales
    from
        store_sales
    group by
        type,
        store
),
ranked_stores as (
    select
        type,
        store,
        avg_weekly_sales,
        sum_weekly_sales,
        row_number() over (
            partition by type
            order by
                sum_weekly_sales desc
        ) as rn
    from
        avg_store_sales
)
select
    type,
    store,
    case
        when avg_weekly_sales > 10000 then 'Yes'
        else 'No'
    end as `是否超过10000`
from
    ranked_stores
where
    rn <= 5;