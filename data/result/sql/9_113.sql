with annual_rankings as (
    select 
        entity,
        code,
        year,
        row_number() over (partition by year order by cellular_subscription desc) as rank
    from 
        ant_icube_dev.di_global_lnternet_users
), top_10_years as (
    select 
        entity,
        code,
        year
    from 
        annual_rankings
    where 
        rank <= 10
), consecutive_groups as (
    select 
        entity,
        code,
        year,
        year - row_number() over (partition by entity order by year) as grp
    from 
        top_10_years
), consecutive_counts as (
    select 
        entity,
        code,
        count(*) as consecutive_count
    from 
        consecutive_groups
    group by 
        entity, code, grp
    having 
        count(*) >= 3
)
select 
    distinct entity as `国家`
from 
    consecutive_counts;