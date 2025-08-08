with filtered_data as (
    select 
        cast(dayslate as bigint) as dayslate,
        cast(invoiceamount as double) as invoiceamount
    from 
        ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
    where 
        disputed = 'Yes'
),
total_invoice as (
    select 
        sum(cast(invoiceamount as double)) as total_amount 
    from 
        ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
)
select
    avg(dayslate) as `平均逾期天数`,
    sum(invoiceamount) / (select total_amount from total_invoice) as `发票金额比例`
from 
    filtered_data;