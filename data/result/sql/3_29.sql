with date_range as (
    select
        max(to_date(date)) as max_date
    from
        ant_icube_dev.di_massive_yahoo_finance_dataset
),
daily_avg as (
    select
        date,
        avg(cast(volume as double)) as avg_volume
    from
        ant_icube_dev.di_massive_yahoo_finance_dataset
    where
        to_date(date) between date_sub((select max_date from date_range), 30) 
        and (select max_date from date_range)
    group by
        date
),
filtered_records as (
    select
        t.company,
        cast(t.volume as double) as volume
    from
        ant_icube_dev.di_massive_yahoo_finance_dataset t
    inner join daily_avg a on
        t.date = a.date
    where
        cast(t.volume as double) > a.avg_volume
),
company_volume as (
    select
        company,
        sum(volume) as total_volume
    from
        filtered_records
    group by
        company
),
ranked_companies as (
    select
        company,
        total_volume,
        row_number() over (order by total_volume desc) as rank
    from
        company_volume
)
select
    company as `公司`
from
    ranked_companies
where
    rank <= 10;