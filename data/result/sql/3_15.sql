with cleaned_data as (
    select 
        company,
        cast(date as date) as date,
        cast(close as double) as close,
        cast(volume as bigint) as volume
    from 
        ant_icube_dev.di_massive_yahoo_finance_dataset
    where 
        date is not null 
        and close is not null 
        and volume is not null
),
moving_avg_calculation as (
    select 
        company,
        date,
        volume,
        avg(close) over (
            partition by company 
            order by date 
            rows between 6 preceding and current row
        ) as moving_avg_7d
    from 
        cleaned_data
),
filtered_companies as (
    select 
        company,
        date,
        volume
    from 
        moving_avg_calculation
    where 
        moving_avg_7d > 10
),
ranked_dates as (
    select 
        company,
        date,
        volume,
        row_number() over (
            partition by company 
            order by volume desc
        ) as rn
    from 
        filtered_companies
)
select 
    company as `company`,
    date as `date`,
    volume as `volume`
from 
    ranked_dates
where 
    rn <= 3;