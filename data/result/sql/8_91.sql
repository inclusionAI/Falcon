with split_content_rating as (
    select
        app,
        trim(content_rating_single) as content_rating,
        installs,
        rating
    from
        ant_icube_dev.di_google_play_store_apps
        lateral view explode(split(content_rating, ';')) t as content_rating_single
    where
        trim(content_rating_single) != ''
),
install_converted as (
    select
        app,
        content_rating,
        cast(regexp_replace(installs, '[^0-9]', '') as bigint) as installs_num,
        cast(rating as float) as rating_num
    from
        split_content_rating
    where
        regexp_replace(installs, '[^0-9]', '') != ''
        and rating rlike '^[0-9\\\\.]+$'
),
ranked_apps as (
    select
        content_rating,
        app,
        installs_num,
        rating_num,
        row_number() over (partition by content_rating order by installs_num desc) as rank
    from
        install_converted
)
select
    content_rating as `内容分级`,
    app as `应用`,
    rating_num as `评分`
from
    ranked_apps
where
    rank <= 10;