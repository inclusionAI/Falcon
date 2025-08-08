with china_unicorn as (
    select
        industry,
        company,
        valuation
    from
        ant_icube_dev.di_unicorn_startups
    where
        country = 'China'
),
converted_valuation as (
    select
        industry,
        company,
        cast(replace(valuation, '$', '') as decimal) as valuation_num
    from
        china_unicorn
)
select
    industry as `行业`,
    company as `公司`,
    valuation_num as `估值`,
    row_number() over (
        partition by industry
        order by valuation_num desc
    ) as `排名`
from
    converted_valuation
order by
    industry,
    `排名`;