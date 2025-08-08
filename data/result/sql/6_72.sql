with filtered_data as (
    select 
        category,
        sub_category,
        amount
    from 
        ant_icube_dev.di_sales_dataset
    where 
        city = 'Chicago'
        )
select
    concat(category, ' - ', sub_category) as `类别-子类别`,
    sum(cast(amount as double)) as `总销售额`
    from 
    filtered_data
    group by
    category,
    sub_category
    having
    sum(cast(amount as double)) > 10000
    order by
    category asc;