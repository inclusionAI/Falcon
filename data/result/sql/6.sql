with fixed_conversion as (
    select 
        objective,
        cast(fixed_deposits as int) as fixed_deposits_int
    from 
        ant_icube_dev.di_finance_data
),
objective_stats as (
    select 
        objective,
        sum(fixed_deposits_int) as total_fixed,
        avg(fixed_deposits_int) as avg_fixed
    from 
        fixed_conversion
    group by 
        objective
),
ranking_data as (
    select
        objective,
        total_fixed,
        avg_fixed,
        rank() over (order by total_fixed desc) as total_rank
    from
        objective_stats
)
select
    objective as `投资目标`,
    total_fixed as `固定存款总额`,
    avg_fixed as `平均投资分布`,
    total_rank as `排名`
from
    ranking_data
order by
    total_rank;