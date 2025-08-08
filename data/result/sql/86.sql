with publisher_avg as (
    select
        publisher,
        avg(cast(na_sales as double)) as avg_na_sales
    from
        ant_icube_dev.di_video_game_sales
    group by
        publisher
),
ranked_games as (
    select
        publisher,
        name,
        cast(na_sales as double) as na_sales,
        row_number() over (
            partition by publisher 
            order by cast(na_sales as double) desc
        ) as rn
    from
        ant_icube_dev.di_video_game_sales
)
select
    a.publisher as `发行商`,
    b.name as `游戏名称`,
    b.na_sales as `北美销售额`,
    (b.na_sales - a.avg_na_sales) as `差额`
from
    publisher_avg a
inner join
    ranked_games b
on 
    a.publisher = b.publisher
where
    b.rn <= 3;