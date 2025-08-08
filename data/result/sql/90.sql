with paid_apps as (
    select 
        category,
        app
    from 
        ant_icube_dev.di_google_play_store_apps
    where 
        cast(trim(substr(price, 2)) as double) > 0
        and cast(trim(rating) as double) > 4.0
)
select 
    category as `category`,
    count(app) as `paid_app_count`
from 
    paid_apps
group by 
    category;