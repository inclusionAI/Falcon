with education_apps as (
    select
        app,
        rating,
        installs
    from
        ant_icube_dev.di_google_play_store_apps
    where
        category = 'EDUCATION'
),
rating_conversion as (
    select
        app,
        case
            when cast(rating as double) between 0 and 5 then cast(rating as double)
            else null
        end as converted_rating,
        cast(regexp_replace(installs, '[^0-9]', '') as bigint) as install_count
    from
        education_apps
    where
        rating is not null
        and installs is not null
),
valid_records as (
    select
        app,
        converted_rating,
        install_count
    from
        rating_conversion
    where
        converted_rating is not null
        and install_count is not null
),
app_ranking as (
    select
        app,
        avg(install_count) as avg_installs,
        avg(converted_rating) as avg_rating
    from
        valid_records
    group by
        app
)
select
    app as `APP名称`,
    avg_installs as `平均安装次数`
from
    app_ranking
order by
    avg_rating desc
limit
    5;