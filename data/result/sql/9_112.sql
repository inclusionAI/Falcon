with latest_years as (
    select
        code,
        max(year) as latest_year
    from
        ant_icube_dev.di_global_lnternet_users
    group by
        code
)
select
    a.entity as `国家名称`,
    cast(a.no_of_internet_users as bigint) as `互联网用户数量`
from
    ant_icube_dev.di_global_lnternet_users a
join
    latest_years b
on
    a.code = b.code
    and a.year = b.latest_year
order by
    `互联网用户数量` desc;