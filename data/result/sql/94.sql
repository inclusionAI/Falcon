with filtered_education_apps as (
    select
        installs,
        app
    from
        ant_icube_dev.di_google_play_store_apps
    where
        category = 'EDUCATION'
)
select
    installs as `安装量`,
    count(app) as `应用数量`
from
    filtered_education_apps
group by
    installs;