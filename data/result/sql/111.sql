with data_prep as (
    select 
        code,
        cast(year as int) as year,
        cast(broadband_subscription as double) as broadband_subscription,
        cast(cellular_subscription as double) as cellular_subscription
    from 
        ant_icube_dev.di_global_lnternet_users
    where 
        year is not null 
        and broadband_subscription is not null 
        and cellular_subscription is not null
),
prev_year_data as (
    select 
        code,
        year,
        broadband_subscription,
        cellular_subscription,
        lag(broadband_subscription) over (partition by code order by year) as prev_broadband,
        lag(cellular_subscription) over (partition by code order by year) as prev_cellular,
        lag(year) over (partition by code order by year) as prev_year
    from 
        data_prep
),
growth_rates as (
    select 
        code,
        year,
        (broadband_subscription - prev_broadband) / prev_broadband * 100 as broadband_growth,
        (cellular_subscription - prev_cellular) / prev_cellular * 100 as cellular_growth
    from 
        prev_year_data
    where 
        prev_year is not null 
        and prev_broadband is not null 
        and prev_cellular is not null 
        and year = prev_year + 1
),
annual_comparison as (
    select 
        code,
        year,
        case when broadband_growth > cellular_growth then 1 else 0 end as is_higher
    from 
        growth_rates
),
consecutive_years as (
    select 
        code,
        year,
        is_higher,
        lag(is_higher) over (partition by code order by year) as prev_is_higher
    from 
        annual_comparison
)
select distinct
    code as `国家代码`
from 
    consecutive_years
where 
    is_higher = 1 
    and prev_is_higher = 1;