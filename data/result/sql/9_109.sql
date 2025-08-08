with filtered_data as (
    select
        code,
        broadband_subscription
    from
        ant_icube_dev.di_global_lnternet_users
    where
        year = '2020'
),
aggregated_data as (
    select
        code,
        sum(cast(broadband_subscription as bigint)) as total_broadband
    from
        filtered_data
    group by
        code
)
select
    code as `国家代码`,
    total_broadband as `宽带订阅用户数`
from
    aggregated_data
where
    total_broadband > 50
order by
    `宽带订阅用户数` desc
limit 10;