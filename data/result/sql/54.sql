with filtered_cities as (
    select 
        city,
        max(to_date(date_joined, 'MM/dd/yyyy')) as latest_date
    from 
        ant_icube_dev.di_unicorn_startups
    group by 
        city
    having 
        year(latest_date) >= 2020
),
filtered_data as (
    select 
        t1.city,
        cast(regexp_replace(t1.valuation, '\\$', '') as double) as valuation_num
    from 
        ant_icube_dev.di_unicorn_startups t1
    inner join 
        filtered_cities t2 
    on 
        t1.city = t2.city
),
city_stats as (
    select 
        city,
        avg(valuation_num) as avg_valuation,
        avg(valuation_num) over () as global_avg
    from 
        filtered_data
    group by 
        city, valuation_num
)
select 
    city as `city`,
    avg_valuation as `平均估值`,
    (avg_valuation - global_avg) / global_avg * 100 as `增长幅度`
from 
    city_stats;