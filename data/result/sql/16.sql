with daily_data as (
    select 
        company,
        date,
        cast(high as double) as high_price,
        cast(low as double) as low_price,
        cast(volume as bigint) as volume_value
    from 
        ant_icube_dev.di_massive_yahoo_finance_dataset
    where 
        high regexp '^[0-9.]+$'
        and low regexp '^[0-9.]+$'
        and volume regexp '^[0-9]+$'
),
price_diff as (
    select 
        company,
        date,
        (high_price - low_price) as diff,
        volume_value
    from 
        daily_data
),
filtered_diff as (
    select 
        company,
        date,
        diff,
        volume_value
    from 
        price_diff
    where 
        diff > 100
),
ranked_data as (
    select 
        company,
        date,
        diff,
        volume_value,
        row_number() over (
            partition by company 
            order by volume_value desc
        ) as rn
    from 
        filtered_diff
)
select 
    company as `company`,
    date as `date`,
    diff as `价差`,
    volume_value as `volume`
from 
    ranked_data
where 
    rn <= 5;