with company_valuations as (
    select 
        company,
        country,
        cast(substr(valuation, 2) as double) as valuation_val
    from 
        ant_icube_dev.di_unicorn_startups
    where 
        company is not null
),
country_totals as (
    select 
        country,
        sum(valuation_val) as total_valuation
    from 
        company_valuations
    group by 
        country
),
ranked_companies as (
    select 
        cv.country,
        cv.company,
        cv.valuation_val,
        ct.total_valuation,
        row_number() over (
            partition by cv.country 
            order by cv.valuation_val desc
        ) as company_rank
    from 
        company_valuations cv
    inner join 
        country_totals ct 
    on 
        cv.country = ct.country
        )
select
    country as `国家`,
    company as `公司`,
    round((valuation_val / total_valuation) * 100, 2) as `估值占比`
    from
    ranked_companies
    where
    company_rank <= 3
    order by
    `国家`,
    `估值占比` desc;