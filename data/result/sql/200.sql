with customer_age as (
    select 
        customer_segment,
        cast(avg(cast(age as bigint)) as double) as avg_age
    from 
        ant_icube_dev.credit_card_customer_base
    group by 
        customer_segment
    having 
        avg(cast(age as bigint)) > 30
)
select 
    customer_segment as `客户分组`,
    avg_age as `平均年龄`,
    (avg_age - 30) as `年龄差`
from 
    customer_age;