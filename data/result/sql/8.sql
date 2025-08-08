with age_avg_fd as (
    select 
        age,
        avg(cast(fixed_deposits as bigint)) as avg_fd
    from 
        ant_icube_dev.di_finance_data
    group by 
        age
),
filtered_records as (
    select 
        t.age,
        cast(t.gold as bigint) as gold_val,
        cast(t.fixed_deposits as bigint) as fd_val,
        cast(t.debentures as bigint) as debentures_val,
        cast(t.equity_market as bigint) as equity_val,
        cast(t.mutual_funds as bigint) as mutual_val,
        cast(t.ppf as bigint) as ppf_val,
        cast(t.government_bonds as bigint) as bonds_val
    from 
        ant_icube_dev.di_finance_data t
    inner join 
        age_avg_fd a 
    on 
        t.age = a.age
    where 
        cast(t.fixed_deposits as bigint) > a.avg_fd
),
asset_totals as (
    select 
        age,
        sum(gold_val) as total_gold,
        sum(gold_val + fd_val + debentures_val + equity_val + mutual_val + ppf_val + bonds_val) as total_asset
    from 
        filtered_records
    group by 
        age
)
select 
    age as `age`
from 
    asset_totals
order by 
   (total_gold / total_asset) desc
limit 1;