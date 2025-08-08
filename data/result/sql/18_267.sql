with tourism_data as (
    select 
        country,
        cast(percentage_of_gdp as double) as percentage_of_gdp,
        cast(receipts_in_billions as double) as receipts_in_billions
    from ant_icube_dev.world_economic_tourism
),
unemployment_data as (
    select 
        country,
        cast(unemployment_rate as double) as unemployment_rate
    from ant_icube_dev.world_economic_unemployment
),
corruption_data as (
    select 
        country,
        cast(corruption_index as double) as corruption_index
    from ant_icube_dev.world_economic_corruption
)

select
    t.country as `country`,
    c.corruption_index as `corruption_index`,
    u.unemployment_rate as `unemployment_rate`
from tourism_data t
join unemployment_data u on t.country = u.country
join corruption_data c on u.country = c.country
where
    t.receipts_in_billions > 0.5 and t.percentage_of_gdp > 0.05;