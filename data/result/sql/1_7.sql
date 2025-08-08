with industry_avg as (
    select
        avg(cast(government_bonds as double)) as avg_gov
    from
        ant_icube_dev.di_finance_data
),
qualified_investors as (
    select
        gender,
        cast(equity_market as double) as equity,
        cast(government_bonds as double) as bonds
    from
        ant_icube_dev.di_finance_data
    where
        cast(government_bonds as double) > (select avg_gov from industry_avg)
)
select
    gender as `gender`,
    sum(equity) / sum(bonds) as `ratio`
from
    qualified_investors
group by
    gender;