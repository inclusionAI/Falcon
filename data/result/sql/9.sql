with avg_holding as (
    select
        gender,
        objective,
        avg(cast(government_bonds as bigint)) as avg_gov_bonds
    from
        ant_icube_dev.di_finance_data
    group by
        gender,
        objective
)
select
    gender as `gender`,
    objective as `investment_objective`,
    avg_gov_bonds as `average_government_bonds_holding`,
    rank() over (order by avg_gov_bonds desc) as `收益排名`
from
    avg_holding
order by
    `收益排名`;