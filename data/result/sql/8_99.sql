with paid_apps as (
    select 
        app,
        price,
        installs
    from 
        ant_icube_dev.di_google_play_store_apps
    where 
        type != 'Free'
        and trim(price) != ''
),
processed_data as (
    select 
        app,
        cast(regexp_replace(replace(trim(price), '$', ''), '[^0-9.]', '') as decimal(10,2)) as price_value,
        cast(regexp_replace(replace(replace(trim(installs), '+', ''), ',', ''), '[^0-9]', '') as bigint) as installs_num
    from 
        paid_apps
    where 
        regexp_replace(replace(trim(price), '$', ''), '[^0-9.]', '') rlike '^[0-9]+(\\\\.[0-9]+)?$'
        and regexp_replace(replace(replace(trim(installs), '+', ''), ',', ''), '[^0-9]', '') rlike '^[0-9]+$'
)
select 
    app as `app`
from 
    processed_data
where 
    price_value * installs_num >= 10000;