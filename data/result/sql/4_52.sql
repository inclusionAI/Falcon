with country_paperless_stats as (
    select 
        countrycode,
        (count(case when paperlessbill = 'Electronic' then 1 end) * 100.0 / count(*)) as electronic_percent,
        avg(cast(dayslate as bigint)) as avg_dayslate
    from 
        ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
    group by 
        countrycode
)


select
    countrycode as `countrycode`,
    electronic_percent as `electronic_ratio`,
    avg_dayslate as `avg_dayslate`
from 
    country_paperless_stats
where 
    electronic_percent > 52
    and avg_dayslate > 3