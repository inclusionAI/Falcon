with filtered_data as (
    select
        applicantincome,
        credit_history
    from
        ant_icube_dev.di_finance_loan_approval_prediction_data
    where
        property_area = 'Rural'
        and self_employed = 'Yes'
)

select
    credit_history as `信用历史`,
    avg(cast(applicantincome as double)) as `平均申请人收入`
from
    filtered_data
group by
    credit_history
having
    avg(cast(applicantincome as double)) < 10000
order by
    credit_history desc;