with gov_bonds_data as (
    select
        objective,
        cast(government_bonds as bigint) as gov_bond_value
    from
        ant_icube_dev.di_finance_data
    where
        government_bonds is not null
        and government_bonds rlike '^[0-9]+$'
)
select
    objective as `objective`,
    sum(gov_bond_value) as `政府债券总量`
from
    gov_bonds_data
group by
    `objective`
order by
    `objective`;