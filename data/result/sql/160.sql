with non_holiday_sales as (
    select 
        store,
        date,
        weekly_sales
    from
        ant_icube_dev.walmart_sales
    where
        isholiday = 'False'
),
monthly_sales as (
    select
        store,
        substr(date, 1, 7) as month,
        sum(cast(weekly_sales as double)) as monthly_sales
    from
        non_holiday_sales
    group by
        store, substr(date, 1, 7)
),
store_with_type as (
    select
        m.store,
        m.month,
        m.monthly_sales,
        s.type
    from
        monthly_sales m
    join
        ant_icube_dev.walmart_stores s
    on
        m.store = s.store
),
ranked_stores as (
    select
        store,
        month,
        monthly_sales,
        type,
        row_number() over (partition by type, month order by monthly_sales desc) as sales_rank
    from
        store_with_type
),
top5_stores as (
    select
        distinct store
    from
        ranked_stores
    where
        sales_rank <= 5
),
top5_total_sales as (
    SELECT  a.store
            ,SUM(weekly_sales) AS total_sales
    FROM    non_holiday_sales a
    JOIN    top5_stores b
    ON      a.store = b.store
    GROUP BY a.store 
)
SELECT  store
        ,CASE
                WHEN total_sales > 50000 THEN '是'
                ELSE '否'
        END AS `是否超过50000`
FROM    top5_total_sales;