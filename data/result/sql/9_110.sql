with yearly_data as (
    select 
        entity,
        cast(year as int) as year,
        cast(internet_users as bigint) as current_users
    from 
        ant_icube_dev.di_global_lnternet_users
    where 
        year is not null 
        and year != '' 
        and internet_users is not null 
        and internet_users != ''
),
growth_rates as (
    select 
        entity,
        year,
        (current_users - lag(current_users) over (partition by entity order by year)) * 100.0 
        / nullif(lag(current_users) over (partition by entity order by year), 0) as growth_rate
    from 
        yearly_data
)
select distinct
    gr1.entity as `国家`,
    gr1.year as `年份`,
    gr1.growth_rate as `增长率1`,
    gr2.growth_rate as `增长率2`,
    gr3.growth_rate as `增长率3`
from 
    growth_rates gr1
inner join 
    growth_rates gr2 
on 
    gr1.entity = gr2.entity 
    and gr2.year = gr1.year + 1
inner join 
    growth_rates gr3 
on 
    gr2.entity = gr3.entity 
    and gr3.year = gr2.year + 1
where 
    gr1.growth_rate > 10 
    and gr2.growth_rate > 10 
    and gr3.growth_rate > 10;