with publisher_sales as (
    select
        publisher,
        sum(cast(na_sales as double)) as na_total,
        sum(cast(eu_sales as double)) as eu_total
    from
        ant_icube_dev.di_video_game_sales
    group by
        publisher
)
select
    publisher as `发行商`,
    (na_total - eu_total) as `销售额差异`
from
    publisher_sales
where
    abs(na_total - eu_total) > 5
order by
    `销售额差异` desc;