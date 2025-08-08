with publisher_sales as (
    select
        publisher,
        sum(cast(eu_sales as double)) as total_eu,
        sum(cast(jp_sales as double)) as total_jp
    from
        ant_icube_dev.di_video_game_sales
    group by
        publisher
)
select
    publisher as `发行商`
from
    publisher_sales
order by
    `销售额差异` desc
limit 10;