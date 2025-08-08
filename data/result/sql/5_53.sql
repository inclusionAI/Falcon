with country_counts as (
    select
        country,
        count(company) as num_companies
    from
        ant_icube_dev.di_unicorn_startups
    group by
        country
    having
        count(company) > 50
),
total_companies as (
    select
        sum(num_companies) as total
    from
        country_counts
)
select
    country as `国家`,
    num_companies as `公司数量`,
    rank() over (order by num_companies desc) as `排名`,
    num_companies / (select total from  total_companies)  as `比例`
from
    country_counts
order by
    num_companies desc