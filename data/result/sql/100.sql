with filtered_apps as (
    select 
        category,
        android_ver
    from 
        ant_icube_dev.di_google_play_store_apps
    where 
        cast(regexp_extract(android_ver, '^(\\\\d+\\\\.\\\\d+)', 1) as double) >= 4.1
)
select 
    category as `类别`,
    count(*) as `应用数`
from 
    filtered_apps
group by 
    category;