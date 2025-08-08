with daily_data as (
    select 
        company,
        date,
        substr(date, 1, 7) as month,
        cast(volume as double) as volume,
        cast(open as double) as open
    from 
        ant_icube_dev.di_massive_yahoo_finance_dataset
),
monthly_volume as (
    select 
        company,
        month,
        sum(volume) as total_volume
    from 
        daily_data
    group by 
        company, month
    having 
        sum(volume) > 300000000
),
ordered_opens as (
    select 
        company,
        month,
        open,
        date,
        row_number() over (partition by company, month order by date) as first_open_rn,
        row_number() over (partition by company, month order by date desc) as last_open_rn
    from 
        daily_data
),
monthly_change as (
    select 
        mv.company,
        mv.month,
        mv.total_volume,
        (max(case when oo.last_open_rn = 1 then oo.open end) - 
         max(case when oo.first_open_rn = 1 then oo.open end)) / 
         max(case when oo.first_open_rn = 1 then oo.open end) as increase_rate
    from 
        monthly_volume mv
    join 
        ordered_opens oo 
    on 
        mv.company = oo.company and mv.month = oo.month
    group by 
        mv.company, mv.month, mv.total_volume
),
ranked_months as (
    select 
        company,
        month,
        total_volume,
        increase_rate,
        row_number() over (partition by company order by increase_rate desc) as month_rank
    from 
        monthly_change
)
select 
    company as `company`,
    month as `month`,
    total_volume as `total_volume`,
    increase_rate as `increase_rate`
from 
    ranked_months
where 
    month_rank <= 1
order by 
    `company`, month_rank;