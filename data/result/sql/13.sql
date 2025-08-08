with total_applications as (
    select 
        property_area,
        count(*) as total_count
    from 
        ant_icube_dev.di_finance_loan_approval_prediction_data
    group by 
        property_area
),
approved_applications as (
    select 
        property_area,
        count(*) as approved_count
    from 
        ant_icube_dev.di_finance_loan_approval_prediction_data
    where 
        loan_status = 'Y'
    group by 
        property_area
)
select
    t.property_area as `区域`,
    coalesce(a.approved_count, 0) as `批准数量`,
    t.total_count as `总申请量`,
    round((coalesce(a.approved_count, 0) / t.total_count) * 100, 2) as `批准率`
from 
    total_applications t
left join 
    approved_applications a 
on 
    t.property_area = a.property_area;