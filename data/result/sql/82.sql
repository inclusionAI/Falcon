with filtered_data as (
    select
        name,
        year,
        na_sales
    from
        ant_icube_dev.di_video_game_sales
    where
        genre = 'Action'
)
select
    name as `游戏名称`,
    na_sales as `北美销售`
from
    filtered_data
order by
    cast(na_sales as double);