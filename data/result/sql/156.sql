with high_temp_sales as (
    select 
        s.dept,
        cast(s.weekly_sales as double) as weekly_sales
    from 
        ant_icube_dev.walmart_sales s
        join ant_icube_dev.walmart_features f
        on s.store = f.store and s.date = f.date
    where 
        cast(f.temperature as double) > 30
),
dept_total as (
    select 
        dept,
        sum(weekly_sales) as total_sales,
        count(*) as record_count
    from 
        high_temp_sales
    group by 
        dept
),
overall_avg as (
    select 
        avg(weekly_sales) as avg_sales
    from 
        high_temp_sales
)
SELECT  dept                                                           AS `部门`
        ,total_sales                                                   AS `总销售额`
        ,(total_sales - ((
                            SELECT  AVG(weekly_sales) AS avg_sales
                            FROM    high_temp_sales
                         ) * record_count)) / ((
                                                   SELECT  AVG(weekly_sales) AS avg_sales
                                                   FROM    high_temp_sales
                                               ) * record_count) * 100 AS `差异百分比`
FROM    dept_total;