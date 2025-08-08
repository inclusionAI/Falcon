with industry_data as (
    select
        industry,
        datediff(
            to_date(current_date(), 'yyyy-MM-dd'),
            to_date(date_joined, 'MM\/dd\/yyyy')
        ) / 365.0 as years_since_joined
    from
        ant_icube_dev.di_unicorn_startups
        )
select
    industry as `industry`
    from
    industry_data
    group by
    industry
    having
    count(*) > 5
    and avg(years_since_joined) < 10;