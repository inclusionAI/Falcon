with converted_data as (
    select 
        gender,
        cast(age as int) as age
    from 
        ant_icube_dev.di_finance_data
    where 
        age rlike '^[0-9]+$'
)
select
    gender as `性别`,
    avg(age) as `平均年龄`
from 
    converted_data
group by 
    gender
order by 
    `平均年龄`;